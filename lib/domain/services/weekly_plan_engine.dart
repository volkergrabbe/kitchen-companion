// lib/domain/services/weekly_plan_engine.dart
//
// Wochenplan-Engine — Kernfeature der App v2.0.

import 'dart:collection';
import 'dart:math';

import 'package:drift/drift.dart';

import '../../data/database/database.dart';
import 'contraindication_checker.dart';

class WeeklyPlanEngine {
  final AppDatabase _db;
  final ContraindicationChecker _contraindicationChecker;
  final Random Function(int seed)? _randomFactory;

  WeeklyPlanEngine(
    this._db,
    this._contraindicationChecker, {
    Random? random,
    Random Function(int seed)? randomFactory,
  }) : _randomFactory = randomFactory ??
            ((int seed) => Random(seed)) {
    // P0-4 (Architecture Review): Wenn ein `random` übergeben wird,
    // ignorieren wir den Konstruktor-Seed und nutzen die Instanz direkt.
    // Andernfalls erzeugen wir für jeden Plan einen deterministischen
    // Seed aus weekStart (siehe generatePlan).
    _explicitRandom = random;
  }

  Random? _explicitRandom;

  static const List<String> _mealTypes = ['breakfast', 'lunch', 'dinner'];

  static DateTime currentWeekStart([DateTime? now]) {
    final today = now ?? DateTime.now();
    final daysSinceMonday = (today.weekday - DateTime.monday) % 7;
    final monday = DateTime(today.year, today.month, today.day)
        .subtract(Duration(days: daysSinceMonday));
    return monday;
  }

  /// P0-4 (Architecture Review): Erzeugt einen deterministischen
  /// Random aus einem Datum. Gleicher weekStart → gleicher Plan.
  /// Wir nutzen den Hash-Code, der sich aus Jahr/Monat/Tag ergibt.
  static int seedFromWeekStart(DateTime weekStart) {
    final ymd =
        weekStart.year * 10000 + weekStart.month * 100 + weekStart.day;
    // Hash mit XOR und Shift für bessere Verteilung (Hash-Code
    // allein ist nicht kollisionsfrei, reicht aber für Seed).
    return ymd ^ 0x5bd1e995;
  }

  Random _randomForWeek(DateTime weekStart) {
    if (_explicitRandom != null) return _explicitRandom!;
    return _randomFactory!(seedFromWeekStart(weekStart));
  }

  Future<WeeklyPlan> generatePlan({
    DateTime? weekStart,
    required int persons,
  }) async {
    final start = weekStart ?? currentWeekStart();
    if (persons < 1 || persons > 4) {
      throw ArgumentError('Persons muss zwischen 1 und 4 sein (war: $persons)');
    }

    // P0-4 (Architecture Review): Random wird pro Plan deterministisch
    // aus weekStart erzeugt. Gleicher weekStart → gleicher Plan.
    final random = _randomForWeek(start);

    final planId = await _db.addPlan(WeeklyPlansCompanion.insert(
      weekStart: start,
      persons: Value(persons),
      status: const Value('draft'),
      createdAt: DateTime.now(),
    ));

    final recipes = await _db.select(_db.recipes).get();
    if (recipes.isEmpty) {
      return (await (_db.select(_db.weeklyPlans)..where((p) => p.id.equals(planId)))
          .getSingle());
    }

    final activeOffers = await _loadActiveOffers();
    final offerByIngredient = _indexOffersByIngredient(activeOffers);

    final scored = <_ScoredRecipe>[];
    for (final recipe in recipes) {
      final contraResult = await _contraindicationChecker.scoreRecipe(recipe);
      final offerBonus = _offerBonusForRecipe(recipe, offerByIngredient);
      final seasonalityBonus = _seasonalityBonusForRecipe(recipe);
      final total = max(0, contraResult.score + offerBonus + seasonalityBonus);
      scored.add(_ScoredRecipe(
        recipe: recipe,
        contraindicationScore: contraResult.score,
        contraindicationReasons: contraResult.reasons,
        offerBonus: offerBonus,
        totalScore: total,
      ));
    }

    scored.sort((a, b) => b.totalScore.compareTo(a.totalScore));
    final pool = scored.take(max(21, scored.length ~/ 2 + 1)).toList();

    final recipeUsageCount = HashMap<int, int>();
    final selected = <_ScoredRecipe>[];
    int poolIndex = 0;

    while (selected.length < 21 && pool.isNotEmpty) {
      _ScoredRecipe? pick;
      if (selected.length < 7) {
        pick = pool[poolIndex % pool.length];
        poolIndex++;
      } else {
        final candidates = pool.take(15).toList()
          ..where((r) => (recipeUsageCount[r.recipe.id] ?? 0) < 2)
          .toList();
        if (candidates.isEmpty) {
          pick = pool[0];
        } else {
          pick = candidates[random.nextInt(candidates.length)];
        }
      }
      selected.add(pick);
      recipeUsageCount[pick.recipe.id] =
          (recipeUsageCount[pick.recipe.id] ?? 0) + 1;
    }

    for (var day = 0; day < 7; day++) {
      for (var mealIdx = 0; mealIdx < 3; mealIdx++) {
        final idx = day * 3 + mealIdx;
        if (idx >= selected.length) break;
        final recipe = selected[idx].recipe;
        await _db.into(_db.planMeals).insert(
              PlanMealsCompanion.insert(
                planId: planId,
                date: start.add(Duration(days: day)),
                mealType: _mealTypes[mealIdx],
                recipeId: Value(recipe.id),
                serves: Value(persons),
              ),
            );
      }
    }

    final ingredientAggregates =
        await _aggregatePlanIngredients(planId, persons);

    for (final agg in ingredientAggregates.entries) {
      final offer = offerByIngredient[agg.key]?.firstOrNull;
      await _db.into(_db.planIngredients).insert(
            PlanIngredientsCompanion.insert(
              planId: planId,
              ingredientId: agg.key,
              totalQuantity: agg.value.quantity,
              unit: Value(agg.value.unit),
              offerId: Value(offer?.id),
            ),
          );
    }

    await (_db.update(_db.weeklyPlans)..where((p) => p.id.equals(planId)))
        .write(const WeeklyPlansCompanion(status: Value('active')));

    return (await (_db.select(_db.weeklyPlans)..where((p) => p.id.equals(planId)))
        .getSingle());
  }

