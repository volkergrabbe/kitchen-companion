// lib/domain/services/contraindication_checker.dart
//
// Bewertet ein Rezept gegen die aktiven User-Kontraindikationen.
// Reine regelbasierte Logik — kein LLM, schnell & deterministisch.

import 'dart:convert';

import 'package:drift/drift.dart';

import '../../data/database/database.dart';

enum ContraindicationSeverity { avoid, limit, caution }

class ContraindicationResult {
  final int score; // 0-100, höher = besser
  final List<String> reasons; // Erklärungen für UI

  ContraindicationResult({required this.score, required this.reasons});

  ContraindicationResult.zero()
      : score = 0,
        reasons = const [];

  ContraindicationResult copyWith({int? score, List<String>? reasons}) {
    return ContraindicationResult(
      score: score ?? this.score,
      reasons: reasons ?? this.reasons,
    );
  }
}

/// P0-2 (Patient-Safety, GLM-5.2 Review): Pure-Bewertungs-Logik ohne
/// DB-Abhängigkeit. Erlaubt Unit-Tests ohne Drift-/SQLite-Setup.
///
/// Eingabe-Sicht:
/// - [recipeIngredients]: Rezept-Zutaten mit (ingredientName, riskTagsJson)
/// - [activeContraindications]: aktive Kontraindikationen mit
///   (displayNameDe, excludedIngredientsJson, excludedRiskTagsJson, severity)
///
/// Wichtige Invariante (Fix für Deduplizierungs-Bug): Für jede
/// Kontraindikation wird pro Zutat maximal **eine** Penalty berechnet,
/// auch wenn die Zutat sowohl per Name als auch per Risk-Tag matcht.
class ContraindicationScoring {
  final String ingredientName;
  final String riskTagsJson;
  const ContraindicationScoring({
    required this.ingredientName,
    required this.riskTagsJson,
  });
}

class ActiveContraindicationScoring {
  final String displayNameDe;
  final String excludedIngredientsJson;
  final String excludedRiskTagsJson;
  final String severity;
  const ActiveContraindicationScoring({
    required this.displayNameDe,
    required this.excludedIngredientsJson,
    required this.excludedRiskTagsJson,
    required this.severity,
  });
}

/// Pure-Bewertungs-Funktion (DB-frei, gut testbar).
///
/// P0-2 (Patient-Safety): Deduplizierungs-Bug behoben — eine Zutat,
/// die sowohl über `excludedIngredientNames` als auch über
/// `excludedRiskTags` auf dieselbe Kontraindikation matcht, wird nur
/// **einmal** gewertet. Vorher: zwei verschachtelte for-Loops addierten
/// die Penalty doppelt (z.B. 30+30=60 statt 30 für 'limit').
ContraindicationResult scoreRecipePure(
  List<ContraindicationScoring> recipeIngredients,
  List<ActiveContraindicationScoring> activeContraindications,
) {
  if (activeContraindications.isEmpty) {
    return ContraindicationResult(score: 100, reasons: const []);
  }

  int score = 100;
  final reasons = <String>[];

  for (final contra in activeContraindications) {
    final excludedIngredientNames = _parseJsonListStatic(
      contra.excludedIngredientsJson,
    );
    final excludedRiskTags = _parseJsonListStatic(
      contra.excludedRiskTagsJson,
    );
    final severity = _parseSeverityStatic(contra.severity);
    final penalty = _penaltyForSeverityStatic(severity);

    // P0-2 (Patient-Safety): Set mit Indizes der Zutaten, die diese
    // Kontraindikation bereits getriggert haben. Verhindert Doppel-
    // Penalty wenn dieselbe Zutat sowohl im Name-Set als auch im
    // Risk-Tag-Set matcht.
    final matchedIndices = <int>{};

    for (var i = 0; i < recipeIngredients.length; i++) {
      final ing = recipeIngredients[i];
      final hitsByName = excludedIngredientNames.contains(ing.ingredientName);
      final hitsByTag = () {
        if (excludedRiskTags.isEmpty) return false;
        final ingTags = _parseJsonListStatic(ing.riskTagsJson);
        return ingTags.any(excludedRiskTags.contains);
      }();

      if (!hitsByName && !hitsByTag) continue;
      matchedIndices.add(i);

      // 'avoid' = sofortiger Score 0 (Rezept raus), unabhängig davon,
      // welche Match-Variante getroffen hat.
      if (penalty >= 100) {
        return ContraindicationResult(
          score: 0,
          reasons: ['Meiden: ${contra.displayNameDe}'],
        );
      }
    }

    // Penalty nur einmal pro Zutat abziehen (matchedIndices dedupliziert).
    if (matchedIndices.isNotEmpty) {
      score -= penalty;
      if (!reasons.contains(contra.displayNameDe)) {
        reasons.add(contra.displayNameDe);
      }
    }
  }

  if (score < 0) score = 0;
  return ContraindicationResult(score: score, reasons: reasons);
}

