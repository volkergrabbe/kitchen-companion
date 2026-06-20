// lib/data/database/database.dart
//
// Kitchen Companion v2.0 — Drift Database
// Schichten-Architektur: UI → Domain → Data → Drift
// Schema-Doc: docs/ARCHITECTURE_V2.md

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

// ─────────────────────────────────────────────
// Tabellen-Definitionen
// ─────────────────────────────────────────────

// === Bestand (aus v1) ===

class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  IntColumn get prepTime => integer().nullable()();
  IntColumn get calories => integer().nullable()();
  RealColumn get protein => real().nullable()();
  RealColumn get carbs => real().nullable()();
  RealColumn get fat => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

class ShoppingItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get item => text().withLength(min: 1, max: 200)();
  RealColumn get quantity => real().nullable()();
  TextColumn get unit => text().nullable()();
  BoolColumn get checked => boolean().withDefault(const Constant(false))();
}

class FoodLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()(); // YYYY-MM-DD
  TextColumn get mealType => text()();
  IntColumn get calories => integer().nullable()();
  RealColumn get protein => real().nullable()();
  RealColumn get carbs => real().nullable()();
  RealColumn get fat => real().nullable()();
  TextColumn get customName => text().nullable()();
}

class Settings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get locale => text().withDefault(const Constant('de'))();
  TextColumn get units => text().withDefault(const Constant('metric'))();
  TextColumn get theme => text().withDefault(const Constant('system'))();
  IntColumn get calorieGoal => integer().nullable()();
  RealColumn get proteinGoal => real().nullable()();
  RealColumn get carbsGoal => real().nullable()();
  RealColumn get fatGoal => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// === NEU in v2.0 ===

/// Master-Tabelle aller bekannten Lebensmittel.
class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100).unique()();
  TextColumn get category => text().nullable()();
  // saisonale Verfügbarkeit (Monat 1-12, 0 = ganzjährig)
  IntColumn get seasonStart => integer().withDefault(const Constant(0))();
  IntColumn get seasonEnd => integer().withDefault(const Constant(0))();
  // Allergene als JSON-Array: '["gluten","lactose"]'
  TextColumn get allergensJson => text().withDefault(const Constant('[]'))();
  // Tags für Kontraindikationen: '["high_potassium","high_vitamin_k","warfarin_risk"]'
  TextColumn get riskTagsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get unitDefault => text().nullable()();
}

// P0-5 (Architecture Review): Hot-Path-Indizes werden per Migration
// v2→v3 via CREATE INDEX IF NOT EXISTS angelegt — Drift 2.23 hat keine
// @Index-Annotation.
class RecipeIngredients extends Table {
  IntColumn get recipeId =>
      integer().references(Recipes, #id, onDelete: KeyAction.cascade)();
  IntColumn get ingredientId =>
      integer().references(Ingredients, #id, onDelete: KeyAction.restrict)();
  RealColumn get quantityPerPerson => real()();
  TextColumn get unit => text().nullable()();

  @override
  Set<Column> get primaryKey => {recipeId, ingredientId};
}

/// Vordefinierte Kontraindikationen (Krankheiten + Medikamente).
/// Code ist stabil für i18n.
class Contraindications extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // 'disease' | 'medication'
  TextColumn get code => text().unique()();
  TextColumn get displayNameDe => text()();
  TextColumn get displayNameEn => text()();
  // JSON: ["sugar","wheat_flour"] – exakte ingredient.name-Treffer
  TextColumn get excludedIngredientsJson =>
      text().withDefault(const Constant('[]'))();
  // JSON: ["high_vitamin_k","warfarin_risk"] – ingredient.risk_tags-Treffer
  TextColumn get excludedRiskTagsJson =>
      text().withDefault(const Constant('[]'))();
  // 'avoid' | 'limit' | 'caution'
  TextColumn get severity => text().withDefault(const Constant('avoid'))();
  TextColumn get warningTextDe => text().nullable()();
  TextColumn get warningTextEn => text().nullable()();
}

/// Aktive Verknüpfung User ↔ Kontraindikation.
class UserContraindications extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get contraindicationId =>
      integer().references(Contraindications, #id, onDelete: KeyAction.cascade)();
  // Optionaler Override: 'avoid' | 'limit' | 'caution'
  TextColumn get severityOverride => text().nullable()();
  DateTimeColumn get addedAt => dateTime()();
}

/// Discounter-Quelle.
class Discounters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get scraperClass => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  TextColumn get logoPath => text().nullable()();
  // für v1.1
  TextColumn get apiType => text().nullable()();
  TextColumn get apiBaseUrl => text().nullable()();
  TextColumn get apiKeyEnv => text().nullable()();
}

