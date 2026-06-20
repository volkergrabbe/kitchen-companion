// lib/data/repositories/impl.dart
//
// Data-Layer-Implementierungen aller Repositories.
// Mappen Drift-Rows ↔ Domain-Entities.

import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart' as repo;
import '../../domain/services/weekly_plan_engine.dart';
import '../database/database.dart';
import '../secure_storage_service.dart';
import 'offer_repository.dart' as data_repo;

class RecipeRepositoryImpl implements repo.RecipeRepository {
  final AppDatabase _db;
  RecipeRepositoryImpl(this._db);

  @override
  Stream<List<RecipeEntity>> watchAll() {
    return _db.watchAllRecipes().map((rows) =>
        rows.map(_toEntity).toList());
  }

  @override
  Future<RecipeEntity?> getById(int id) async {
    final r = await (_db.select(_db.recipes)..where((x) => x.id.equals(id)))
        .getSingleOrNull();
    if (r == null) return null;
    final entity = _toEntity(r);
    return _hydrateIngredients(entity);
  }

  @override
  Future<int> create(RecipeEntity recipe) async {
    final id = await _db.addRecipe(RecipesCompanion.insert(
      name: recipe.name,
      description: Value(_nullToEmpty(recipe.description)),
      prepTime: Value(recipe.prepTimeMinutes),
      calories: Value(recipe.calories),
      protein: Value(recipe.protein),
      carbs: Value(recipe.carbs),
      fat: Value(recipe.fat),
      createdAt: recipe.createdAt,
    ));

    for (final ing in recipe.ingredients) {
      await _db.into(_db.recipeIngredients).insert(
            RecipeIngredientsCompanion.insert(
              recipeId: id,
              ingredientId: ing.ingredientId,
              quantityPerPerson: ing.quantityPerPerson,
              unit: Value(_nullToEmpty(ing.unit)),
            ),
          );
    }
    return id;
  }

  @override
  Future<bool> update(RecipeEntity recipe) async {
    final recipeRow = await (_db.select(_db.recipes)
          ..where((x) => x.id.equals(recipe.id)))
        .getSingleOrNull();
    if (recipeRow == null) return false;
    return _db.updateRecipe(Recipe(
      id: recipeRow.id,
      name: recipe.name,
      description: recipe.description,
      prepTime: recipe.prepTimeMinutes,
      calories: recipe.calories,
      protein: recipe.protein,
      carbs: recipe.carbs,
      fat: recipe.fat,
      createdAt: recipeRow.createdAt,
    ));
  }

  @override
  Future<int> delete(int id) => _db.deleteRecipe(id);

  RecipeEntity _toEntity(Recipe r) => RecipeEntity(
        id: r.id,
        name: r.name,
        description: r.description,
        prepTimeMinutes: r.prepTime,
        calories: r.calories,
        protein: r.protein,
        carbs: r.carbs,
        fat: r.fat,
        createdAt: r.createdAt,
      );

  Future<RecipeEntity> _hydrateIngredients(RecipeEntity r) async {
    final query = _db.select(_db.recipeIngredients).join([
      innerJoin(
        _db.ingredients,
        _db.ingredients.id.equalsExp(_db.recipeIngredients.ingredientId),
      )
    ])
      ..where(_db.recipeIngredients.recipeId.equals(r.id));
    final rows = await query.get();
    final ingredients = rows
        .map((row) => RecipeIngredientEntity(
              ingredientId: row.readTable(_db.ingredients).id,
              ingredientName: row.readTable(_db.ingredients).name,
              quantityPerPerson:
                  row.readTable(_db.recipeIngredients).quantityPerPerson,
              unit: row.readTable(_db.recipeIngredients).unit,
            ))
        .toList();
    return RecipeEntity(
      id: r.id,
      name: r.name,
      description: r.description,
      prepTimeMinutes: r.prepTimeMinutes,
      calories: r.calories,
      protein: r.protein,
      carbs: r.carbs,
      fat: r.fat,
      createdAt: r.createdAt,
      ingredients: ingredients,
    );
  }
}

class WeeklyPlanRepositoryImpl implements repo.WeeklyPlanRepository {
  final AppDatabase _db;
  final WeeklyPlanEngine _engine;

  WeeklyPlanRepositoryImpl(this._db, this._engine);

  @override
  Stream<List<WeeklyPlanEntity>> watchAll() async* {
    await for (final plans in _db.watchAllPlans()) {
      final entities = <WeeklyPlanEntity>[];
      for (final p in plans) {
        final e = await _toEntity(p);
        if (e != null) entities.add(e);
      }
      yield entities;
    }
  }

  @override
  Stream<WeeklyPlanEntity?> watchActive() {
    return (_db.select(_db.weeklyPlans)
          ..where((p) => p.status.equals('active'))
          ..orderBy([(p) => OrderingTerm.desc(p.weekStart)])
          ..limit(1))
        .watchSingleOrNull()
        .asyncMap((p) async {
      if (p == null) return null;
      return _toEntity(p);
    });
  }

