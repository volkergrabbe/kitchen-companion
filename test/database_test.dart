import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitchen_companion/database/database.dart';

/// In-memory DB für Tests
AppDatabase _createTestDb() {
  return AppDatabase.forTesting(NativeDatabase.memory());
}

void main() {
  group('Recipes', () {
    late AppDatabase db;

    setUp(() async {
      db = _createTestDb();
    });

    tearDown(() async {
      await db.close();
    });

    test('insertRecipe validiert source korrekt', () async {
      await expectLater(
        () => db.insertRecipe(RecipesCompanion.insert(
          name: 'Test',
          source: const Value('invalid_source'),
        )),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('insertRecipe akzeptiert gültige sources', () async {
      for (final source in ['manual', 'openrecipe', 'usda', 'monsieur_cuisine']) {
        final id = await db.insertRecipe(RecipesCompanion.insert(
          name: 'Test $source',
          source: Value(source),
        ));
        expect(id, greaterThan(0));
      }
    });

    test('insertRecipe setzt createdAt und updatedAt', () async {
      final before = DateTime.now().millisecondsSinceEpoch;
      final id = await db.insertRecipe(RecipesCompanion.insert(
        name: 'Timestamp Test',
      ));
      final recipe = await db.getRecipeById(id);
      expect(recipe, isNotNull);
      expect(recipe!.createdAt, greaterThanOrEqualTo(before));
      expect(recipe.updatedAt, greaterThanOrEqualTo(before));
    });

    test('updateRecipe aktualisiert updatedAt', () async {
      final id = await db.insertRecipe(RecipesCompanion.insert(name: 'Vorher'));
      await Future.delayed(const Duration(milliseconds: 10));
      final before = DateTime.now().millisecondsSinceEpoch;
      await db.updateRecipe(id, RecipesCompanion(
        name: const Value('Nachher'),
      ));
      final recipe = await db.getRecipeById(id);
      expect(recipe!.updatedAt, greaterThanOrEqualTo(before));
    });

    test('deleteRecipe entfernt Rezept und RecipeIngredients', () async {
      final recipeId = await db.insertRecipe(RecipesCompanion.insert(
        name: 'Zu Löschendes',
      ));
      final ingredientId = await db.insertIngredient(
        IngredientsCompanion.insert(name: 'Zutat'),
      );
      await db.insertRecipeIngredient(RecipeIngredientsCompanion.insert(
        recipeId: recipeId,
        ingredientId: ingredientId,
        quantity: 100,
        unit: 'g',
      ));

      await db.deleteRecipe(recipeId);

      final recipe = await db.getRecipeById(recipeId);
      expect(recipe, isNull);
      final ingredients = await db.getIngredientsForRecipe(recipeId);
      expect(ingredients, isEmpty);
    });

    test('deleteRecipe setzt ShoppingListItems.recipeId auf NULL', () async {
      final recipeId = await db.insertRecipe(RecipesCompanion.insert(name: 'Rezept'));
      await db.insertShoppingItem(ShoppingListItemsCompanion.insert(
        item: 'Milch',
        recipeId: Value(recipeId),
      ));

      await db.deleteRecipe(recipeId);

      final items = await db.getAllShoppingItems();
      expect(items.first.recipeId, isNull);
    });

    test('deleteRecipe setzt FoodLogEntries.recipeId auf NULL', () async {
      final recipeId = await db.insertRecipe(RecipesCompanion.insert(name: 'Rezept'));
      await db.insertFoodLogEntry(FoodLogEntriesCompanion.insert(
        date: '2024-01-01',
        mealType: 'breakfast',
        recipeId: Value(recipeId),
      ));

      await db.deleteRecipe(recipeId);

      final entries = await db.getFoodLogForDate('2024-01-01');
      expect(entries.first.recipeId, isNull);
    });

    test('getAllRecipes gibt alle Rezepte zurück', () async {
      await db.insertRecipe(RecipesCompanion.insert(name: 'Rezept 1'));
      await db.insertRecipe(RecipesCompanion.insert(name: 'Rezept 2'));
      final recipes = await db.getAllRecipes();
      expect(recipes.length, 2);
    });

    test('watchAllRecipes ist ein Stream', () async {
      db.insertRecipe(RecipesCompanion.insert(name: 'Gestreamt'));
      await expectLater(
        db.watchAllRecipes().first,
        completion(anything),
      );
    });
  });

  group('Ingredients', () {
    late AppDatabase db;

    setUp(() async {
      db = _createTestDb();
    });

    tearDown(() async {
      await db.close();
    });

    test('insertIngredient fügt Zutat hinzu', () async {
      final id = await db.insertIngredient(IngredientsCompanion.insert(
        name: 'Mehl',
        category: const Value('dry'),
        caloriesPer100g: const Value(365),
      ));
      expect(id, greaterThan(0));
      final ingredient = await db.getIngredientById(id);
      expect(ingredient!.name, 'Mehl');
      expect(ingredient.caloriesPer100g, 365);
    });

    test('insertTranslation fügt Übersetzung hinzu', () async {
      final ingredientId = await db.insertIngredient(
        IngredientsCompanion.insert(name: 'egg_internal'),
      );
      await db.insertTranslation(IngredientTranslationsCompanion.insert(
        ingredientId: ingredientId,
        locale: 'de',
        name: 'Ei',
      ));
      await db.insertTranslation(IngredientTranslationsCompanion.insert(
        ingredientId: ingredientId,
        locale: 'en',
        name: 'Egg',
      ));

      final translations = await db.getTranslationsForIngredient(ingredientId);
      expect(translations.length, 2);
      expect(translations.map((t) => t.locale), containsAll(['de', 'en']));
    });

    test('deleteTranslation entfernt Übersetzung', () async {
      final ingredientId = await db.insertIngredient(
        IngredientsCompanion.insert(name: 'to_delete'),
      );
      final transId = await db.insertTranslation(
        IngredientTranslationsCompanion.insert(
          ingredientId: ingredientId,
          locale: 'de',
          name: 'ZuLöschen',
        ),
      );
      await db.deleteTranslation(transId);
      final translations = await db.getTranslationsForIngredient(ingredientId);
      expect(translations, isEmpty);
    });
  });

  group('ShoppingList', () {
    late AppDatabase db;

    setUp(() async {
      db = _createTestDb();
    });

    tearDown(() async {
      await db.close();
    });

    test('insertShoppingItem setzt createdAt', () async {
      final before = DateTime.now().millisecondsSinceEpoch;
      await db.insertShoppingItem(ShoppingListItemsCompanion.insert(item: 'Brot'));
      final items = await db.getAllShoppingItems();
      expect(items.first.createdAt, greaterThanOrEqualTo(before));
    });

    test('toggleShoppingItem wechselt checked-Status', () async {
      final id = await db.insertShoppingItem(
        ShoppingListItemsCompanion.insert(item: 'Milch'),
      );
      await db.toggleShoppingItem(id, true);
      var items = await db.getAllShoppingItems();
      expect(items.first.checked, isTrue);

      await db.toggleShoppingItem(id, false);
      items = await db.getAllShoppingItems();
      expect(items.first.checked, isFalse);
    });

    test('clearCheckedItems löscht nur abgehakte Items', () async {
      await db.insertShoppingItem(ShoppingListItemsCompanion.insert(
        item: 'Milch',
        checked: const Value(true),
      ));
      await db.insertShoppingItem(ShoppingListItemsCompanion.insert(
        item: 'Brot',
        checked: const Value(false),
      ));

      await db.clearCheckedItems();

      final items = await db.getAllShoppingItems();
      expect(items.length, 1);
      expect(items.first.item, 'Brot');
    });

    test('watchAllShoppingItems ist ein Stream', () async {
      db.insertShoppingItem(ShoppingListItemsCompanion.insert(item: 'Gestreamt'));
      await expectLater(
        db.watchAllShoppingItems().first,
        completion(anything),
      );
    });
  });

  group('FoodLogEntries', () {
    late AppDatabase db;

    setUp(() async {
      db = _createTestDb();
    });

    tearDown(() async {
      await db.close();
    });

    test('insertFoodLogEntry validiert mealType', () async {
      await expectLater(
        () => db.insertFoodLogEntry(FoodLogEntriesCompanion.insert(
          date: '2024-01-01',
          mealType: 'invalid',
        )),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('insertFoodLogEntry akzeptiert gültige mealTypes', () async {
      for (final mealType in ['breakfast', 'lunch', 'dinner', 'snack']) {
        await db.insertFoodLogEntry(FoodLogEntriesCompanion.insert(
          date: '2024-01-01',
          mealType: mealType,
        ));
      }
      final entries = await db.getFoodLogForDate('2024-01-01');
      expect(entries.length, 4);
    });

    test('insertFoodLogEntry setzt timestamp und createdAt', () async {
      final before = DateTime.now().millisecondsSinceEpoch;
      await db.insertFoodLogEntry(FoodLogEntriesCompanion.insert(
        date: '2024-01-01',
        mealType: 'breakfast',
      ));
      final entries = await db.getFoodLogForDate('2024-01-01');
      expect(entries.first.timestamp, greaterThanOrEqualTo(before));
      expect(entries.first.createdAt, greaterThanOrEqualTo(before));
    });

    test('updateFoodLogEntry aktualisiert mit Validierung', () async {
      final id = await db.insertFoodLogEntry(FoodLogEntriesCompanion.insert(
        date: '2024-01-01',
        mealType: 'breakfast',
      ));

      // Valid mealType sollte funktionieren
      await db.updateFoodLogEntry(id, FoodLogEntriesCompanion(
        mealType: const Value('lunch'),
      ));

      // Ungültiger mealType sollte werfen
      await expectLater(
        () => db.updateFoodLogEntry(id, FoodLogEntriesCompanion(
          mealType: const Value('invalid_meal'),
        )),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('watchFoodLogForDate ist ein Stream', () async {
      db.insertFoodLogEntry(FoodLogEntriesCompanion.insert(
        date: '2024-01-01',
        mealType: 'breakfast',
      ));
      await expectLater(
        db.watchFoodLogForDate('2024-01-01').first,
        completion(anything),
      );
    });

    test('deleteFoodLogEntry entfernt Eintrag', () async {
      final id = await db.insertFoodLogEntry(FoodLogEntriesCompanion.insert(
        date: '2024-01-01',
        mealType: 'breakfast',
      ));
      await db.deleteFoodLogEntry(id);
      final entries = await db.getFoodLogForDate('2024-01-01');
      expect(entries, isEmpty);
    });
  });

  group('AppSettings', () {
    late AppDatabase db;

    setUp(() async {
      db = _createTestDb();
    });

    tearDown(() async {
      await db.close();
    });

    test('getSettings gibt null zurück wenn nicht existiert', () async {
      final settings = await db.getSettings();
      expect(settings, isNull);
    });

    test('ensureSettingsExist erstellt Default-Settings', () async {
      await db.ensureSettingsExist();
      final settings = await db.getSettings();
      expect(settings, isNotNull);
      expect(settings!.locale, 'de');
      expect(settings.units, 'metric');
      expect(settings.theme, 'system');
    });

    test('upsertSettings fügt ein wenn nicht vorhanden', () async {
      await db.upsertSettings(AppSettingsCompanion(
        calorieGoal: const Value(2000),
      ));
      final settings = await db.getSettings();
      expect(settings!.calorieGoal, 2000);
    });

    test('upsertSettings updated existierende Settings', () async {
      await db.ensureSettingsExist();
      await db.upsertSettings(AppSettingsCompanion(
        calorieGoal: const Value(2500),
      ));
      final settings = await db.getSettings();
      expect(settings!.calorieGoal, 2500);
      // Andere Felder bleiben erhalten (Default-Werte)
      expect(settings.locale, 'de');
    });

    test('watchSettings ist ein Stream', () async {
      db.ensureSettingsExist();
      await expectLater(
        db.watchSettings().first,
        completion(anything),
      );
    });
  });
}
