// lib/data/database/seed.dart
//
// Seed-Daten für Discounter, Kontraindikationen und Default-Ingredients.
// Werden beim ersten Start in die DB geschrieben.

import 'dart:convert';

import 'package:drift/drift.dart';

import 'database.dart';

class SeedData {
  /// Schreibt alle Seed-Daten, falls noch nicht vorhanden.
  static Future<void> ensureSeeded(AppDatabase db) async {
    await _seedDiscounters(db);
    await _seedContraindications(db);
    await _seedIngredients(db);
  }

  // ─── Discounter (DE) ───
  static Future<void> _seedDiscounters(AppDatabase db) async {
    final existing = await db.select(db.discounters).get();
    if (existing.isNotEmpty) return;

    final seed = <DiscountersCompanion>[
      DiscountersCompanion.insert(
        name: 'Aldi Nord',
        scraperClass: 'AldiNordScraper',
      ),
      DiscountersCompanion.insert(
        name: 'Aldi Süd',
        scraperClass: 'AldiSuedScraper',
      ),
      DiscountersCompanion.insert(
        name: 'Lidl',
        scraperClass: 'LidlScraper',
      ),
      DiscountersCompanion.insert(
        name: 'Rewe',
        scraperClass: 'ReweScraper',
      ),
      DiscountersCompanion.insert(
        name: 'Netto',
        scraperClass: 'NettoScraper',
      ),
      DiscountersCompanion.insert(
        name: 'Penny',
        scraperClass: 'PennyScraper',
      ),
      DiscountersCompanion.insert(
        name: 'Norma',
        scraperClass: 'NormaScraper',
      ),
      // Marktguru als 8. Source, default disabled
      DiscountersCompanion.insert(
        name: 'Marktguru (API)',
        scraperClass: 'MarktguruApi',
        enabled: const Value(false),
        apiType: const Value('marktguru'),
        apiBaseUrl: const Value('https://api.marktguru.de/v1'),
        apiKeyEnv: const Value('MARKTGURU_API_KEY'),
      ),
    ];

    await db.batch((b) {
      for (final d in seed) {
        b.insert(db.discounters, d);
      }
    });
  }

