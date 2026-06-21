// lib/domain/entities/entities.dart
//
// Reine Domain-Entities — keine Drift-, keine Flutter-Imports.
// Werden zwischen Data- und UI-Layer gemappt.

class RecipeEntity {
  final int id;
  final String name;
  final String? description;
  final int? prepTimeMinutes;
  final int? calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final DateTime createdAt;
  final List<RecipeIngredientEntity> ingredients;

  RecipeEntity({
    required this.id,
    required this.name,
    required this.createdAt,
    this.description,
    this.prepTimeMinutes,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.ingredients = const [],
  });
}

class RecipeIngredientEntity {
  final int ingredientId;
  final String ingredientName;
  final double quantityPerPerson;
  final String? unit;

  RecipeIngredientEntity({
    required this.ingredientId,
    required this.ingredientName,
    required this.quantityPerPerson,
    this.unit,
  });
}

class WeeklyPlanEntity {
  final int id;
  final DateTime weekStart;
  final int persons;
  final String status; // 'draft' | 'active' | 'completed'
  final DateTime createdAt;
  final List<PlanMealEntity> meals;
  final List<PlanIngredientEntity> shoppingList;

  WeeklyPlanEntity({
    required this.id,
    required this.weekStart,
    required this.persons,
    required this.status,
    required this.createdAt,
    this.meals = const [],
    this.shoppingList = const [],
  });

  bool get isEmpty => meals.isEmpty;
  bool get hasShoppingList => shoppingList.isNotEmpty;
}

class PlanMealEntity {
  final int id;
  final DateTime date;
  final String mealType;
  final int? recipeId;
  final String? recipeName;
  final int serves;

  PlanMealEntity({
    required this.id,
    required this.date,
    required this.mealType,
    required this.serves,
    this.recipeId,
    this.recipeName,
  });
}

class PlanIngredientEntity {
  final int ingredientId;
  final String ingredientName;
  final double quantity;
  final String? unit;
  final double? offerPrice;
  final String? offerDiscounterName;

  PlanIngredientEntity({
    required this.ingredientId,
    required this.ingredientName,
    required this.quantity,
    this.unit,
    this.offerPrice,
    this.offerDiscounterName,
  });
}

class ContraindicationEntity {
  final int id;
  final String type; // 'disease' | 'medication'
  final String code;
  final String displayNameDe;
  final String displayNameEn;
  final List<String> excludedIngredients;
  final List<String> excludedRiskTags;
  final String severity; // 'avoid' | 'limit' | 'caution'
  final String? warningTextDe;
  final String? warningTextEn;

  ContraindicationEntity({
    required this.id,
    required this.type,
    required this.code,
    required this.displayNameDe,
    required this.displayNameEn,
    required this.excludedIngredients,
    required this.excludedRiskTags,
    required this.severity,
    this.warningTextDe,
    this.warningTextEn,
  });

  String displayName(String locale) {
    return locale == 'de' ? displayNameDe : displayNameEn;
  }
}

/// P0-1 (Architecture Review): Wrapper-Entity, die zusätzlich zur
/// Master-Contraindication auch die user_contraindications.id
/// (Join-Tabellen-ID) hält. Wird vom UI-Layer gebraucht, um den
/// "Minus"-Button korrekt zu verdrahten — vorher wurde die
/// Master-ID genutzt, was zu einem No-Op-Delete führte.
class ActiveContraindication {
  final int userContraindicationId;
  final int contraindicationId;
  final String type; // 'disease' | 'medication'
  final String code;
  final String displayNameDe;
  final String displayNameEn;
  final String severity; // 'avoid' | 'limit' | 'caution'
  final String? warningTextDe;
  final String? warningTextEn;
  final DateTime addedAt;

  const ActiveContraindication({
    required this.userContraindicationId,
    required this.contraindicationId,
    required this.type,
    required this.code,
    required this.displayNameDe,
    required this.displayNameEn,
    required this.severity,
    this.warningTextDe,
    this.warningTextEn,
    required this.addedAt,
  });

  String displayName(String locale) {
    return locale == 'de' ? displayNameDe : displayNameEn;
  }
}

class DiscounterEntity {
  final int id;
  final String name;
  final String scraperClass;
  final bool enabled;

  DiscounterEntity({
    required this.id,
    required this.name,
    required this.scraperClass,
    required this.enabled,
  });
}

class OfferEntity {
  final int id;
  final int discounterId;
  final String discounterName;
  final int? ingredientId;
  final String? ingredientName;
  final String rawName;
  final double price;
  final String? unitText;
  final DateTime validFrom;
  final DateTime validTo;
  final DateTime fetchedAt;
  final String? sourceUrl;

  OfferEntity({
    required this.id,
    required this.discounterId,
    required this.discounterName,
    required this.rawName,
    required this.price,
    required this.validFrom,
    required this.validTo,
    required this.fetchedAt,
    this.ingredientId,
    this.ingredientName,
    this.unitText,
    this.sourceUrl,
  });
}