  @override
  Future<WeeklyPlanEntity> generate({
    required int persons,
    DateTime? weekStart,
  }) async {
    final plan = await _engine.generatePlan(
      persons: persons,
      weekStart: weekStart,
    );
    final entity = await _toEntity(plan);
    if (entity == null) {
      throw StateError('Plan-Entity konnte nicht erstellt werden');
    }
    return entity;
  }

  @override
  Future<void> delete(int planId) async {
    await (_db.delete(_db.weeklyPlans)..where((p) => p.id.equals(planId))).go();
  }

  @override
  Future<WeeklyPlanEntity?> getById(int id) async {
    final p = await (_db.select(_db.weeklyPlans)..where((x) => x.id.equals(id)))
        .getSingleOrNull();
    if (p == null) return null;
    return await _toEntity(p);
  }

  Future<WeeklyPlanEntity?> _toEntity(WeeklyPlan p) async {
    final meals = await _db.watchPlanMeals(p.id).first;
    final ingredients = await _db.watchPlanIngredients(p.id).first;

    // P0-3 (Architecture Review): Batch-Loading der Recipes am Anfang
    // statt N einzelner SELECTs pro Mahlzeit. Bei 21 Mahlzeiten
    // reduziert das die Round-Trips von 21 auf 1.

    // Discounter-Namen für Offers laden
    final offerIds = ingredients
        .map((i) => i.offerId)
        .whereType<int>()
        .toSet();
    final offers = offerIds.isEmpty
        ? <Offer>[]
        : await (_db.select(_db.offers)..where((o) => o.id.isIn(offerIds)))
            .get();
    final discounterIds = offers.map((o) => o.discounterId).toSet();
    final discounters = discounterIds.isEmpty
        ? <Discounter>[]
        : await (_db.select(_db.discounters)
              ..where((d) => d.id.isIn(discounterIds)))
            .get();
    final discounterMap = {for (final d in discounters) d.id: d.name};
    final offerMap = {for (final o in offers) o.id: o};

    final recipeIds = meals
        .map((m) => m.recipeId)
        .whereType<int>()
        .toSet();
    final recipes = recipeIds.isEmpty
        ? <Recipe>[]
        : await (_db.select(_db.recipes)..where((r) => r.id.isIn(recipeIds)))
            .get();
    final recipeNameMap = {for (final r in recipes) r.id: r.name};

    final mealEntities = meals
        .map((m) => PlanMealEntity(
              id: m.id,
              date: m.date,
              mealType: m.mealType,
              recipeId: m.recipeId,
              recipeName: m.recipeId == null
                  ? null
                  : recipeNameMap[m.recipeId],
              serves: m.serves,
            ))
        .toList();

    final ingredientNamesQuery = await (_db.select(_db.ingredients)).get();
    final ingredientNames = {
      for (final i in ingredientNamesQuery) i.id: i.name,
    };

    final shoppingList = ingredients
        .map((pi) => PlanIngredientEntity(
              ingredientId: pi.ingredientId,
              ingredientName: ingredientNames[pi.ingredientId] ?? '?',
              quantity: pi.totalQuantity,
              unit: pi.unit,
              offerPrice: pi.offerId == null ? null : offerMap[pi.offerId]?.price,
              offerDiscounterName: pi.offerId == null
                  ? null
                  : discounterMap[offerMap[pi.offerId]!.discounterId],
            ))
        .toList();

    return WeeklyPlanEntity(
      id: p.id,
      weekStart: p.weekStart,
      persons: p.persons,
      status: p.status,
      createdAt: p.createdAt,
      meals: mealEntities,
      shoppingList: shoppingList,
    );
  }
}

class OfferRepositoryImpl implements repo.OfferRepository {
  final AppDatabase _db;
  final data_repo.OfferRepository _helper;

  OfferRepositoryImpl(this._db, this._helper);

  @override
  Stream<List<OfferEntity>> watchActive() {
    return _db.watchValidOffers(DateTime.now()).asyncMap(_toEntities);
  }

  @override
  Future<Map<String, int>> refreshAll() async {
    return _helper.refreshAllOffers();
  }

  @override
  Future<List<OfferEntity>> getByIngredient(int ingredientId) async {
    final offers = await (_db.select(_db.offers)
          ..where((o) => o.ingredientId.equals(ingredientId)))
        .get();
    return _toEntities(offers);
  }

  Future<List<OfferEntity>> _toEntities(List<Offer> rows) async {
    final discounterIds = rows.map((o) => o.discounterId).toSet();
    final discounters = discounterIds.isEmpty
        ? <Discounter>[]
        : await (_db.select(_db.discounters)
              ..where((d) => d.id.isIn(discounterIds)))
            .get();
    final discounterMap = {for (final d in discounters) d.id: d.name};

    final ingredientIds = rows.map((o) => o.ingredientId).whereType<int>().toSet();
    final ingredients = ingredientIds.isEmpty
        ? <Ingredient>[]
        : await (_db.select(_db.ingredients)
              ..where((i) => i.id.isIn(ingredientIds)))
            .get();
    final ingredientMap = {for (final i in ingredients) i.id: i.name};

    return rows
        .map((o) => OfferEntity(
              id: o.id,
              discounterId: o.discounterId,
              discounterName: discounterMap[o.discounterId] ?? '?',
              ingredientId: o.ingredientId,
              ingredientName:
                  o.ingredientId == null ? null : ingredientMap[o.ingredientId],
              rawName: o.rawName,
              price: o.price,
              unitText: o.unitText,
              validFrom: o.validFrom,
              validTo: o.validTo,
              fetchedAt: o.fetchedAt,
              sourceUrl: o.sourceUrl,
            ))
        .toList();
  }
}

