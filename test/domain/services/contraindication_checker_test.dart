// test/domain/services/contraindication_checker_test.dart
//
// P0-2 (Patient-Safety, GLM-5.2 Review): Unit-Tests für die reine
// Bewertungs-Logik `scoreRecipePure`.
//
// Diese Tests sind DB-frei — sie testen die Deduplizierungs-Invariante
// direkt: Eine Zutat, die sowohl über ihren Namen als auch über ihre
// Risk-Tags eine Kontraindikation triggert, darf die Penalty nur
// EINMAL erhalten.

import 'package:flutter_test/flutter_test.dart';
import 'package:kitchen_companion/domain/services/contraindication_checker.dart';

void main() {
  group('scoreRecipePure — P0-2 Patient-Safety (Deduplizierung)', () {
    test('Boundary: keine aktiven Kontraindikationen → Score 100', () {
      final result = scoreRecipePure(
        const [
          ContraindicationScoring(
              ingredientName: 'Tomate', riskTagsJson: '[]'),
        ],
        const [],
      );
      expect(result.score, 100);
      expect(result.reasons, isEmpty);
    });

    test('Name-Match-only: Eine Zutat, eine limit-Kontraindikation, '
        'Score -= 30', () {
      final result = scoreRecipePure(
        const [
          ContraindicationScoring(
              ingredientName: 'Weizenmehl', riskTagsJson: '[]'),
        ],
        const [
          ActiveContraindicationScoring(
            displayNameDe: 'Zöliakie',
            excludedIngredientsJson: '["Weizenmehl"]',
            excludedRiskTagsJson: '[]',
            severity: 'limit',
          ),
        ],
      );
      expect(result.score, 70); // 100 - 30
      expect(result.reasons, ['Zöliakie']);
    });

    test('Tag-Match-only: Eine Zutat mit Risk-Tag, eine caution-'
        'Kontraindikation, Score -= 10', () {
      final result = scoreRecipePure(
        const [
          ContraindicationScoring(
            ingredientName: 'Grünkohl',
            riskTagsJson: '["high_vitamin_k"]',
          ),
        ],
        const [
          ActiveContraindicationScoring(
            displayNameDe: 'Marcumar-Therapie',
            excludedIngredientsJson: '[]',
            excludedRiskTagsJson: '["high_vitamin_k"]',
            severity: 'caution',
          ),
        ],
      );
      expect(result.score, 90); // 100 - 10
      expect(result.reasons, ['Marcumar-Therapie']);
    });

    test('P0-2 DEDUP-BEWEIS: Name + Tag auf DIESELBE Zutat triggert '
        'limit nur EINMAL (Score 70, NICHT 40)', () {
      // Vorher (Bug): zwei verschachtelte for-Loops → 30+30=60 → Score 40
      // Nachher (Fix): matchedIndices-Set → 30 einmal → Score 70
      final result = scoreRecipePure(
        const [
          ContraindicationScoring(
            ingredientName: 'Weizenmehl',
            // Risk-Tag entspricht der Kontraindikation:
            riskTagsJson: '["gluten"]',
          ),
        ],
        const [
          ActiveContraindicationScoring(
            displayNameDe: 'Zöliakie',
            // Beides matcht:
            excludedIngredientsJson: '["Weizenmehl"]',
            excludedRiskTagsJson: '["gluten"]',
            severity: 'limit',
          ),
        ],
      );
      // Genau 100 - 30 = 70. Wäre der Bug aktiv, wäre Score = 40.
      expect(
        result.score,
        70,
        reason:
            'Deduplizierungs-Bug: Penalty darf nur EINMAL abgezogen werden, '
            'wenn dieselbe Zutat sowohl per Name als auch per Tag matcht. '
            'Score=70 ist korrekt; Score=40 wäre der alte Bug.',
      );
      expect(result.reasons, ['Zöliakie']);
    });

    test('P0-2 DEDUP-BEWEIS (caution): Name+Tag auf dieselbe Zutat '
        '→ Score 90, NICHT 80', () {
      // Symmetrisch zum vorherigen Test, aber mit caution-Severity.
      // Bug-Wert wäre 80, Fix-Wert ist 90.
      final result = scoreRecipePure(
        const [
          ContraindicationScoring(
            ingredientName: 'Spinat',
            riskTagsJson: '["high_vitamin_k"]',
          ),
        ],
        const [
          ActiveContraindicationScoring(
            displayNameDe: 'Vitamin-K-Antagonist',
            excludedIngredientsJson: '["Spinat"]',
            excludedRiskTagsJson: '["high_vitamin_k"]',
            severity: 'caution',
          ),
        ],
      );
      expect(result.score, 90, reason: 'Nur 10 Penalty, nicht 20');
      expect(result.reasons, ['Vitamin-K-Antagonist']);
    });

    test('Boundary: avoid-Severity → Score 0 + Meiden-Hinweis', () {
      final result = scoreRecipePure(
        const [
          ContraindicationScoring(
              ingredientName: 'Erdnuss', riskTagsJson: '[]'),
        ],
        const [
          ActiveContraindicationScoring(
            displayNameDe: 'Erdnussallergie',
            excludedIngredientsJson: '["Erdnuss"]',
            excludedRiskTagsJson: '[]',
            severity: 'avoid',
          ),
        ],
      );
      expect(result.score, 0);
      expect(result.reasons, ['Meiden: Erdnussallergie']);
    });

    test('Kumulativ: mehrere Kontraindikationen, jede zieht ihre '
        'eigene Penalty', () {
      // Weizenmehl → limit (Zöliakie) -30
      // Grüner Tee → caution (Marcumar) -10
      // Score = 60
      final result = scoreRecipePure(
        const [
          ContraindicationScoring(
              ingredientName: 'Weizenmehl', riskTagsJson: '[]'),
          ContraindicationScoring(
            ingredientName: 'Grüner Tee',
            riskTagsJson: '["high_vitamin_k"]',
          ),
          ContraindicationScoring(
              ingredientName: 'Salz', riskTagsJson: '[]'),
        ],
        const [
          ActiveContraindicationScoring(
            displayNameDe: 'Zöliakie',
            excludedIngredientsJson: '["Weizenmehl"]',
            excludedRiskTagsJson: '[]',
            severity: 'limit',
          ),
          ActiveContraindicationScoring(
            displayNameDe: 'Marcumar-Therapie',
            excludedIngredientsJson: '[]',
            excludedRiskTagsJson: '["high_vitamin_k"]',
            severity: 'caution',
          ),
        ],
      );
      expect(result.score, 60); // 100 - 30 - 10
      expect(result.reasons, ['Zöliakie', 'Marcumar-Therapie']);
    });

    test('Score-Clamp: bei mehreren limit-Kontraindikationen wird '
        'Score auf 0 begrenzt (nicht negativ)', () {
      final result = scoreRecipePure(
        const [
          ContraindicationScoring(
              ingredientName: 'Weizenmehl', riskTagsJson: '[]'),
          ContraindicationScoring(
              ingredientName: 'Laktose', riskTagsJson: '[]'),
          ContraindicationScoring(
              ingredientName: 'Erdnuss', riskTagsJson: '[]'),
          ContraindicationScoring(
              ingredientName: 'Soja', riskTagsJson: '[]'),
        ],
        const [
          ActiveContraindicationScoring(
            displayNameDe: 'Zöliakie',
            excludedIngredientsJson: '["Weizenmehl"]',
            excludedRiskTagsJson: '[]',
            severity: 'limit',
          ),
          ActiveContraindicationScoring(
            displayNameDe: 'Laktoseintoleranz',
            excludedIngredientsJson: '["Laktose"]',
            excludedRiskTagsJson: '[]',
            severity: 'limit',
          ),
          ActiveContraindicationScoring(
            displayNameDe: 'Erdnussallergie',
            excludedIngredientsJson: '["Erdnuss"]',
            excludedRiskTagsJson: '[]',
            severity: 'limit',
          ),
          ActiveContraindicationScoring(
            displayNameDe: 'Sojaallergie',
            excludedIngredientsJson: '["Soja"]',
            excludedRiskTagsJson: '[]',
            severity: 'limit',
          ),
        ],
      );
      expect(result.score, 0); // 100 - 4*30 = -20 → clamp auf 0
      expect(result.reasons.length, 4);
    });

    test('Multi-Ingredient: zwei Zutaten matchen dieselbe Kontraindikation '
        'über Name — Penalty wird NUR EINMAL abgezogen '
        '(Design-Entscheidung, Single-Penalty-per-Contraindication)', () {
      // Design-Hinweis: Bei dieser Kontraindikation-Treffer-Logik wird
      // pro Kontraindikation EINE Penalty berechnet, unabhängig davon,
      // wie viele Zutaten matchen. Begründung: Eine diagnostizierte
      // Kontraindikation (z.B. Zöliakie) ist ein **absolutes** Risiko —
      // die Anzahl glutenhaltiger Zutaten verändert das Risiko nicht
      // qualitativ (es gibt keine "ein bisschen Zöliakie"). Der Score
      // bleibt deshalb bei 90, nicht bei 80.
      //
      // Vorher (alter Buggy-Code): 10 (Match 1) + 10 (Match 2) = 20 → 80
      // Nachher (Fix): eine Penalty pro Kontraindikation → 10 → 90
      //
      // HINWEIS: Dies ist eine bewusste Design-Änderung gegenüber dem
      // GLM-5.2-Vorschlag (der das alte Verhalten mit "Penalty pro
      // Zutat" implizit beibehielt). Aus medizinischer Sicht ist die
      // neue Variante konservativer im UI (immer noch gelb/orange bei
      // Gluten-Rezepturen für Zöliakie-Patienten) und konsistenter.
      final result = scoreRecipePure(
        const [
          ContraindicationScoring(
              ingredientName: 'Weizenmehl', riskTagsJson: '[]'),
          ContraindicationScoring(
              ingredientName: 'Gerste', riskTagsJson: '[]'),
        ],
        const [
          ActiveContraindicationScoring(
            displayNameDe: 'Gluten-Unverträglichkeit',
            excludedIngredientsJson: '["Weizenmehl","Gerste"]',
            excludedRiskTagsJson: '[]',
            severity: 'caution',
          ),
        ],
      );
      expect(result.score, 90);
      expect(result.reasons, ['Gluten-Unverträglichkeit']);
    });

    test('Robustheit: Korrupte JSON-Strings werden ignoriert, '
        'Score bleibt 100', () {
      final result = scoreRecipePure(
        const [
          ContraindicationScoring(
              ingredientName: 'Tomate', riskTagsJson: '{{{invalid'),
        ],
        const [
          ActiveContraindicationScoring(
            displayNameDe: 'Defekte Kontraindikation',
            excludedIngredientsJson: 'not-a-json',
            excludedRiskTagsJson: 'also-not-json',
            severity: 'limit',
          ),
        ],
      );
      // Da die JSON-Listen leer geparst werden, gibt es keinen Match.
      expect(result.score, 100);
      expect(result.reasons, isEmpty);
    });

    test('Robustheit: Unbekannte Severity wird als "caution" behandelt',
        () {
      final result = scoreRecipePure(
        const [
          ContraindicationScoring(
              ingredientName: 'X', riskTagsJson: '[]'),
        ],
        const [
          ActiveContraindicationScoring(
            displayNameDe: 'Test',
            excludedIngredientsJson: '["X"]',
            excludedRiskTagsJson: '[]',
            severity: 'unknown-future-value',
          ),
        ],
      );
      // 'unknown' → fallback caution → -10
      expect(result.score, 90);
    });
  });
}