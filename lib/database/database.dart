import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// ─────────────────────────────────────────────
// Zutaten (normalisierte Tabelle)
// ─────────────────────────────────────────────
@TableIndex(name: 'idx_ingredients_name', columns: {#name})
class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()(); // Sprachunabhängig (interner Key)
  TextColumn get category => text().nullable()(); // vegetable, meat, dairy, spice...
  RealColumn get caloriesPer100g => real().nullable()();
  RealColumn get proteinPer100g => real().nullable()();
  RealColumn get carbsPer100g => real().nullable()();
  RealColumn get fatPer100g => real().nullable()();
}

// ─────────────────────────────────────────────
// Ingredient-Übersetzungen (i18n)
// ─────────────────────────────────────────────
@TableIndex(name: 'idx_translations_ingredient', columns: {#ingredientId})
class IngredientTranslations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ingredientId => integer().references(Ingredients, #id)();
  TextColumn get locale => text()(); // 'de', 'en', 'fr'...
  TextColumn get name => text()(); // Lokalisierter Name

  @override
  List<Set<Column>>? get uniqueKeys => [
        {ingredientId, locale}
      ];
}

// ─────────────────────────────────────────────
// Rezept-Zutaten-Verknüpfung (Portionen-Skalierung)
// ─────────────────────────────────────────────
@TableIndex(name: 'idx_recipe_ingredients_recipe', columns: {#recipeId})
@TableIndex(name: 'idx_recipe_ingredients_ingredient', columns: {#ingredientId})
class RecipeIngredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId =>
      integer().references(Recipes, #id, onDelete: KeyAction.cascade)();
  IntColumn get ingredientId =>
      integer().references(Ingredients, #id, onDelete: KeyAction.cascade)();
  RealColumn get quantity => real()(); // Mengenwert (skalierbar)
  TextColumn get unit => text()(); // g, ml, Stück
  IntColumn get position => integer().withDefault(const Constant(0))();
}

// ─────────────────────────────────────────────
// Rezepte
// ─────────────────────────────────────────────
class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get locale => text().withDefault(const Constant('de'))();
  TextColumn get country => text().withDefault(const Constant('DE'))();
  TextColumn get name => text()();
  TextColumn get instructions => text().nullable()();
  IntColumn get prepTime => integer().nullable()(); // Minuten
  IntColumn get cookTime => integer().nullable()();
  IntColumn get servings => integer().withDefault(const Constant(4))();
  IntColumn get calories => integer().nullable()();
  RealColumn get protein => real().nullable()();
  RealColumn get carbs => real().nullable()();
  RealColumn get fat => real().nullable()();
  TextColumn get source =>
      text().withDefault(const Constant('manual'))(); // manual, openrecipe, usda
  TextColumn get mcRecipeId => text().nullable()(); // Monsieur Cuisine ID
  IntColumn get createdAt => integer().nullable()();
  IntColumn get updatedAt => integer().nullable()();
}

// ─────────────────────────────────────────────
// Einkaufsliste
// ─────────────────────────────────────────────
@TableIndex(name: 'idx_shopping_checked', columns: {#checked})
class ShoppingListItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get locale => text().withDefault(const Constant('de'))();
  TextColumn get item => text()();
  TextColumn get quantity => text().nullable()();
  TextColumn get unit => text().nullable()();
  BoolColumn get checked => boolean().withDefault(const Constant(false))();
  IntColumn get recipeId =>
      integer().nullable().references(Recipes, #id, onDelete: KeyAction.setNull)();
  IntColumn get createdAt => integer().nullable()();
}

// ─────────────────────────────────────────────
// Ernährungstagebuch
// ─────────────────────────────────────────────
@TableIndex(name: 'idx_foodlog_date', columns: {#date})
class FoodLogEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()(); // Nur Datum (YYYY-MM-DD)
  IntColumn get timestamp => integer().nullable()(); // Full timestamp
  TextColumn get locale => text().withDefault(const Constant('de'))();
  TextColumn get mealType => text()(); // breakfast, lunch, dinner, snack
  IntColumn get recipeId =>
      integer().nullable().references(Recipes, #id, onDelete: KeyAction.setNull)();
  TextColumn get customName => text().nullable()();
  IntColumn get calories => integer().nullable()();
  RealColumn get protein => real().nullable()();
  RealColumn get carbs => real().nullable()();
  RealColumn get fat => real().nullable()();
  IntColumn get createdAt => integer().nullable()();
}

// ─────────────────────────────────────────────
// App-Einstellungen
// ─────────────────────────────────────────────
class AppSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get locale => text().withDefault(const Constant('de'))();
  TextColumn get country => text().withDefault(const Constant('DE'))();
  TextColumn get units =>
      text().withDefault(const Constant('metric'))(); // metric, imperial
  TextColumn get theme =>
      text().withDefault(const Constant('system'))(); // light, dark, system
  IntColumn get calorieGoal => integer().nullable()();
  RealColumn get proteinGoal => real().nullable()();
  RealColumn get carbsGoal => real().nullable()();
  RealColumn get fatGoal => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Ingredients,
  IngredientTranslations,
  RecipeIngredients,
  Recipes,
  ShoppingListItems,
  FoodLogEntries,
  AppSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For testing: In-memory database
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Future migrations here — use stepByStep when schemaVersion > 1
    },
    beforeOpen: (OpeningDetails details) async {
      // P0-FIX: Foreign Keys aktivieren — ohne dieses PRAGMA ignoriert SQLite
      // alle REFERENCES/ON DELETE CASCADE/SET NULL Deklarationen.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'kitchen_companion.db');
  }

  // ─────────────────────────────────────────────
  // Validierte Enum-Werte
  // ─────────────────────────────────────────────
  static const validMealTypes = {'breakfast', 'lunch', 'dinner', 'snack'};
  static const validSources = {'manual', 'openrecipe', 'usda', 'monsieur_cuisine'};
  static final _dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  // ─────────────────────────────────────────────
  // Hilfsfunktionen
  // ─────────────────────────────────────────────
  static int _now() => DateTime.now().millisecondsSinceEpoch;

  // ─────────────────────────────────────────────
  // Rezepte
  // ─────────────────────────────────────────────
  Future<List<Recipe>> getAllRecipes() => select(recipes).get();

  Stream<List<Recipe>> watchAllRecipes() => select(recipes).watch();

  Future<Recipe?> getRecipeById(int id) =>
      (select(recipes)..where((r) => r.id.equals(id))).getSingleOrNull();

  Future<int> insertRecipe(RecipesCompanion recipe) {
    // Validierung: source muss gültig sein (nur wenn source explizit angegeben)
    if (recipe.source.present && !validSources.contains(recipe.source.value)) {
      throw ArgumentError('Invalid source: ${recipe.source.value}');
    }
    final now = _now();
    return into(recipes).insert(recipe.copyWith(
      createdAt: Value(now),
      updatedAt: Value(now),
    ));
  }

  Future<int> updateRecipe(int id, RecipesCompanion recipe) {
    // P1-FIX: source-Validierung auch bei Update (wie bei insertRecipe)
    if (recipe.source.present && !validSources.contains(recipe.source.value)) {
      throw ArgumentError('Invalid source: ${recipe.source.value}');
    }
    return (update(recipes)..where((r) => r.id.equals(id)))
        .write(recipe.copyWith(updatedAt: Value(_now())));
  }

  Future<int> deleteRecipe(int id) {
    return transaction(() async {
      // FKs sind jetzt aktiv (PRAGMA foreign_keys = ON), aber wir behalten
      // die manuelle Cascade als Defense-in-Depth für SQLite-Edge-Cases.
      await (delete(recipeIngredients)..where((ri) => ri.recipeId.equals(id))).go();
      await (update(shoppingListItems)..where((s) => s.recipeId.equals(id)))
          .write(const ShoppingListItemsCompanion(recipeId: Value(null)));
      await (update(foodLogEntries)..where((f) => f.recipeId.equals(id)))
          .write(const FoodLogEntriesCompanion(recipeId: Value(null)));
      return (delete(recipes)..where((r) => r.id.equals(id))).go();
    });
  }

  // ─────────────────────────────────────────────
  // Zutaten
  // ─────────────────────────────────────────────
  Future<List<Ingredient>> getAllIngredients() =>
      select(ingredients).get();

  Future<Ingredient?> getIngredientById(int id) =>
      (select(ingredients)..where((i) => i.id.equals(id))).getSingleOrNull();

  Future<int> insertIngredient(IngredientsCompanion ingredient) =>
      into(ingredients).insert(ingredient);

  // ─────────────────────────────────────────────
  // Zutaten-Übersetzungen
  // ─────────────────────────────────────────────
  Future<List<IngredientTranslation>> getTranslationsForIngredient(
          int ingredientId) =>
      (select(ingredientTranslations)
            ..where((t) => t.ingredientId.equals(ingredientId)))
          .get();

  Future<int> insertTranslation(IngredientTranslationsCompanion translation) =>
      into(ingredientTranslations).insert(translation);

  Future<int> deleteTranslation(int id) =>
      (delete(ingredientTranslations)..where((t) => t.id.equals(id))).go();

  // ─────────────────────────────────────────────
  // Rezept-Zutaten
  // ─────────────────────────────────────────────
  Future<List<RecipeIngredient>> getIngredientsForRecipe(int recipeId) =>
      (select(recipeIngredients)..where((ri) => ri.recipeId.equals(recipeId)))
          .get();

  Future<int> insertRecipeIngredient(RecipeIngredientsCompanion ri) =>
      into(recipeIngredients).insert(ri);

  Future<int> deleteRecipeIngredients(int recipeId) =>
      (delete(recipeIngredients)..where((ri) => ri.recipeId.equals(recipeId)))
          .go();

  // ─────────────────────────────────────────────
  // Einkaufsliste
  // ─────────────────────────────────────────────
  Future<List<ShoppingListItem>> getAllShoppingItems() =>
      select(shoppingListItems).get();

  Stream<List<ShoppingListItem>> watchAllShoppingItems() =>
      select(shoppingListItems).watch();

  Future<int> insertShoppingItem(ShoppingListItemsCompanion item) =>
      into(shoppingListItems).insert(item.copyWith(
        createdAt: Value(_now()),
      ));

  Future<int> deleteShoppingItem(int id) =>
      (delete(shoppingListItems)..where((s) => s.id.equals(id))).go();

  Future<int> toggleShoppingItem(int id, bool checked) =>
      (update(shoppingListItems)..where((s) => s.id.equals(id)))
          .write(ShoppingListItemsCompanion(checked: Value(checked)));

  Future<int> clearCheckedItems() =>
      (delete(shoppingListItems)..where((s) => s.checked.equals(true))).go();

  // ─────────────────────────────────────────────
  // Ernährungstagebuch
  // ─────────────────────────────────────────────
  Future<List<FoodLogEntry>> getFoodLogForDate(String date) =>
      (select(foodLogEntries)..where((f) => f.date.equals(date))).get();

  Stream<List<FoodLogEntry>> watchFoodLogForDate(String date) =>
      (select(foodLogEntries)..where((f) => f.date.equals(date))).watch();

  Future<int> insertFoodLogEntry(FoodLogEntriesCompanion entry) {
    // Validierung: mealType muss gültig sein
    if (!validMealTypes.contains(entry.mealType.value)) {
      throw ArgumentError('Invalid mealType: ${entry.mealType.value}');
    }
    // P2-FIX: date-Format validieren (YYYY-MM-DD)
    if (!_dateRegex.hasMatch(entry.date.value)) {
      throw ArgumentError(
          'Invalid date format (YYYY-MM-DD expected): ${entry.date.value}');
    }
    final now = _now();
    return into(foodLogEntries).insert(entry.copyWith(
      timestamp: Value(now),
      createdAt: Value(now),
    ));
  }

  Future<int> updateFoodLogEntry(int id, FoodLogEntriesCompanion entry) {
    if (entry.mealType.present && !validMealTypes.contains(entry.mealType.value)) {
      throw ArgumentError('Invalid mealType: ${entry.mealType.value}');
    }
    // P2-FIX: date-Format auch bei Update validieren
    if (entry.date.present && !_dateRegex.hasMatch(entry.date.value)) {
      throw ArgumentError(
          'Invalid date format (YYYY-MM-DD expected): ${entry.date.value}');
    }
    return (update(foodLogEntries)..where((f) => f.id.equals(id)))
        .write(entry);
  }

  Future<int> deleteFoodLogEntry(int id) =>
      (delete(foodLogEntries)..where((f) => f.id.equals(id))).go();

  // ─────────────────────────────────────────────
  // Einstellungen (Singleton)
  // ─────────────────────────────────────────────
  Future<AppSetting?> getSettings() =>
      (select(appSettings)..where((s) => s.id.equals(1))).getSingleOrNull();

  Stream<AppSetting?> watchSettings() =>
      (select(appSettings)..where((s) => s.id.equals(1))).watchSingleOrNull();

  // P0-FIX: insertOnConflictUpdate statt Read-then-Write — atomar, keine Race Condition
  Future<int> upsertSettings(AppSettingsCompanion settings) {
    return into(appSettings).insertOnConflictUpdate(
      settings.copyWith(id: const Value(1)),
    );
  }

  /// Settings initialisieren falls nicht vorhanden
  Future<void> ensureSettingsExist() async {
    final existing = await getSettings();
    if (existing == null) {
      await upsertSettings(const AppSettingsCompanion());
    }
  }
}