  Future<List<Offer>> _loadActiveOffers() {
    return (_db.select(_db.offers)
          ..where((o) => o.validTo.isBiggerThanValue(DateTime.now())))
        .get();
  }

  Future<Map<int, _IngredientAggregate>> _aggregatePlanIngredients(
      int planId, int persons) async {
    // P0-3 (Architecture Review): Vorher gab es pro Mahlzeit einen
    // eigenen SELECT auf recipe_ingredients — bei 21 Mahlzeiten
    // = 21 Round-Trips. Jetzt: ein JOIN über plan_meals →
    // recipe_ingredients → ingredients, Group-By in Dart.
    //
    // Anmerkung: Eine echte SQL-Aggregation (SUM/GROUP BY) wäre
    // minimal schneller, aber dann müssten wir `serves` aus
    // plan_meals mit quantityPerPerson aus recipe_ingredients
    // multiplizieren — das geht nur in SQLite mit einem JOIN +
    // SUM(product), und der Drift-Query wird dadurch komplexer.
    // Bei <100 Mahlzeiten pro Plan ist die In-Memory-Aggregation
    // hier schneller als ein zusätzlicher Round-Trip.
    final joined = await (_db.select(_db.planMeals).join([
      innerJoin(
        _db.recipeIngredients,
        _db.recipeIngredients.recipeId.equalsExp(_db.planMeals.recipeId),
      ),
    ])
          ..where(_db.planMeals.planId.equals(planId)))
        .get();

    final aggregates = HashMap<int, _IngredientAggregate>();

    for (final row in joined) {
      final meal = row.readTable(_db.planMeals);
      final ri = row.readTable(_db.recipeIngredients);
      // meal.recipeId kann theoretisch null sein (Custom-Meals).
      // Der INNER JOIN filtert diese automatisch raus — gut.
      // serves ist pro Mahlzeit (kann variieren, z.B. Snack).
      final totalQty = ri.quantityPerPerson * meal.serves;

      final existing = aggregates[ri.ingredientId];
      if (existing == null) {
        aggregates[ri.ingredientId] = _IngredientAggregate(
          quantity: totalQty,
          unit: ri.unit,
        );
      } else {
        existing.quantity += totalQty;
      }
    }

    return aggregates;
  }

  Map<int, List<Offer>> _indexOffersByIngredient(List<Offer> offers) {
    final map = HashMap<int, List<Offer>>();
    for (final o in offers) {
      final id = o.ingredientId;
      if (id == null) continue;
      map.putIfAbsent(id, () => []).add(o);
    }
    for (final list in map.values) {
      list.sort((a, b) => a.price.compareTo(b.price));
    }
    return map;
  }

  int _offerBonusForRecipe(
      Recipe recipe, Map<int, List<Offer>> offerByIngredient) {
    return 0;
  }

  int _seasonalityBonusForRecipe(Recipe recipe) {
    return 0;
  }
}

class _ScoredRecipe {
  final Recipe recipe;
  final int contraindicationScore;
  final List<String> contraindicationReasons;
  final int offerBonus;
  final int totalScore;

  _ScoredRecipe({
    required this.recipe,
    required this.contraindicationScore,
    required this.contraindicationReasons,
    required this.offerBonus,
    required this.totalScore,
  });
}

class _IngredientAggregate {
  double quantity;
  final String? unit;

  _IngredientAggregate({required this.quantity, this.unit});
}