class ContraindicationRepositoryImpl implements repo.ContraindicationRepository {
  final AppDatabase _db;
  ContraindicationRepositoryImpl(this._db);

  @override
  Stream<List<ContraindicationEntity>> watchAll() {
    return _db.watchAllContraindications().map((rows) =>
        rows.map(_toEntity).toList());
  }

  @override
  Stream<List<ActiveContraindication>> watchActiveForUser() {
    return _db.watchActiveUserContraindications().map((rows) => rows
        .map((r) => ActiveContraindication(
              userContraindicationId: r.userContraindicationId,
              contraindicationId: r.contraindication.id,
              type: r.contraindication.type,
              code: r.contraindication.code,
              displayNameDe: r.contraindication.displayNameDe,
              displayNameEn: r.contraindication.displayNameEn,
              severity: r.severityOverride ?? r.contraindication.severity,
              warningTextDe: r.contraindication.warningTextDe,
              warningTextEn: r.contraindication.warningTextEn,
              addedAt: r.addedAt,
            )).toList());
  }

  @override
  Future<int> activateForUser(int contraindicationId) =>
      _db.addUserContraindication(contraindicationId);

  @override
  Future<int> deactivateForUser(int userContraindicationId) =>
      _db.removeUserContraindication(userContraindicationId);

  ContraindicationEntity _toEntity(Contraindication c) => ContraindicationEntity(
        id: c.id,
        type: c.type,
        code: c.code,
        displayNameDe: c.displayNameDe,
        displayNameEn: c.displayNameEn,
        excludedIngredients:
            (jsonDecode(c.excludedIngredientsJson) as List).cast<String>(),
        excludedRiskTags:
            (jsonDecode(c.excludedRiskTagsJson) as List).cast<String>(),
        severity: c.severity,
        warningTextDe: c.warningTextDe,
        warningTextEn: c.warningTextEn,
      );
}

class DiscounterRepositoryImpl implements repo.DiscounterRepository {
  final AppDatabase _db;
  DiscounterRepositoryImpl(this._db);

  @override
  Stream<List<DiscounterEntity>> watchAll() {
    return _db.watchAllDiscounters().map((rows) => rows
        .map((d) => DiscounterEntity(
              id: d.id,
              name: d.name,
              scraperClass: d.scraperClass,
              enabled: d.enabled,
            ))
        .toList());
  }

  @override
  Future<void> setEnabled(int discounterId, bool enabled) async {
    await (_db.update(_db.discounters)..where((d) => d.id.equals(discounterId)))
        .write(DiscountersCompanion(enabled: Value(enabled)));
  }
}

class ProfileRepositoryImpl implements repo.ProfileRepository {
  final AppDatabase _db;
  // P0-1 (Privacy Review): Marktguru-API-Key liegt NICHT mehr in der DB.
  final SecureStorageService _secure;
  ProfileRepositoryImpl(this._db, {SecureStorageService? secure})
      : _secure = secure ?? SecureStorageService();

  @override
  Future<int> getPersons() async {
    final p = await _db.getUserProfile();
    return p.persons;
  }

  @override
  Future<void> setPersons(int persons) async {
    await _db.updateUserProfile(persons: persons);
  }

  @override
  Future<String?> getZipCode() async {
    final p = await _db.getUserProfile();
    return p.zipCode;
  }

  @override
  Future<void> setZipCode(String? zip) async {
    await _db.updateUserProfile(zipCode: zip);
  }

  @override
  Future<List<int>> getSelectedDiscounters() async {
    final p = await _db.getUserProfile();
    if (p.selectedDiscountersJson.isEmpty) return const [];
    try {
      return (jsonDecode(p.selectedDiscountersJson) as List)
          .map((e) => (e as num).toInt())
          .toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> setSelectedDiscounters(List<int> ids) async {
    await _db.updateUserProfile(
      selectedDiscountersJson: jsonEncode(ids),
    );
  }

  @override
  Future<bool> getMarktguruEnabled() async {
    final p = await _db.getUserProfile();
    return p.marktguruEnabled;
  }

  @override
  Future<void> setMarktguruEnabled(bool enabled) async {
    await _db.updateUserProfile(marktguruEnabled: enabled);
  }

  @override
  Future<String?> getMarktguruApiKey() {
    return _secure.getMarktguruApiKey();
  }

  @override
  Future<void> setMarktguruApiKey(String? key) {
    return _secure.setMarktguruApiKey(key);
  }
}

String _nullToEmpty(String? s) => s ?? '';