/// Gescrapte/gefetchte Angebote.
// P0-5 (Architecture Review): Indizes auf FK-Spalten und validTo werden
// per Migration v2→v3 via CREATE INDEX IF NOT EXISTS angelegt.
class Offers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get discounterId =>
      integer().references(Discounters, #id, onDelete: KeyAction.cascade)();
  // Match auf ingredient, falls erkannt. Nullable: nicht jedes Angebot
  // lässt sich zuordnen (z.B. „McEnnedy Thai Curry").
  IntColumn get ingredientId =>
      integer().nullable().references(Ingredients, #id, onDelete: KeyAction.setNull)();
  TextColumn get rawName => text()();
  RealColumn get price => real()();
  TextColumn get unitText => text().nullable()();
  DateTimeColumn get validFrom => dateTime()();
  DateTimeColumn get validTo => dateTime()();
  DateTimeColumn get fetchedAt => dateTime()();
  TextColumn get sourceUrl => text().nullable()();
}

/// Wochenplan.
class WeeklyPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get weekStart => dateTime()(); // Montag 00:00
  IntColumn get persons => integer().withDefault(const Constant(2))();
  // 'draft' | 'active' | 'completed'
  TextColumn get status => text().withDefault(const Constant('draft'))();
  DateTimeColumn get createdAt => dateTime()();
}