  // ─── Kontraindikationen ───
  static Future<void> _seedContraindications(AppDatabase db) async {
    final existing = await db.select(db.contraindications).get();
    if (existing.isNotEmpty) return;

    final list = <ContraindicationsCompanion>[
      // ─── Krankheiten ───
      ContraindicationsCompanion.insert(
        type: 'disease',
        code: 'diabetes_t1',
        displayNameDe: 'Diabetes Typ 1',
        displayNameEn: 'Diabetes Type 1',
        excludedIngredientsJson: Value(jsonEncode(['Zucker', 'Weißmehl', 'Reis weiß'])),
        excludedRiskTagsJson: Value(jsonEncode(['high_simple_carbs'])),
        severity: const Value('avoid'),
        warningTextDe: const Value(
            'Kohlenhydratarme Mahlzeiten bevorzugen. Zucker und Weißmehl meiden.'),
        warningTextEn: const Value(
            'Prefer low-carb meals. Avoid sugar and white flour.'),
      ),
      ContraindicationsCompanion.insert(
        type: 'disease',
        code: 'diabetes_t2',
        displayNameDe: 'Diabetes Typ 2',
        displayNameEn: 'Diabetes Type 2',
        excludedIngredientsJson: Value(jsonEncode(['Zucker', 'Weißmehl'])),
        excludedRiskTagsJson: Value(jsonEncode(['high_simple_carbs'])),
        severity: const Value('limit'),
        warningTextDe: const Value(
            'Auf glykämische Last achten. Ballaststoffreiche Mahlzeiten.'),
        warningTextEn: const Value(
            'Watch glycemic load. High-fiber meals preferred.'),
      ),
      ContraindicationsCompanion.insert(
        type: 'disease',
        code: 'celiac',
        displayNameDe: 'Zöliakie (Gluten)',
        displayNameEn: 'Celiac Disease',
        excludedIngredientsJson: Value(jsonEncode([
          'Weizen',
          'Weißmehl',
          'Roggen',
          'Gerste',
          'Dinkel',
          'Hafer'
        ])),
        excludedRiskTagsJson: Value(jsonEncode(['contains_gluten'])),
        severity: const Value('avoid'),
        warningTextDe: const Value(
            'Strikt glutenfrei. Auch Spuren (Hafer nur zertifiziert glutenfrei).'),
        warningTextEn: const Value(
            'Strictly gluten-free. Avoid traces (oats only if certified GF).'),
      ),
      ContraindicationsCompanion.insert(
        type: 'disease',
        code: 'lactose_intolerance',
        displayNameDe: 'Laktoseintoleranz',
        displayNameEn: 'Lactose Intolerance',
        excludedIngredientsJson: Value(jsonEncode(['Milch', 'Sahne', 'Quark', 'Joghurt'])),
        excludedRiskTagsJson: Value(jsonEncode(['contains_lactose'])),
        severity: const Value('limit'),
        warningTextDe: const Value(
            'Laktosefreie Alternativen oder Hartkäse verwenden.'),
        warningTextEn: const Value(
            'Use lactose-free alternatives or aged cheese.'),
      ),
      ContraindicationsCompanion.insert(
        type: 'disease',
        code: 'fructose_malabsorption',
        displayNameDe: 'Fruktosemalabsorption',
        displayNameEn: 'Fructose Malabsorption',
        excludedIngredientsJson:
            Value(jsonEncode(['Apfel', 'Birne', 'Mango', 'Honig'])),
        excludedRiskTagsJson: Value(jsonEncode(['high_fructose'])),
        severity: const Value('limit'),
        warningTextDe: const Value(
            'Fruktosearme Obstsorten bevorzugen (Banane, Beeren).'),
        warningTextEn: const Value(
            'Prefer low-fructose fruits (banana, berries).'),
      ),
      ContraindicationsCompanion.insert(
        type: 'disease',
        code: 'histamine_intolerance',
        displayNameDe: 'Histaminintoleranz',
        displayNameEn: 'Histamine Intolerance',
        excludedIngredientsJson: Value(jsonEncode(
            ['Tomate', 'Spinat', 'Aubergine', 'Hartkäse', 'Salami'])),
        excludedRiskTagsJson: Value(jsonEncode(['high_histamine'])),
        severity: const Value('limit'),
        warningTextDe: const Value(
            'Frisch zubereiten, lange gereifte Lebensmittel meiden.'),
        warningTextEn: const Value(
            'Cook fresh, avoid long-aged foods.'),
      ),
      ContraindicationsCompanion.insert(
        type: 'disease',
        code: 'gout',
        displayNameDe: 'Gicht',
        displayNameEn: 'Gout',
        excludedIngredientsJson: Value(jsonEncode(
            ['Sardine', 'Hering', 'Innereien', 'Spargel'])),
        excludedRiskTagsJson: Value(jsonEncode(['high_purine'])),
        severity: const Value('limit'),
        warningTextDe: const Value('Purinarme Ernährung bevorzugen.'),
        warningTextEn: const Value('Prefer low-purine diet.'),
      ),
      ContraindicationsCompanion.insert(
        type: 'disease',
        code: 'kidney_insufficiency',
        displayNameDe: 'Niereninsuffizienz',
        displayNameEn: 'Kidney Insufficiency',
        excludedIngredientsJson: const Value('[]'),
        excludedRiskTagsJson: Value(jsonEncode(
            ['high_potassium', 'high_phosphorus'])),
        severity: const Value('limit'),
        warningTextDe: const Value(
            'Kalium- und phosphatarme Auswahl. Arzt/Ernährungsberatung konsultieren.'),
        warningTextEn: const Value(
            'Choose low-potassium and low-phosphorus foods. Consult doctor/dietitian.'),
      ),
      ContraindicationsCompanion.insert(
        type: 'disease',
        code: 'hypertension',
        displayNameDe: 'Bluthochdruck',
        displayNameEn: 'Hypertension',
        excludedIngredientsJson: const Value('[]'),
        excludedRiskTagsJson: Value(jsonEncode(['high_sodium'])),
        severity: const Value('limit'),
        warningTextDe: const Value('Salzarm kochen.'),
        warningTextEn: const Value('Cook low-sodium.'),
      ),
      ContraindicationsCompanion.insert(
        type: 'disease',
        code: 'pku',
        displayNameDe: 'Phenylketonurie (PKU)',
        displayNameEn: 'Phenylketonuria',
        excludedIngredientsJson: Value(jsonEncode(['Milch', 'Hühnerei', 'Rindfleisch'])),
        excludedRiskTagsJson: Value(jsonEncode(['high_phenylalanine'])),
        severity: const Value('avoid'),
        warningTextDe: const Value(
            'Strikt phenylalaninarme Diät. Nur unter ärztlicher Aufsicht.'),
        warningTextEn: const Value(
            'Strictly low-phenylalanine. Only under medical supervision.'),
      ),

      // ─── Medikamente ───
      ContraindicationsCompanion.insert(
        type: 'medication',
        code: 'warfarin',
        displayNameDe: 'Vitamin-K-Antagonisten (Marcumar/Warfarin)',
        displayNameEn: 'Vitamin K Antagonists (Warfarin)',
        excludedIngredientsJson: const Value('[]'),
        excludedRiskTagsJson: Value(jsonEncode(['high_vitamin_k'])),
        severity: const Value('caution'),
        warningTextDe: const Value(
            'Vitamin-K-reiche Lebensmittel (Grünkohl, Spinat, Brokkoli) in konstanter Menge, nicht vermeiden — Schwankungen sind problematisch. INR regelmäßig prüfen.'),
        warningTextEn: const Value(
            'Keep vitamin K intake constant — avoid fluctuations. Monitor INR regularly.'),
      ),
      ContraindicationsCompanion.insert(
        type: 'medication',
        code: 'statins',
        displayNameDe: 'Statine (Simvastatin, Atorvastatin)',
        displayNameEn: 'Statins',
        excludedIngredientsJson: const Value('[]'),
        excludedRiskTagsJson: Value(jsonEncode(['high_grapefruit'])),
        severity: const Value('avoid'),
        warningTextDe: const Value(
            'Grapefruit meiden — verstärkt Statin-Wirkung gefährlich.'),
        warningTextEn: const Value(
            'Avoid grapefruit — dangerous interaction.'),
      ),
      ContraindicationsCompanion.insert(
        type: 'medication',
        code: 'metformin',
        displayNameDe: 'Metformin',
        displayNameEn: 'Metformin',
        excludedIngredientsJson: const Value('[]'),
        excludedRiskTagsJson: Value(jsonEncode(['high_simple_carbs'])),
        severity: const Value('caution'),
        warningTextDe: const Value(
            'Kohlenhydratkonsistenz wichtig, um Blutzuckerschwankungen zu vermeiden.'),
        warningTextEn: const Value(
            'Consistent carb intake recommended.'),
      ),
      ContraindicationsCompanion.insert(
        type: 'medication',
        code: 'ace_inhibitors',
        displayNameDe: 'ACE-Hemmer (Ramipril, Enalapril)',
        displayNameEn: 'ACE Inhibitors',
        excludedIngredientsJson: const Value('[]'),
        excludedRiskTagsJson: Value(jsonEncode(['high_potassium'])),
        severity: const Value('caution'),
        warningTextDe: const Value(
            'Kaliumspiegel beobachten — kaliumreiche Lebensmittel in Maßen.'),
        warningTextEn: const Value(
            'Monitor potassium — high-potassium foods in moderation.'),
      ),
      ContraindicationsCompanion.insert(
        type: 'medication',
        code: 'levothyroxine',
        displayNameDe: 'Schilddrüsenhormone (L-Thyroxin)',
        displayNameEn: 'Thyroid Hormones',
        excludedIngredientsJson: const Value('[]'),
        excludedRiskTagsJson: Value(jsonEncode(['high_calcium', 'high_iron', 'goitrogenic'])),
        severity: const Value('caution'),
        warningTextDe: const Value(
            'Calcium, Eisen und Kohlgemüse zeitlich getrennt von Medikamenteneinnahme.'),
        warningTextEn: const Value(
            'Separate calcium, iron, and cruciferous veg from medication timing.'),
      ),
      ContraindicationsCompanion.insert(
        type: 'medication',
        code: 'mao_inhibitors',
        displayNameDe: 'MAO-Hemmer',
        displayNameEn: 'MAO Inhibitors',
        excludedIngredientsJson: Value(jsonEncode(['Hartkäse', 'Salami'])),
        excludedRiskTagsJson: Value(jsonEncode(['high_tyramine'])),
        severity: const Value('avoid'),
        warningTextDe: const Value(
            'Tyraminreiche Lebensmittel meiden — Blutdruckkrise möglich.'),
        warningTextEn: const Value(
            'Avoid tyramine-rich foods — risk of hypertensive crisis.'),
      ),
      ContraindicationsCompanion.insert(
        type: 'medication',
        code: 'corticosteroids',
        displayNameDe: 'Kortikosteroide (Prednisolon)',
        displayNameEn: 'Corticosteroids',
        excludedIngredientsJson: const Value('[]'),
        excludedRiskTagsJson: Value(jsonEncode(['high_simple_carbs', 'high_sodium'])),
        severity: const Value('caution'),
        warningTextDe: const Value(
            'Kohlenhydrat- und Salzkonsum beobachten — Gewichtszunahme möglich.'),
        warningTextEn: const Value(
            'Watch carb and salt intake — risk of weight gain.'),
      ),
      ContraindicationsCompanion.insert(
        type: 'medication',
        code: 'doxycycline',
        displayNameDe: 'Antibiotika (Tetracycline/Doxycyclin)',
        displayNameEn: 'Tetracycline Antibiotics',
        excludedIngredientsJson: const Value('[]'),
        excludedRiskTagsJson: Value(jsonEncode(['high_calcium', 'high_iron', 'high_magnesium'])),
        severity: const Value('avoid'),
        warningTextDe: const Value(
            'Calcium/Eisen/Magnesium 2h vor/nach Einnahme meiden — blockiert Aufnahme.'),
        warningTextEn: const Value(
            'Avoid calcium/iron/magnesium 2h before/after dose — blocks absorption.'),
      ),
      ContraindicationsCompanion.insert(
        type: 'medication',
        code: 'immunosuppressants',
        displayNameDe: 'Immunsuppressiva',
        displayNameEn: 'Immunosuppressants',
        excludedIngredientsJson: Value(jsonEncode(['Grapefruit'])),
        excludedRiskTagsJson: Value(jsonEncode(['high_grapefruit', 'high_potassium'])),
        severity: const Value('avoid'),
        warningTextDe: const Value(
            'Grapefruit meiden — gefährliche Wechselwirkung. Kalium überwachen.'),
        warningTextEn: const Value(
            'Avoid grapefruit — dangerous interaction. Monitor potassium.'),
      ),
      ContraindicationsCompanion.insert(
        type: 'medication',
        code: 'ppi',
        displayNameDe: 'Protonenpumpenhemmer (Omeprazol)',
        displayNameEn: 'Proton Pump Inhibitors',
        excludedIngredientsJson: const Value('[]'),
        excludedRiskTagsJson: Value(jsonEncode(['high_simple_carbs'])),
        severity: const Value('caution'),
        warningTextDe: const Value(
            'Langfristig: Magnesium- und B12-Spiegel beobachten.'),
        warningTextEn: const Value(
            'Long-term: monitor magnesium and B12 levels.'),
      ),
      ContraindicationsCompanion.insert(
        type: 'medication',
        code: 'diuretics',
        displayNameDe: 'Diuretika',
        displayNameEn: 'Diuretics',
        excludedIngredientsJson: const Value('[]'),
        excludedRiskTagsJson: Value(jsonEncode(['high_potassium', 'high_sodium'])),
        severity: const Value('caution'),
        warningTextDe: const Value(
            'Elektrolytbalance beachten — Kalium- und Natriumhaushalt.'),
        warningTextEn: const Value(
            'Watch electrolyte balance — potassium and sodium.'),
      ),
      ContraindicationsCompanion.insert(
        type: 'medication',
        code: 'lithium',
        displayNameDe: 'Lithium',
        displayNameEn: 'Lithium',
        excludedIngredientsJson: const Value('[]'),
        excludedRiskTagsJson: Value(jsonEncode(['high_sodium'])),
        severity: const Value('caution'),
        warningTextDe: const Value(
            'Kochsalzkonsum konstant halten — Schwankungen beeinflussen Lithium-Spiegel.'),
        warningTextEn: const Value(
            'Keep salt intake constant — fluctuations affect lithium levels.'),
      ),
      ContraindicationsCompanion.insert(
        type: 'medication',
        code: 'digoxin',
        displayNameDe: 'Digoxin',
        displayNameEn: 'Digoxin',
        excludedIngredientsJson: const Value('[]'),
        excludedRiskTagsJson: Value(jsonEncode(['high_potassium', 'high_fiber'])),
        severity: const Value('caution'),
        warningTextDe: const Value(
            'Kalium- und Ballaststoffzufuhr beachten.'),
        warningTextEn: const Value(
            'Watch potassium and fiber intake.'),
      ),
    ];

    await db.batch((b) {
      for (final c in list) {
        b.insert(db.contraindications, c);
      }
    });
  }