class ContraindicationChecker {
  final AppDatabase _db;
  ContraindicationChecker(this._db);

  /// Bewertet ein Rezept: 100 = optimal, 0 = meiden.
  /// Regel-Penalty:
  ///   - 'avoid'   → Rezept sofort raus (Score = 0)
  ///   - 'limit'   → Score -= 30, Hinweis
  ///   - 'caution' → Score -= 10, Hinweis
  ///
  /// P0-2 (Patient-Safety, GLM-5.2 Review): DB-Load + Pure-Bewertung
  /// sind getrennt — die Bewertung selbst ist [scoreRecipePure] und
  /// in `test/domain/services/contraindication_checker_test.dart`
  /// dediziert getestet.
  Future<ContraindicationResult> scoreRecipe(Recipe recipe) async {
    final activeUserContraindications =
        await _db.watchActiveUserContraindications().first;
    if (activeUserContraindications.isEmpty) {
      return ContraindicationResult(score: 100, reasons: const []);
    }

    // Rezepte Ingredients laden
    final recipeIngredientsQuery = _db.select(_db.recipeIngredients).join([
      innerJoin(
        _db.ingredients,
        _db.ingredients.id.equalsExp(_db.recipeIngredients.ingredientId),
      ),
    ])
      ..where(_db.recipeIngredients.recipeId.equals(recipe.id));

    final recipeIngredients = await recipeIngredientsQuery.get();

    // In Pure-Eingabe-Sicht übersetzen
    final scoring = recipeIngredients
        .map((ri) {
          final ing = ri.readTable(_db.ingredients);
          return ContraindicationScoring(
            ingredientName: ing.name,
            riskTagsJson: ing.riskTagsJson,
          );
        })
        .toList();

    final activeScoring = activeUserContraindications
        .map((entry) {
          final c = entry.contraindication;
          return ActiveContraindicationScoring(
            displayNameDe: c.displayNameDe,
            excludedIngredientsJson: c.excludedIngredientsJson,
            excludedRiskTagsJson: c.excludedRiskTagsJson,
            severity: c.severity,
          );
        })
        .toList();

    return scoreRecipePure(scoring, activeScoring);
  }

  // ─── Instance-Helpers (deprecated paths für Backward-Compat) ───
  // Diese werden durch die Pure-Versionen ersetzt, bleiben aber für
  // vorhandene Aufrufer erhalten.
  // ignore: unused_element
  int _penaltyForSeverity(ContraindicationSeverity severity) =>
      _penaltyForSeverityStatic(severity);

  // ignore: unused_element
  ContraindicationSeverity _parseSeverity(String s) =>
      _parseSeverityStatic(s);

  // ignore: unused_element
  List<String> _parseJsonList(String json) => _parseJsonListStatic(json);
}

// ─── Static Pure-Helpers ───

int _penaltyForSeverityStatic(ContraindicationSeverity severity) {
  switch (severity) {
    case ContraindicationSeverity.avoid:
      return 100;
    case ContraindicationSeverity.limit:
      return 30;
    case ContraindicationSeverity.caution:
      return 10;
  }
}

ContraindicationSeverity _parseSeverityStatic(String s) {
  switch (s) {
    case 'avoid':
      return ContraindicationSeverity.avoid;
    case 'limit':
      return ContraindicationSeverity.limit;
    case 'caution':
      return ContraindicationSeverity.caution;
    default:
      return ContraindicationSeverity.caution;
  }
}

List<String> _parseJsonListStatic(String json) {
  try {
    final list = jsonDecode(json);
    if (list is List) {
      return list.map((e) => e.toString()).toList();
    }
  } catch (_) {}
  return const [];
}