// P0-5 (Architecture Review): Index auf planId wird per Migration v2→v3
// via CREATE INDEX IF NOT EXISTS angelegt.
class PlanMeals extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planId =>
      integer().references(WeeklyPlans, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()();
  TextColumn get mealType => text()(); // breakfast/lunch/dinner/snack
  IntColumn get recipeId =>
      integer().nullable().references(Recipes, #id, onDelete: KeyAction.setNull)();
  TextColumn get customName => text().nullable()();
  IntColumn get serves => integer().withDefault(const Constant(1))();
}

// P0-5 (Architecture Review): Index auf planId wird per Migration v2→v3
// via CREATE INDEX IF NOT EXISTS angelegt.
class PlanIngredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planId =>
      integer().references(WeeklyPlans, #id, onDelete: KeyAction.cascade)();
  IntColumn get ingredientId =>
      integer().references(Ingredients, #id, onDelete: KeyAction.restrict)();
  RealColumn get totalQuantity => real()();
  TextColumn get unit => text().nullable()();
  IntColumn get offerId =>
      integer().nullable().references(Offers, #id, onDelete: KeyAction.setNull)();
}

/// Erweitertes User-Profil (zip, Personen, Discounter-Auswahl).
/// id immer 1 (Single-User-App).
class UserProfile extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get persons => integer().withDefault(const Constant(2))();
  TextColumn get zipCode => text().nullable()();
  TextColumn get selectedDiscountersJson =>
      text().withDefault(const Constant('[]'))();
  BoolColumn get weeklyPlanAuto =>
      boolean().withDefault(const Constant(false))();
  IntColumn get planDow => integer().withDefault(const Constant(1))(); // 1=Mo
  BoolColumn get marktguruEnabled =>
      boolean().withDefault(const Constant(false))();
  // P0-1 (Privacy Review): marktguruApiKey wurde aus der DB entfernt.
  // Wird jetzt in flutter_secure_storage (Android Keystore) gespeichert
  // — siehe lib/data/secure_storage_service.dart.

  @override
  Set<Column> get primaryKey => {id};
}

// ─────────────────────────────────────────────
// DAO-Streams (für reaktive UI)
// ─────────────────────────────────────────────

@DriftDatabase(tables: [
  Recipes,
  ShoppingItems,
  FoodLog,
  Settings,
  Ingredients,
  RecipeIngredients,
  Contraindications,
  UserContraindications,
  Discounters,
  Offers,
  WeeklyPlans,
  PlanMeals,
  PlanIngredients,
  UserProfile,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // P0-5 (Architecture Review): Hot-Path-Indizes direkt mit
          // anlegen — Drift 2.23 unterstützt keine @Index-Annotation.
          await _createHotPathIndexes();
        },
        onUpgrade: (m, from, to) async {
          // v1 → v2: neue Tabellen erstellen
          if (from < 2) {
            await m.createTable(ingredients);
            await m.createTable(recipeIngredients);
            await m.createTable(contraindications);
            await m.createTable(userContraindications);
            await m.createTable(discounters);
            await m.createTable(offers);
            await m.createTable(weeklyPlans);
            await m.createTable(planMeals);
            await m.createTable(planIngredients);
            await m.createTable(userProfile);
            // User-Profile initialisieren
            await into(userProfile).insert(UserProfileCompanion.insert());
          }
          // v2 → v3: Hot-Path-Indizes anlegen
          if (from < 3) {
            await _createHotPathIndexes();
          }
        },
      );

  /// P0-5 (Architecture Review): Hot-Path-Indizes für die Joins und
  /// Watch-Queries, die in [WeeklyPlanEngine] und der Plan-UI verwendet
  /// werden. QW2 (GLM-5.2 Runde 2) erweitert dies um FK-Indizes auf
  /// `plan_meals.recipe_id`, `plan_ingredients.ingredient_id` und
  /// `plan_ingredients.offer_id`, die Drift nicht implizit anlegt.
  /// Drift 2.23 hat keine Table-Index-Annotation, deshalb hier als SQL —
  /// IF NOT EXISTS macht es idempotent.
  Future<void> _createHotPathIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_recipe_ingredients_recipe '
      'ON recipe_ingredients (recipe_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_recipe_ingredients_ingredient '
      'ON recipe_ingredients (ingredient_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_user_contraindications_contra '
      'ON user_contraindications (contraindication_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_offers_discounter '
      'ON offers (discounter_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_offers_ingredient '
      'ON offers (ingredient_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_offers_valid_to '
      'ON offers (valid_to)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_plan_meals_plan '
      'ON plan_meals (plan_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_plan_meals_recipe '
      'ON plan_meals (recipe_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_plan_ingredients_plan '
      'ON plan_ingredients (plan_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_plan_ingredients_ingredient '
      'ON plan_ingredients (ingredient_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_plan_ingredients_offer '
      'ON plan_ingredients (offer_id)',
    );
  }

  // ─── Recipes ───
  Stream<List<Recipe>> watchAllRecipes() =>
      (select(recipes)..orderBy([(r) => OrderingTerm.asc(r.name)])).watch();
  Future<int> addRecipe(RecipesCompanion r) => into(recipes).insert(r);
  Future<bool> updateRecipe(Recipe r) => update(recipes).replace(r);
  Future<int> deleteRecipe(int id) =>
      (delete(recipes)..where((r) => r.id.equals(id))).go();

  // ─── Shopping ───
  Stream<List<ShoppingItem>> watchAllShoppingItems() =>
      (select(shoppingItems)..orderBy([(s) => OrderingTerm.asc(s.checked)]))
          .watch();
  Future<int> toggleShoppingItem(int id, bool checked) =>
      (update(shoppingItems)..where((s) => s.id.equals(id))).write(
        ShoppingItemsCompanion(checked: Value(checked)),
      );
  Future<int> clearCheckedItems() =>
      (delete(shoppingItems)..where((s) => s.checked.equals(true))).go();

  // ─── FoodLog ───
  Stream<List<FoodLogData>> watchFoodLogForDate(String date) =>
      (select(foodLog)..where((f) => f.date.equals(date))).watch();
  Future<int> addFoodLog(FoodLogCompanion f) => into(foodLog).insert(f);

  // ─── Settings ───
  Stream<Setting?> watchSettings() =>
      (select(settings)..where((s) => s.id.equals(1))).watchSingleOrNull();
  Future<Setting?> getSettings() async =>
      (select(settings)..where((s) => s.id.equals(1))).getSingleOrNull();

  Future<void> ensureSettingsExist() async {
    final existing = await getSettings();
    if (existing == null) {
      await into(settings).insert(const SettingsCompanion(id: Value(1)));
    }
  }

  Future<void> updateSettings({
    String? locale,
    String? units,
    String? theme,
    int? calorieGoal,
    double? proteinGoal,
    double? carbsGoal,
    double? fatGoal,
  }) async {
    await ensureSettingsExist();
    await (update(settings)..where((s) => s.id.equals(1))).write(
      SettingsCompanion(
        locale: locale == null ? const Value.absent() : Value(locale),
        units: units == null ? const Value.absent() : Value(units),
        theme: theme == null ? const Value.absent() : Value(theme),
        calorieGoal:
            calorieGoal == null ? const Value.absent() : Value(calorieGoal),
        proteinGoal:
            proteinGoal == null ? const Value.absent() : Value(proteinGoal),
        carbsGoal:
            carbsGoal == null ? const Value.absent() : Value(carbsGoal),
        fatGoal: fatGoal == null ? const Value.absent() : Value(fatGoal),
      ),
    );
  }

  // ─── Ingredients ───
  Stream<List<Ingredient>> watchAllIngredients() =>
      (select(ingredients)..orderBy([(i) => OrderingTerm.asc(i.name)])).watch();
  Future<Ingredient?> ingredientByName(String name) =>
      (select(ingredients)..where((i) => i.name.equals(name)))
          .getSingleOrNull();
  Future<int> addIngredient(IngredientsCompanion i) =>
      into(ingredients).insert(i);

  // ─── Contraindications ───
  Stream<List<Contraindication>> watchAllContraindications() =>
      (select(contraindications)).watch();
  /// Vom User aktivierte Kontraindikationen.
  /// P0-1 (Architecture Review): Wir geben die UserContraindications.id
  /// (Join-Tabellen-ID) zusätzlich zurück, damit der UI-Layer eine
  /// aktivierte Kontraindikation korrekt deaktivieren kann.
  /// Der bisherige Stream hat nur Contraindications-Felder geliefert,
  /// wodurch der Minus-Button auf einen No-Op-Delete lief.
  Stream<List<ActiveUserContraindication>> watchActiveUserContraindications() {
    final query = select(userContraindications).join([
      innerJoin(
        contraindications,
        contraindications.id.equalsExp(userContraindications.contraindicationId),
      ),
    ]);
    return query.watch().map((rows) => rows
        .map((r) => ActiveUserContraindication(
              userContraindicationId:
                  r.readTable(userContraindications).id,
              contraindication: r.readTable(contraindications),
              severityOverride:
                  r.readTable(userContraindications).severityOverride,
              addedAt: r.readTable(userContraindications).addedAt,
            ))
        .toList());
  }

  Future<int> addUserContraindication(int contraindicationId) =>
      into(userContraindications).insert(
        UserContraindicationsCompanion.insert(
          contraindicationId: contraindicationId,
          addedAt: DateTime.now(),
        ),
      );
  Future<int> removeUserContraindication(int id) =>
      (delete(userContraindications)..where((u) => u.id.equals(id))).go();

  // ─── Discounters ───
  Stream<List<Discounter>> watchAllDiscounters() =>
      (select(discounters)..orderBy([(d) => OrderingTerm.asc(d.name)])).watch();
  Future<int> addDiscounter(DiscountersCompanion d) =>
      into(discounters).insert(d);

  // ─── Offers ───
  Stream<List<Offer>> watchValidOffers(DateTime now) =>
      (select(offers)
            ..where((o) => o.validTo.isBiggerThanValue(now)))
          .watch();
  Future<int> addOffer(OffersCompanion o) => into(offers).insert(o);
  Future<int> clearOldOffers(DateTime now) =>
      (delete(offers)..where((o) => o.validTo.isSmallerThanValue(now))).go();

  // ─── WeeklyPlans ───
  Stream<List<WeeklyPlan>> watchAllPlans() =>
      (select(weeklyPlans)..orderBy([(p) => OrderingTerm.desc(p.weekStart)]))
          .watch();
  Future<int> addPlan(WeeklyPlansCompanion p) => into(weeklyPlans).insert(p);
  Stream<List<PlanMeal>> watchPlanMeals(int planId) =>
      (select(planMeals)..where((m) => m.planId.equals(planId))).watch();
  Stream<List<PlanIngredient>> watchPlanIngredients(int planId) =>
      (select(planIngredients)..where((p) => p.planId.equals(planId))).watch();

  // ─── UserProfile ───
  Future<UserProfileData> getUserProfile() async {
    final existing =
        await (select(userProfile)..where((u) => u.id.equals(1))).getSingleOrNull();
    if (existing != null) return existing;
    await into(userProfile).insert(UserProfileCompanion.insert());
    return (select(userProfile)..where((u) => u.id.equals(1))).getSingle();
  }

  Future<void> updateUserProfile({
    int? persons,
    String? zipCode,
    bool? weeklyPlanAuto,
    int? planDow,
    bool? marktguruEnabled,
    String? selectedDiscountersJson,
  }) async {
    final existing = await getUserProfile();
    await (update(userProfile)..where((u) => u.id.equals(existing.id))).write(
      UserProfileCompanion(
        persons: persons == null ? const Value.absent() : Value(persons),
        zipCode: zipCode == null ? const Value.absent() : Value(zipCode),
        weeklyPlanAuto: weeklyPlanAuto == null
            ? const Value.absent()
            : Value(weeklyPlanAuto),
        planDow: planDow == null ? const Value.absent() : Value(planDow),
        marktguruEnabled: marktguruEnabled == null
            ? const Value.absent()
            : Value(marktguruEnabled),
        selectedDiscountersJson: selectedDiscountersJson == null
            ? const Value.absent()
            : Value(selectedDiscountersJson),
      ),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'kitchen_companion_v2.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}

// ─────────────────────────────────────────────
// Helper-Klassen für Join-Ergebnisse
// ─────────────────────────────────────────────

/// Kombiniert eine [Contraindication] (Master) mit dem Join-Record
/// aus [UserContraindications] (pro User aktiviert).
///
/// P0-1 (Architecture Review): Die alte Variante hat nur die
/// Contraindications-Spalten zurückgegeben. Der UI-Code brauchte
/// aber die UserContraindications.id, um den Minus-Button korrekt
/// zu verdrahten — stattdessen wurde die Contraindications.id
/// genutzt, was immer einen No-Op-Delete ergab.
class ActiveUserContraindication {
  final int userContraindicationId;
  final Contraindication contraindication;
  final String? severityOverride;
  final DateTime addedAt;

  const ActiveUserContraindication({
    required this.userContraindicationId,
    required this.contraindication,
    required this.severityOverride,
    required this.addedAt,
  });
}
