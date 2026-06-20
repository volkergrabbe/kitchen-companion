// lib/domain/repositories/repositories.dart
//
// Repository-Interfaces (Ports) — UI kennt nur diese, nicht die Data-Impl.

import '../entities/entities.dart';

abstract class RecipeRepository {
  Stream<List<RecipeEntity>> watchAll();
  Future<int> create(RecipeEntity recipe);
  Future<bool> update(RecipeEntity recipe);
  Future<int> delete(int id);
  Future<RecipeEntity?> getById(int id);
}

abstract class WeeklyPlanRepository {
  Stream<List<WeeklyPlanEntity>> watchAll();
  Stream<WeeklyPlanEntity?> watchActive();
  Future<WeeklyPlanEntity> generate({required int persons, DateTime? weekStart});
  Future<void> delete(int planId);
  Future<WeeklyPlanEntity?> getById(int id);
}

abstract class OfferRepository {
  Stream<List<OfferEntity>> watchActive();
  Future<Map<String, int>> refreshAll();
  Future<List<OfferEntity>> getByIngredient(int ingredientId);
}

abstract class ContraindicationRepository {
  Stream<List<ContraindicationEntity>> watchAll();
  /// Liefert aktive User-Kontraindikationen inklusive der
  /// `userContraindicationId`, die zum Deaktivieren via
  /// [deactivateForUser] benötigt wird.
  Stream<List<ActiveContraindication>> watchActiveForUser();
  Future<int> activateForUser(int contraindicationId);
  Future<int> deactivateForUser(int userContraindicationId);
}

abstract class DiscounterRepository {
  Stream<List<DiscounterEntity>> watchAll();
  Future<void> setEnabled(int discounterId, bool enabled);
}

abstract class ProfileRepository {
  Future<int> getPersons();
  Future<void> setPersons(int persons);
  Future<String?> getZipCode();
  Future<void> setZipCode(String? zip);
  Future<List<int>> getSelectedDiscounters();
  Future<void> setSelectedDiscounters(List<int> ids);
  Future<bool> getMarktguruEnabled();
  Future<void> setMarktguruEnabled(bool enabled);
  Future<String?> getMarktguruApiKey();
  Future<void> setMarktguruApiKey(String? key);
}