  // ─── Basis-Ingredients (~80 wichtige, weitere folgen via Seed-Files) ───
  static Future<void> _seedIngredients(AppDatabase db) async {
    final existing = await db.select(db.ingredients).get();
    if (existing.isNotEmpty) return;

    final list = <IngredientsCompanion>[
      // Gemüse
      IngredientsCompanion.insert(
          name: 'Tomate',
          category: const Value('gemüse'),
          seasonStart: const Value(7),
          seasonEnd: const Value(9),
          unitDefault: const Value('g'),
          allergensJson:
              const Value('[]'),
          riskTagsJson: const Value('["high_histamine"]')),
      IngredientsCompanion.insert(
          name: 'Zwiebel',
          category: const Value('gemüse'),
          seasonStart: const Value(0),
          seasonEnd: const Value(0),
          unitDefault: const Value('g')),
      IngredientsCompanion.insert(
          name: 'Karotte',
          category: const Value('gemüse'),
          seasonStart: const Value(0),
          seasonEnd: const Value(0),
          unitDefault: const Value('g')),
      IngredientsCompanion.insert(
          name: 'Kartoffel',
          category: const Value('gemüse'),
          seasonStart: const Value(0),
          seasonEnd: const Value(0),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["high_simple_carbs"]')),
      IngredientsCompanion.insert(
          name: 'Paprika',
          category: const Value('gemüse'),
          seasonStart: const Value(7),
          seasonEnd: const Value(10),
          unitDefault: const Value('stück')),
      IngredientsCompanion.insert(
          name: 'Zucchini',
          category: const Value('gemüse'),
          seasonStart: const Value(7),
          seasonEnd: const Value(9),
          unitDefault: const Value('stück')),
      IngredientsCompanion.insert(
          name: 'Brokkoli',
          category: const Value('gemüse'),
          seasonStart: const Value(6),
          seasonEnd: const Value(10),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["high_vitamin_k","goitrogenic"]')),
      IngredientsCompanion.insert(
          name: 'Spinat',
          category: const Value('gemüse'),
          seasonStart: const Value(4),
          seasonEnd: const Value(9),
          unitDefault: const Value('g'),
          riskTagsJson:
              const Value('["high_vitamin_k","high_iron","high_histamine","high_oxalate"]')),
      IngredientsCompanion.insert(
          name: 'Grünkohl',
          category: const Value('gemüse'),
          seasonStart: const Value(10),
          seasonEnd: const Value(2),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["high_vitamin_k"]')),
      IngredientsCompanion.insert(
          name: 'Salat',
          category: const Value('gemüse'),
          seasonStart: const Value(5),
          seasonEnd: const Value(9),
          unitDefault: const Value('stück')),
      IngredientsCompanion.insert(
          name: 'Aubergine',
          category: const Value('gemüse'),
          seasonStart: const Value(7),
          seasonEnd: const Value(9),
          unitDefault: const Value('stück'),
          riskTagsJson: const Value('["high_histamine"]')),
      IngredientsCompanion.insert(
          name: 'Knoblauch',
          category: const Value('gemüse'),
          seasonStart: const Value(0),
          seasonEnd: const Value(0),
          unitDefault: const Value('stück')),

      // Obst
      IngredientsCompanion.insert(
          name: 'Apfel',
          category: const Value('obst'),
          seasonStart: const Value(8),
          seasonEnd: const Value(10),
          unitDefault: const Value('stück'),
          riskTagsJson: const Value('["high_fructose"]')),
      IngredientsCompanion.insert(
          name: 'Banane',
          category: const Value('obst'),
          seasonStart: const Value(0),
          seasonEnd: const Value(0),
          unitDefault: const Value('stück')),
      IngredientsCompanion.insert(
          name: 'Birne',
          category: const Value('obst'),
          seasonStart: const Value(8),
          seasonEnd: const Value(10),
          unitDefault: const Value('stück'),
          riskTagsJson: const Value('["high_fructose"]')),
      IngredientsCompanion.insert(
          name: 'Zitrone',
          category: const Value('obst'),
          seasonStart: const Value(0),
          seasonEnd: const Value(0),
          unitDefault: const Value('stück')),
      IngredientsCompanion.insert(
          name: 'Erdbeeren',
          category: const Value('obst'),
          seasonStart: const Value(5),
          seasonEnd: const Value(7),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["high_histamine"]')),

      // Fleisch
      IngredientsCompanion.insert(
          name: 'Hähnchenbrust',
          category: const Value('fleisch'),
          unitDefault: const Value('g')),
      IngredientsCompanion.insert(
          name: 'Rindfleisch',
          category: const Value('fleisch'),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["high_phenylalanine"]')),
      IngredientsCompanion.insert(
          name: 'Schweinefleisch',
          category: const Value('fleisch'),
          unitDefault: const Value('g')),
      IngredientsCompanion.insert(
          name: 'Salami',
          category: const Value('fleisch'),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["high_histamine","high_tyramine","high_sodium"]')),
      IngredientsCompanion.insert(
          name: 'Innereien',
          category: const Value('fleisch'),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["high_purine"]')),

      // Fisch
      IngredientsCompanion.insert(
          name: 'Lachs',
          category: const Value('fisch'),
          unitDefault: const Value('g')),
      IngredientsCompanion.insert(
          name: 'Kabeljau',
          category: const Value('fisch'),
          unitDefault: const Value('g')),
      IngredientsCompanion.insert(
          name: 'Sardine',
          category: const Value('fisch'),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["high_purine","high_histamine"]')),
      IngredientsCompanion.insert(
          name: 'Hering',
          category: const Value('fisch'),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["high_purine","high_histamine"]')),
      IngredientsCompanion.insert(
          name: 'Thunfisch',
          category: const Value('fisch'),
          unitDefault: const Value('g')),

      // Milchprodukte
      IngredientsCompanion.insert(
          name: 'Milch',
          category: const Value('milchprodukt'),
          unitDefault: const Value('ml'),
          riskTagsJson: const Value('["contains_lactose"]')),
      IngredientsCompanion.insert(
          name: 'Sahne',
          category: const Value('milchprodukt'),
          unitDefault: const Value('ml'),
          riskTagsJson: const Value('["contains_lactose"]')),
      IngredientsCompanion.insert(
          name: 'Quark',
          category: const Value('milchprodukt'),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["contains_lactose"]')),
      IngredientsCompanion.insert(
          name: 'Joghurt',
          category: const Value('milchprodukt'),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["contains_lactose"]')),
      IngredientsCompanion.insert(
          name: 'Hartkäse',
          category: const Value('milchprodukt'),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["low_lactose","high_histamine","high_tyramine","high_sodium"]')),
      IngredientsCompanion.insert(
          name: 'Butter',
          category: const Value('milchprodukt'),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["contains_lactose"]')),
      IngredientsCompanion.insert(
          name: 'Eier',
          category: const Value('milchprodukt'),
          unitDefault: const Value('stück'),
          riskTagsJson: const Value('["high_phenylalanine","high_cholesterol"]')),
      IngredientsCompanion.insert(
          name: 'Hühnerei',
          category: const Value('milchprodukt'),
          unitDefault: const Value('stück'),
          riskTagsJson: const Value('["high_phenylalanine","high_cholesterol"]')),

      // Getreide
      IngredientsCompanion.insert(
          name: 'Weizen',
          category: const Value('getreide'),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["contains_gluten"]')),
      IngredientsCompanion.insert(
          name: 'Weißmehl',
          category: const Value('getreide'),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["contains_gluten","high_simple_carbs"]')),
      IngredientsCompanion.insert(
          name: 'Reis weiß',
          category: const Value('getreide'),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["high_simple_carbs"]')),
      IngredientsCompanion.insert(
          name: 'Reis braun',
          category: const Value('getreide'),
          unitDefault: const Value('g')),
      IngredientsCompanion.insert(
          name: 'Nudeln',
          category: const Value('getreide'),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["contains_gluten"]')),
      IngredientsCompanion.insert(
          name: 'Hafer',
          category: const Value('getreide'),
          unitDefault: const Value('g')),
      IngredientsCompanion.insert(
          name: 'Roggen',
          category: const Value('getreide'),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["contains_gluten"]')),
      IngredientsCompanion.insert(
          name: 'Dinkel',
          category: const Value('getreide'),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["contains_gluten"]')),

      // Hülsenfrüchte
      IngredientsCompanion.insert(
          name: 'Linsen',
          category: const Value('huelsenfruechte'),
          unitDefault: const Value('g')),
      IngredientsCompanion.insert(
          name: 'Kichererbsen',
          category: const Value('huelsenfruechte'),
          unitDefault: const Value('g')),
      IngredientsCompanion.insert(
          name: 'Bohnen',
          category: const Value('huelsenfruechte'),
          unitDefault: const Value('g')),

      // Sonstiges
      IngredientsCompanion.insert(
          name: 'Olivenöl',
          category: const Value('oel'),
          unitDefault: const Value('ml')),
      IngredientsCompanion.insert(
          name: 'Sonnenblumenöl',
          category: const Value('oel'),
          unitDefault: const Value('ml')),
      IngredientsCompanion.insert(
          name: 'Salz',
          category: const Value('ge_wuerz'),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["high_sodium"]')),
      IngredientsCompanion.insert(
          name: 'Pfeffer',
          category: const Value('ge_wuerz'),
          unitDefault: const Value('g')),
      IngredientsCompanion.insert(
          name: 'Zucker',
          category: const Value('suess'),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["high_simple_carbs"]')),
      IngredientsCompanion.insert(
          name: 'Honig',
          category: const Value('suess'),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["high_fructose"]')),
      IngredientsCompanion.insert(
          name: 'Grapefruit',
          category: const Value('obst'),
          seasonStart: const Value(11),
          seasonEnd: const Value(3),
          unitDefault: const Value('stück'),
          riskTagsJson: const Value('["high_grapefruit"]')),
      IngredientsCompanion.insert(
          name: 'Spargel',
          category: const Value('gemüse'),
          seasonStart: const Value(4),
          seasonEnd: const Value(6),
          unitDefault: const Value('g'),
          riskTagsJson: const Value('["high_purine"]')),
    ];

    await db.batch((b) {
      for (final i in list) {
        b.insert(db.ingredients, i);
      }
    });
  }
}