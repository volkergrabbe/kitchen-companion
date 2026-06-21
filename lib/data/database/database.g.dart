// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $RecipesTable extends Recipes with TableInfo<$RecipesTable, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _prepTimeMeta =
      const VerificationMeta('prepTime');
  @override
  late final GeneratedColumn<int> prepTime = GeneratedColumn<int>(
      'prep_time', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _caloriesMeta =
      const VerificationMeta('calories');
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
      'calories', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _proteinMeta =
      const VerificationMeta('protein');
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
      'protein', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
      'carbs', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
      'fat', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        prepTime,
        calories,
        protein,
        carbs,
        fat,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(Insertable<Recipe> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('prep_time')) {
      context.handle(_prepTimeMeta,
          prepTime.isAcceptableOrUnknown(data['prep_time']!, _prepTimeMeta));
    }
    if (data.containsKey('calories')) {
      context.handle(_caloriesMeta,
          calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta));
    }
    if (data.containsKey('protein')) {
      context.handle(_proteinMeta,
          protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta));
    }
    if (data.containsKey('carbs')) {
      context.handle(
          _carbsMeta, carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta));
    }
    if (data.containsKey('fat')) {
      context.handle(
          _fatMeta, fat.isAcceptableOrUnknown(data['fat']!, _fatMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipe(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      prepTime: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}prep_time']),
      calories: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}calories']),
      protein: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}protein']),
      carbs: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}carbs']),
      fat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fat']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

class Recipe extends DataClass implements Insertable<Recipe> {
  final int id;
  final String name;
  final String? description;
  final int? prepTime;
  final int? calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final DateTime createdAt;
  const Recipe(
      {required this.id,
      required this.name,
      this.description,
      this.prepTime,
      this.calories,
      this.protein,
      this.carbs,
      this.fat,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || prepTime != null) {
      map['prep_time'] = Variable<int>(prepTime);
    }
    if (!nullToAbsent || calories != null) {
      map['calories'] = Variable<int>(calories);
    }
    if (!nullToAbsent || protein != null) {
      map['protein'] = Variable<double>(protein);
    }
    if (!nullToAbsent || carbs != null) {
      map['carbs'] = Variable<double>(carbs);
    }
    if (!nullToAbsent || fat != null) {
      map['fat'] = Variable<double>(fat);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      prepTime: prepTime == null && nullToAbsent
          ? const Value.absent()
          : Value(prepTime),
      calories: calories == null && nullToAbsent
          ? const Value.absent()
          : Value(calories),
      protein: protein == null && nullToAbsent
          ? const Value.absent()
          : Value(protein),
      carbs:
          carbs == null && nullToAbsent ? const Value.absent() : Value(carbs),
      fat: fat == null && nullToAbsent ? const Value.absent() : Value(fat),
      createdAt: Value(createdAt),
    );
  }

  factory Recipe.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      prepTime: serializer.fromJson<int?>(json['prepTime']),
      calories: serializer.fromJson<int?>(json['calories']),
      protein: serializer.fromJson<double?>(json['protein']),
      carbs: serializer.fromJson<double?>(json['carbs']),
      fat: serializer.fromJson<double?>(json['fat']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'prepTime': serializer.toJson<int?>(prepTime),
      'calories': serializer.toJson<int?>(calories),
      'protein': serializer.toJson<double?>(protein),
      'carbs': serializer.toJson<double?>(carbs),
      'fat': serializer.toJson<double?>(fat),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Recipe copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<int?> prepTime = const Value.absent(),
          Value<int?> calories = const Value.absent(),
          Value<double?> protein = const Value.absent(),
          Value<double?> carbs = const Value.absent(),
          Value<double?> fat = const Value.absent(),
          DateTime? createdAt}) =>
      Recipe(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        prepTime: prepTime.present ? prepTime.value : this.prepTime,
        calories: calories.present ? calories.value : this.calories,
        protein: protein.present ? protein.value : this.protein,
        carbs: carbs.present ? carbs.value : this.carbs,
        fat: fat.present ? fat.value : this.fat,
        createdAt: createdAt ?? this.createdAt,
      );
  Recipe copyWithCompanion(RecipesCompanion data) {
    return Recipe(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      prepTime: data.prepTime.present ? data.prepTime.value : this.prepTime,
      calories: data.calories.present ? data.calories.value : this.calories,
      protein: data.protein.present ? data.protein.value : this.protein,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      fat: data.fat.present ? data.fat.value : this.fat,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recipe(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('prepTime: $prepTime, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, prepTime, calories,
      protein, carbs, fat, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.prepTime == this.prepTime &&
          other.calories == this.calories &&
          other.protein == this.protein &&
          other.carbs == this.carbs &&
          other.fat == this.fat &&
          other.createdAt == this.createdAt);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int?> prepTime;
  final Value<int?> calories;
  final Value<double?> protein;
  final Value<double?> carbs;
  final Value<double?> fat;
  final Value<DateTime> createdAt;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.prepTime = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RecipesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.prepTime = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
    required DateTime createdAt,
  })  : name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<Recipe> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? prepTime,
    Expression<int>? calories,
    Expression<double>? protein,
    Expression<double>? carbs,
    Expression<double>? fat,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (prepTime != null) 'prep_time': prepTime,
      if (calories != null) 'calories': calories,
      if (protein != null) 'protein': protein,
      if (carbs != null) 'carbs': carbs,
      if (fat != null) 'fat': fat,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RecipesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<int?>? prepTime,
      Value<int?>? calories,
      Value<double?>? protein,
      Value<double?>? carbs,
      Value<double?>? fat,
      Value<DateTime>? createdAt}) {
    return RecipesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      prepTime: prepTime ?? this.prepTime,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (prepTime.present) {
      map['prep_time'] = Variable<int>(prepTime.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<double>(carbs.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('prepTime: $prepTime, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ShoppingItemsTable extends ShoppingItems
    with TableInfo<$ShoppingItemsTable, ShoppingItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _itemMeta = const VerificationMeta('item');
  @override
  late final GeneratedColumn<String> item = GeneratedColumn<String>(
      'item', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _checkedMeta =
      const VerificationMeta('checked');
  @override
  late final GeneratedColumn<bool> checked = GeneratedColumn<bool>(
      'checked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("checked" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, item, quantity, unit, checked];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_items';
  @override
  VerificationContext validateIntegrity(Insertable<ShoppingItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item')) {
      context.handle(
          _itemMeta, item.isAcceptableOrUnknown(data['item']!, _itemMeta));
    } else if (isInserting) {
      context.missing(_itemMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('checked')) {
      context.handle(_checkedMeta,
          checked.isAcceptableOrUnknown(data['checked']!, _checkedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      item: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      checked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}checked'])!,
    );
  }

  @override
  $ShoppingItemsTable createAlias(String alias) {
    return $ShoppingItemsTable(attachedDatabase, alias);
  }
}

class ShoppingItem extends DataClass implements Insertable<ShoppingItem> {
  final int id;
  final String item;
  final double? quantity;
  final String? unit;
  final bool checked;
  const ShoppingItem(
      {required this.id,
      required this.item,
      this.quantity,
      this.unit,
      required this.checked});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item'] = Variable<String>(item);
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<double>(quantity);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['checked'] = Variable<bool>(checked);
    return map;
  }

  ShoppingItemsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingItemsCompanion(
      id: Value(id),
      item: Value(item),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      checked: Value(checked),
    );
  }

  factory ShoppingItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingItem(
      id: serializer.fromJson<int>(json['id']),
      item: serializer.fromJson<String>(json['item']),
      quantity: serializer.fromJson<double?>(json['quantity']),
      unit: serializer.fromJson<String?>(json['unit']),
      checked: serializer.fromJson<bool>(json['checked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'item': serializer.toJson<String>(item),
      'quantity': serializer.toJson<double?>(quantity),
      'unit': serializer.toJson<String?>(unit),
      'checked': serializer.toJson<bool>(checked),
    };
  }

  ShoppingItem copyWith(
          {int? id,
          String? item,
          Value<double?> quantity = const Value.absent(),
          Value<String?> unit = const Value.absent(),
          bool? checked}) =>
      ShoppingItem(
        id: id ?? this.id,
        item: item ?? this.item,
        quantity: quantity.present ? quantity.value : this.quantity,
        unit: unit.present ? unit.value : this.unit,
        checked: checked ?? this.checked,
      );
  ShoppingItem copyWithCompanion(ShoppingItemsCompanion data) {
    return ShoppingItem(
      id: data.id.present ? data.id.value : this.id,
      item: data.item.present ? data.item.value : this.item,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      checked: data.checked.present ? data.checked.value : this.checked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItem(')
          ..write('id: $id, ')
          ..write('item: $item, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('checked: $checked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, item, quantity, unit, checked);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingItem &&
          other.id == this.id &&
          other.item == this.item &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.checked == this.checked);
}

class ShoppingItemsCompanion extends UpdateCompanion<ShoppingItem> {
  final Value<int> id;
  final Value<String> item;
  final Value<double?> quantity;
  final Value<String?> unit;
  final Value<bool> checked;
  const ShoppingItemsCompanion({
    this.id = const Value.absent(),
    this.item = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.checked = const Value.absent(),
  });
  ShoppingItemsCompanion.insert({
    this.id = const Value.absent(),
    required String item,
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.checked = const Value.absent(),
  }) : item = Value(item);
  static Insertable<ShoppingItem> custom({
    Expression<int>? id,
    Expression<String>? item,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<bool>? checked,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (item != null) 'item': item,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (checked != null) 'checked': checked,
    });
  }

  ShoppingItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? item,
      Value<double?>? quantity,
      Value<String?>? unit,
      Value<bool>? checked}) {
    return ShoppingItemsCompanion(
      id: id ?? this.id,
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      checked: checked ?? this.checked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (item.present) {
      map['item'] = Variable<String>(item.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (checked.present) {
      map['checked'] = Variable<bool>(checked.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItemsCompanion(')
          ..write('id: $id, ')
          ..write('item: $item, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('checked: $checked')
          ..write(')'))
        .toString();
  }
}

class $FoodLogTable extends FoodLog with TableInfo<$FoodLogTable, FoodLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mealTypeMeta =
      const VerificationMeta('mealType');
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
      'meal_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _caloriesMeta =
      const VerificationMeta('calories');
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
      'calories', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _proteinMeta =
      const VerificationMeta('protein');
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
      'protein', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
      'carbs', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
      'fat', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _customNameMeta =
      const VerificationMeta('customName');
  @override
  late final GeneratedColumn<String> customName = GeneratedColumn<String>(
      'custom_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, mealType, calories, protein, carbs, fat, customName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_log';
  @override
  VerificationContext validateIntegrity(Insertable<FoodLogData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(_mealTypeMeta,
          mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta));
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(_caloriesMeta,
          calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta));
    }
    if (data.containsKey('protein')) {
      context.handle(_proteinMeta,
          protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta));
    }
    if (data.containsKey('carbs')) {
      context.handle(
          _carbsMeta, carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta));
    }
    if (data.containsKey('fat')) {
      context.handle(
          _fatMeta, fat.isAcceptableOrUnknown(data['fat']!, _fatMeta));
    }
    if (data.containsKey('custom_name')) {
      context.handle(
          _customNameMeta,
          customName.isAcceptableOrUnknown(
              data['custom_name']!, _customNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodLogData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      mealType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meal_type'])!,
      calories: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}calories']),
      protein: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}protein']),
      carbs: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}carbs']),
      fat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fat']),
      customName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_name']),
    );
  }

  @override
  $FoodLogTable createAlias(String alias) {
    return $FoodLogTable(attachedDatabase, alias);
  }
}

class FoodLogData extends DataClass implements Insertable<FoodLogData> {
  final int id;
  final String date;
  final String mealType;
  final int? calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final String? customName;
  const FoodLogData(
      {required this.id,
      required this.date,
      required this.mealType,
      this.calories,
      this.protein,
      this.carbs,
      this.fat,
      this.customName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['meal_type'] = Variable<String>(mealType);
    if (!nullToAbsent || calories != null) {
      map['calories'] = Variable<int>(calories);
    }
    if (!nullToAbsent || protein != null) {
      map['protein'] = Variable<double>(protein);
    }
    if (!nullToAbsent || carbs != null) {
      map['carbs'] = Variable<double>(carbs);
    }
    if (!nullToAbsent || fat != null) {
      map['fat'] = Variable<double>(fat);
    }
    if (!nullToAbsent || customName != null) {
      map['custom_name'] = Variable<String>(customName);
    }
    return map;
  }

  FoodLogCompanion toCompanion(bool nullToAbsent) {
    return FoodLogCompanion(
      id: Value(id),
      date: Value(date),
      mealType: Value(mealType),
      calories: calories == null && nullToAbsent
          ? const Value.absent()
          : Value(calories),
      protein: protein == null && nullToAbsent
          ? const Value.absent()
          : Value(protein),
      carbs:
          carbs == null && nullToAbsent ? const Value.absent() : Value(carbs),
      fat: fat == null && nullToAbsent ? const Value.absent() : Value(fat),
      customName: customName == null && nullToAbsent
          ? const Value.absent()
          : Value(customName),
    );
  }

  factory FoodLogData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodLogData(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      mealType: serializer.fromJson<String>(json['mealType']),
      calories: serializer.fromJson<int?>(json['calories']),
      protein: serializer.fromJson<double?>(json['protein']),
      carbs: serializer.fromJson<double?>(json['carbs']),
      fat: serializer.fromJson<double?>(json['fat']),
      customName: serializer.fromJson<String?>(json['customName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'mealType': serializer.toJson<String>(mealType),
      'calories': serializer.toJson<int?>(calories),
      'protein': serializer.toJson<double?>(protein),
      'carbs': serializer.toJson<double?>(carbs),
      'fat': serializer.toJson<double?>(fat),
      'customName': serializer.toJson<String?>(customName),
    };
  }

  FoodLogData copyWith(
          {int? id,
          String? date,
          String? mealType,
          Value<int?> calories = const Value.absent(),
          Value<double?> protein = const Value.absent(),
          Value<double?> carbs = const Value.absent(),
          Value<double?> fat = const Value.absent(),
          Value<String?> customName = const Value.absent()}) =>
      FoodLogData(
        id: id ?? this.id,
        date: date ?? this.date,
        mealType: mealType ?? this.mealType,
        calories: calories.present ? calories.value : this.calories,
        protein: protein.present ? protein.value : this.protein,
        carbs: carbs.present ? carbs.value : this.carbs,
        fat: fat.present ? fat.value : this.fat,
        customName: customName.present ? customName.value : this.customName,
      );
  FoodLogData copyWithCompanion(FoodLogCompanion data) {
    return FoodLogData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      calories: data.calories.present ? data.calories.value : this.calories,
      protein: data.protein.present ? data.protein.value : this.protein,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      fat: data.fat.present ? data.fat.value : this.fat,
      customName:
          data.customName.present ? data.customName.value : this.customName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodLogData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('mealType: $mealType, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('customName: $customName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, date, mealType, calories, protein, carbs, fat, customName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodLogData &&
          other.id == this.id &&
          other.date == this.date &&
          other.mealType == this.mealType &&
          other.calories == this.calories &&
          other.protein == this.protein &&
          other.carbs == this.carbs &&
          other.fat == this.fat &&
          other.customName == this.customName);
}

class FoodLogCompanion extends UpdateCompanion<FoodLogData> {
  final Value<int> id;
  final Value<String> date;
  final Value<String> mealType;
  final Value<int?> calories;
  final Value<double?> protein;
  final Value<double?> carbs;
  final Value<double?> fat;
  final Value<String?> customName;
  const FoodLogCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.mealType = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
    this.customName = const Value.absent(),
  });
  FoodLogCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required String mealType,
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
    this.customName = const Value.absent(),
  })  : date = Value(date),
        mealType = Value(mealType);
  static Insertable<FoodLogData> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<String>? mealType,
    Expression<int>? calories,
    Expression<double>? protein,
    Expression<double>? carbs,
    Expression<double>? fat,
    Expression<String>? customName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (mealType != null) 'meal_type': mealType,
      if (calories != null) 'calories': calories,
      if (protein != null) 'protein': protein,
      if (carbs != null) 'carbs': carbs,
      if (fat != null) 'fat': fat,
      if (customName != null) 'custom_name': customName,
    });
  }

  FoodLogCompanion copyWith(
      {Value<int>? id,
      Value<String>? date,
      Value<String>? mealType,
      Value<int?>? calories,
      Value<double?>? protein,
      Value<double?>? carbs,
      Value<double?>? fat,
      Value<String?>? customName}) {
    return FoodLogCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      customName: customName ?? this.customName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<double>(carbs.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (customName.present) {
      map['custom_name'] = Variable<String>(customName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodLogCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('mealType: $mealType, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('customName: $customName')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
      'locale', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('de'));
  static const VerificationMeta _unitsMeta = const VerificationMeta('units');
  @override
  late final GeneratedColumn<String> units = GeneratedColumn<String>(
      'units', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('metric'));
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
      'theme', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('system'));
  static const VerificationMeta _calorieGoalMeta =
      const VerificationMeta('calorieGoal');
  @override
  late final GeneratedColumn<int> calorieGoal = GeneratedColumn<int>(
      'calorie_goal', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _proteinGoalMeta =
      const VerificationMeta('proteinGoal');
  @override
  late final GeneratedColumn<double> proteinGoal = GeneratedColumn<double>(
      'protein_goal', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _carbsGoalMeta =
      const VerificationMeta('carbsGoal');
  @override
  late final GeneratedColumn<double> carbsGoal = GeneratedColumn<double>(
      'carbs_goal', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fatGoalMeta =
      const VerificationMeta('fatGoal');
  @override
  late final GeneratedColumn<double> fatGoal = GeneratedColumn<double>(
      'fat_goal', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, locale, units, theme, calorieGoal, proteinGoal, carbsGoal, fatGoal];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('locale')) {
      context.handle(_localeMeta,
          locale.isAcceptableOrUnknown(data['locale']!, _localeMeta));
    }
    if (data.containsKey('units')) {
      context.handle(
          _unitsMeta, units.isAcceptableOrUnknown(data['units']!, _unitsMeta));
    }
    if (data.containsKey('theme')) {
      context.handle(
          _themeMeta, theme.isAcceptableOrUnknown(data['theme']!, _themeMeta));
    }
    if (data.containsKey('calorie_goal')) {
      context.handle(
          _calorieGoalMeta,
          calorieGoal.isAcceptableOrUnknown(
              data['calorie_goal']!, _calorieGoalMeta));
    }
    if (data.containsKey('protein_goal')) {
      context.handle(
          _proteinGoalMeta,
          proteinGoal.isAcceptableOrUnknown(
              data['protein_goal']!, _proteinGoalMeta));
    }
    if (data.containsKey('carbs_goal')) {
      context.handle(_carbsGoalMeta,
          carbsGoal.isAcceptableOrUnknown(data['carbs_goal']!, _carbsGoalMeta));
    }
    if (data.containsKey('fat_goal')) {
      context.handle(_fatGoalMeta,
          fatGoal.isAcceptableOrUnknown(data['fat_goal']!, _fatGoalMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      locale: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}locale'])!,
      units: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}units'])!,
      theme: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme'])!,
      calorieGoal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}calorie_goal']),
      proteinGoal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}protein_goal']),
      carbsGoal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}carbs_goal']),
      fatGoal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fat_goal']),
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final String locale;
  final String units;
  final String theme;
  final int? calorieGoal;
  final double? proteinGoal;
  final double? carbsGoal;
  final double? fatGoal;
  const Setting(
      {required this.id,
      required this.locale,
      required this.units,
      required this.theme,
      this.calorieGoal,
      this.proteinGoal,
      this.carbsGoal,
      this.fatGoal});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['locale'] = Variable<String>(locale);
    map['units'] = Variable<String>(units);
    map['theme'] = Variable<String>(theme);
    if (!nullToAbsent || calorieGoal != null) {
      map['calorie_goal'] = Variable<int>(calorieGoal);
    }
    if (!nullToAbsent || proteinGoal != null) {
      map['protein_goal'] = Variable<double>(proteinGoal);
    }
    if (!nullToAbsent || carbsGoal != null) {
      map['carbs_goal'] = Variable<double>(carbsGoal);
    }
    if (!nullToAbsent || fatGoal != null) {
      map['fat_goal'] = Variable<double>(fatGoal);
    }
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      locale: Value(locale),
      units: Value(units),
      theme: Value(theme),
      calorieGoal: calorieGoal == null && nullToAbsent
          ? const Value.absent()
          : Value(calorieGoal),
      proteinGoal: proteinGoal == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinGoal),
      carbsGoal: carbsGoal == null && nullToAbsent
          ? const Value.absent()
          : Value(carbsGoal),
      fatGoal: fatGoal == null && nullToAbsent
          ? const Value.absent()
          : Value(fatGoal),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      locale: serializer.fromJson<String>(json['locale']),
      units: serializer.fromJson<String>(json['units']),
      theme: serializer.fromJson<String>(json['theme']),
      calorieGoal: serializer.fromJson<int?>(json['calorieGoal']),
      proteinGoal: serializer.fromJson<double?>(json['proteinGoal']),
      carbsGoal: serializer.fromJson<double?>(json['carbsGoal']),
      fatGoal: serializer.fromJson<double?>(json['fatGoal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'locale': serializer.toJson<String>(locale),
      'units': serializer.toJson<String>(units),
      'theme': serializer.toJson<String>(theme),
      'calorieGoal': serializer.toJson<int?>(calorieGoal),
      'proteinGoal': serializer.toJson<double?>(proteinGoal),
      'carbsGoal': serializer.toJson<double?>(carbsGoal),
      'fatGoal': serializer.toJson<double?>(fatGoal),
    };
  }

  Setting copyWith(
          {int? id,
          String? locale,
          String? units,
          String? theme,
          Value<int?> calorieGoal = const Value.absent(),
          Value<double?> proteinGoal = const Value.absent(),
          Value<double?> carbsGoal = const Value.absent(),
          Value<double?> fatGoal = const Value.absent()}) =>
      Setting(
        id: id ?? this.id,
        locale: locale ?? this.locale,
        units: units ?? this.units,
        theme: theme ?? this.theme,
        calorieGoal: calorieGoal.present ? calorieGoal.value : this.calorieGoal,
        proteinGoal: proteinGoal.present ? proteinGoal.value : this.proteinGoal,
        carbsGoal: carbsGoal.present ? carbsGoal.value : this.carbsGoal,
        fatGoal: fatGoal.present ? fatGoal.value : this.fatGoal,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      id: data.id.present ? data.id.value : this.id,
      locale: data.locale.present ? data.locale.value : this.locale,
      units: data.units.present ? data.units.value : this.units,
      theme: data.theme.present ? data.theme.value : this.theme,
      calorieGoal:
          data.calorieGoal.present ? data.calorieGoal.value : this.calorieGoal,
      proteinGoal:
          data.proteinGoal.present ? data.proteinGoal.value : this.proteinGoal,
      carbsGoal: data.carbsGoal.present ? data.carbsGoal.value : this.carbsGoal,
      fatGoal: data.fatGoal.present ? data.fatGoal.value : this.fatGoal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('locale: $locale, ')
          ..write('units: $units, ')
          ..write('theme: $theme, ')
          ..write('calorieGoal: $calorieGoal, ')
          ..write('proteinGoal: $proteinGoal, ')
          ..write('carbsGoal: $carbsGoal, ')
          ..write('fatGoal: $fatGoal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, locale, units, theme, calorieGoal, proteinGoal, carbsGoal, fatGoal);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.locale == this.locale &&
          other.units == this.units &&
          other.theme == this.theme &&
          other.calorieGoal == this.calorieGoal &&
          other.proteinGoal == this.proteinGoal &&
          other.carbsGoal == this.carbsGoal &&
          other.fatGoal == this.fatGoal);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<String> locale;
  final Value<String> units;
  final Value<String> theme;
  final Value<int?> calorieGoal;
  final Value<double?> proteinGoal;
  final Value<double?> carbsGoal;
  final Value<double?> fatGoal;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.locale = const Value.absent(),
    this.units = const Value.absent(),
    this.theme = const Value.absent(),
    this.calorieGoal = const Value.absent(),
    this.proteinGoal = const Value.absent(),
    this.carbsGoal = const Value.absent(),
    this.fatGoal = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.locale = const Value.absent(),
    this.units = const Value.absent(),
    this.theme = const Value.absent(),
    this.calorieGoal = const Value.absent(),
    this.proteinGoal = const Value.absent(),
    this.carbsGoal = const Value.absent(),
    this.fatGoal = const Value.absent(),
  });
  static Insertable<Setting> custom({
    Expression<int>? id,
    Expression<String>? locale,
    Expression<String>? units,
    Expression<String>? theme,
    Expression<int>? calorieGoal,
    Expression<double>? proteinGoal,
    Expression<double>? carbsGoal,
    Expression<double>? fatGoal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locale != null) 'locale': locale,
      if (units != null) 'units': units,
      if (theme != null) 'theme': theme,
      if (calorieGoal != null) 'calorie_goal': calorieGoal,
      if (proteinGoal != null) 'protein_goal': proteinGoal,
      if (carbsGoal != null) 'carbs_goal': carbsGoal,
      if (fatGoal != null) 'fat_goal': fatGoal,
    });
  }

  SettingsCompanion copyWith(
      {Value<int>? id,
      Value<String>? locale,
      Value<String>? units,
      Value<String>? theme,
      Value<int?>? calorieGoal,
      Value<double?>? proteinGoal,
      Value<double?>? carbsGoal,
      Value<double?>? fatGoal}) {
    return SettingsCompanion(
      id: id ?? this.id,
      locale: locale ?? this.locale,
      units: units ?? this.units,
      theme: theme ?? this.theme,
      calorieGoal: calorieGoal ?? this.calorieGoal,
      proteinGoal: proteinGoal ?? this.proteinGoal,
      carbsGoal: carbsGoal ?? this.carbsGoal,
      fatGoal: fatGoal ?? this.fatGoal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (units.present) {
      map['units'] = Variable<String>(units.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (calorieGoal.present) {
      map['calorie_goal'] = Variable<int>(calorieGoal.value);
    }
    if (proteinGoal.present) {
      map['protein_goal'] = Variable<double>(proteinGoal.value);
    }
    if (carbsGoal.present) {
      map['carbs_goal'] = Variable<double>(carbsGoal.value);
    }
    if (fatGoal.present) {
      map['fat_goal'] = Variable<double>(fatGoal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('locale: $locale, ')
          ..write('units: $units, ')
          ..write('theme: $theme, ')
          ..write('calorieGoal: $calorieGoal, ')
          ..write('proteinGoal: $proteinGoal, ')
          ..write('carbsGoal: $carbsGoal, ')
          ..write('fatGoal: $fatGoal')
          ..write(')'))
        .toString();
  }
}

class $IngredientsTable extends Ingredients
    with TableInfo<$IngredientsTable, Ingredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _seasonStartMeta =
      const VerificationMeta('seasonStart');
  @override
  late final GeneratedColumn<int> seasonStart = GeneratedColumn<int>(
      'season_start', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _seasonEndMeta =
      const VerificationMeta('seasonEnd');
  @override
  late final GeneratedColumn<int> seasonEnd = GeneratedColumn<int>(
      'season_end', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _allergensJsonMeta =
      const VerificationMeta('allergensJson');
  @override
  late final GeneratedColumn<String> allergensJson = GeneratedColumn<String>(
      'allergens_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _riskTagsJsonMeta =
      const VerificationMeta('riskTagsJson');
  @override
  late final GeneratedColumn<String> riskTagsJson = GeneratedColumn<String>(
      'risk_tags_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _unitDefaultMeta =
      const VerificationMeta('unitDefault');
  @override
  late final GeneratedColumn<String> unitDefault = GeneratedColumn<String>(
      'unit_default', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        category,
        seasonStart,
        seasonEnd,
        allergensJson,
        riskTagsJson,
        unitDefault
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients';
  @override
  VerificationContext validateIntegrity(Insertable<Ingredient> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('season_start')) {
      context.handle(
          _seasonStartMeta,
          seasonStart.isAcceptableOrUnknown(
              data['season_start']!, _seasonStartMeta));
    }
    if (data.containsKey('season_end')) {
      context.handle(_seasonEndMeta,
          seasonEnd.isAcceptableOrUnknown(data['season_end']!, _seasonEndMeta));
    }
    if (data.containsKey('allergens_json')) {
      context.handle(
          _allergensJsonMeta,
          allergensJson.isAcceptableOrUnknown(
              data['allergens_json']!, _allergensJsonMeta));
    }
    if (data.containsKey('risk_tags_json')) {
      context.handle(
          _riskTagsJsonMeta,
          riskTagsJson.isAcceptableOrUnknown(
              data['risk_tags_json']!, _riskTagsJsonMeta));
    }
    if (data.containsKey('unit_default')) {
      context.handle(
          _unitDefaultMeta,
          unitDefault.isAcceptableOrUnknown(
              data['unit_default']!, _unitDefaultMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ingredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ingredient(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      seasonStart: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}season_start'])!,
      seasonEnd: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}season_end'])!,
      allergensJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}allergens_json'])!,
      riskTagsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}risk_tags_json'])!,
      unitDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_default']),
    );
  }

  @override
  $IngredientsTable createAlias(String alias) {
    return $IngredientsTable(attachedDatabase, alias);
  }
}

class Ingredient extends DataClass implements Insertable<Ingredient> {
  final int id;
  final String name;
  final String? category;
  final int seasonStart;
  final int seasonEnd;
  final String allergensJson;
  final String riskTagsJson;
  final String? unitDefault;
  const Ingredient(
      {required this.id,
      required this.name,
      this.category,
      required this.seasonStart,
      required this.seasonEnd,
      required this.allergensJson,
      required this.riskTagsJson,
      this.unitDefault});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['season_start'] = Variable<int>(seasonStart);
    map['season_end'] = Variable<int>(seasonEnd);
    map['allergens_json'] = Variable<String>(allergensJson);
    map['risk_tags_json'] = Variable<String>(riskTagsJson);
    if (!nullToAbsent || unitDefault != null) {
      map['unit_default'] = Variable<String>(unitDefault);
    }
    return map;
  }

  IngredientsCompanion toCompanion(bool nullToAbsent) {
    return IngredientsCompanion(
      id: Value(id),
      name: Value(name),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      seasonStart: Value(seasonStart),
      seasonEnd: Value(seasonEnd),
      allergensJson: Value(allergensJson),
      riskTagsJson: Value(riskTagsJson),
      unitDefault: unitDefault == null && nullToAbsent
          ? const Value.absent()
          : Value(unitDefault),
    );
  }

  factory Ingredient.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ingredient(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String?>(json['category']),
      seasonStart: serializer.fromJson<int>(json['seasonStart']),
      seasonEnd: serializer.fromJson<int>(json['seasonEnd']),
      allergensJson: serializer.fromJson<String>(json['allergensJson']),
      riskTagsJson: serializer.fromJson<String>(json['riskTagsJson']),
      unitDefault: serializer.fromJson<String?>(json['unitDefault']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String?>(category),
      'seasonStart': serializer.toJson<int>(seasonStart),
      'seasonEnd': serializer.toJson<int>(seasonEnd),
      'allergensJson': serializer.toJson<String>(allergensJson),
      'riskTagsJson': serializer.toJson<String>(riskTagsJson),
      'unitDefault': serializer.toJson<String?>(unitDefault),
    };
  }

  Ingredient copyWith(
          {int? id,
          String? name,
          Value<String?> category = const Value.absent(),
          int? seasonStart,
          int? seasonEnd,
          String? allergensJson,
          String? riskTagsJson,
          Value<String?> unitDefault = const Value.absent()}) =>
      Ingredient(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category.present ? category.value : this.category,
        seasonStart: seasonStart ?? this.seasonStart,
        seasonEnd: seasonEnd ?? this.seasonEnd,
        allergensJson: allergensJson ?? this.allergensJson,
        riskTagsJson: riskTagsJson ?? this.riskTagsJson,
        unitDefault: unitDefault.present ? unitDefault.value : this.unitDefault,
      );
  Ingredient copyWithCompanion(IngredientsCompanion data) {
    return Ingredient(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      seasonStart:
          data.seasonStart.present ? data.seasonStart.value : this.seasonStart,
      seasonEnd: data.seasonEnd.present ? data.seasonEnd.value : this.seasonEnd,
      allergensJson: data.allergensJson.present
          ? data.allergensJson.value
          : this.allergensJson,
      riskTagsJson: data.riskTagsJson.present
          ? data.riskTagsJson.value
          : this.riskTagsJson,
      unitDefault:
          data.unitDefault.present ? data.unitDefault.value : this.unitDefault,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ingredient(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('seasonStart: $seasonStart, ')
          ..write('seasonEnd: $seasonEnd, ')
          ..write('allergensJson: $allergensJson, ')
          ..write('riskTagsJson: $riskTagsJson, ')
          ..write('unitDefault: $unitDefault')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, category, seasonStart, seasonEnd,
      allergensJson, riskTagsJson, unitDefault);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ingredient &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.seasonStart == this.seasonStart &&
          other.seasonEnd == this.seasonEnd &&
          other.allergensJson == this.allergensJson &&
          other.riskTagsJson == this.riskTagsJson &&
          other.unitDefault == this.unitDefault);
}

class IngredientsCompanion extends UpdateCompanion<Ingredient> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> category;
  final Value<int> seasonStart;
  final Value<int> seasonEnd;
  final Value<String> allergensJson;
  final Value<String> riskTagsJson;
  final Value<String?> unitDefault;
  const IngredientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.seasonStart = const Value.absent(),
    this.seasonEnd = const Value.absent(),
    this.allergensJson = const Value.absent(),
    this.riskTagsJson = const Value.absent(),
    this.unitDefault = const Value.absent(),
  });
  IngredientsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.category = const Value.absent(),
    this.seasonStart = const Value.absent(),
    this.seasonEnd = const Value.absent(),
    this.allergensJson = const Value.absent(),
    this.riskTagsJson = const Value.absent(),
    this.unitDefault = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Ingredient> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<int>? seasonStart,
    Expression<int>? seasonEnd,
    Expression<String>? allergensJson,
    Expression<String>? riskTagsJson,
    Expression<String>? unitDefault,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (seasonStart != null) 'season_start': seasonStart,
      if (seasonEnd != null) 'season_end': seasonEnd,
      if (allergensJson != null) 'allergens_json': allergensJson,
      if (riskTagsJson != null) 'risk_tags_json': riskTagsJson,
      if (unitDefault != null) 'unit_default': unitDefault,
    });
  }

  IngredientsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? category,
      Value<int>? seasonStart,
      Value<int>? seasonEnd,
      Value<String>? allergensJson,
      Value<String>? riskTagsJson,
      Value<String?>? unitDefault}) {
    return IngredientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      seasonStart: seasonStart ?? this.seasonStart,
      seasonEnd: seasonEnd ?? this.seasonEnd,
      allergensJson: allergensJson ?? this.allergensJson,
      riskTagsJson: riskTagsJson ?? this.riskTagsJson,
      unitDefault: unitDefault ?? this.unitDefault,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (seasonStart.present) {
      map['season_start'] = Variable<int>(seasonStart.value);
    }
    if (seasonEnd.present) {
      map['season_end'] = Variable<int>(seasonEnd.value);
    }
    if (allergensJson.present) {
      map['allergens_json'] = Variable<String>(allergensJson.value);
    }
    if (riskTagsJson.present) {
      map['risk_tags_json'] = Variable<String>(riskTagsJson.value);
    }
    if (unitDefault.present) {
      map['unit_default'] = Variable<String>(unitDefault.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('seasonStart: $seasonStart, ')
          ..write('seasonEnd: $seasonEnd, ')
          ..write('allergensJson: $allergensJson, ')
          ..write('riskTagsJson: $riskTagsJson, ')
          ..write('unitDefault: $unitDefault')
          ..write(')'))
        .toString();
  }
}

class $RecipeIngredientsTable extends RecipeIngredients
    with TableInfo<$RecipeIngredientsTable, RecipeIngredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeIngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES recipes (id) ON DELETE CASCADE'));
  static const VerificationMeta _ingredientIdMeta =
      const VerificationMeta('ingredientId');
  @override
  late final GeneratedColumn<int> ingredientId = GeneratedColumn<int>(
      'ingredient_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES ingredients (id) ON DELETE RESTRICT'));
  static const VerificationMeta _quantityPerPersonMeta =
      const VerificationMeta('quantityPerPerson');
  @override
  late final GeneratedColumn<double> quantityPerPerson =
      GeneratedColumn<double>('quantity_per_person', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [recipeId, ingredientId, quantityPerPerson, unit];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_ingredients';
  @override
  VerificationContext validateIntegrity(Insertable<RecipeIngredient> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
          _ingredientIdMeta,
          ingredientId.isAcceptableOrUnknown(
              data['ingredient_id']!, _ingredientIdMeta));
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('quantity_per_person')) {
      context.handle(
          _quantityPerPersonMeta,
          quantityPerPerson.isAcceptableOrUnknown(
              data['quantity_per_person']!, _quantityPerPersonMeta));
    } else if (isInserting) {
      context.missing(_quantityPerPersonMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recipeId, ingredientId};
  @override
  RecipeIngredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeIngredient(
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recipe_id'])!,
      ingredientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ingredient_id'])!,
      quantityPerPerson: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}quantity_per_person'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
    );
  }

  @override
  $RecipeIngredientsTable createAlias(String alias) {
    return $RecipeIngredientsTable(attachedDatabase, alias);
  }
}

class RecipeIngredient extends DataClass
    implements Insertable<RecipeIngredient> {
  final int recipeId;
  final int ingredientId;
  final double quantityPerPerson;
  final String? unit;
  const RecipeIngredient(
      {required this.recipeId,
      required this.ingredientId,
      required this.quantityPerPerson,
      this.unit});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['recipe_id'] = Variable<int>(recipeId);
    map['ingredient_id'] = Variable<int>(ingredientId);
    map['quantity_per_person'] = Variable<double>(quantityPerPerson);
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    return map;
  }

  RecipeIngredientsCompanion toCompanion(bool nullToAbsent) {
    return RecipeIngredientsCompanion(
      recipeId: Value(recipeId),
      ingredientId: Value(ingredientId),
      quantityPerPerson: Value(quantityPerPerson),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
    );
  }

  factory RecipeIngredient.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeIngredient(
      recipeId: serializer.fromJson<int>(json['recipeId']),
      ingredientId: serializer.fromJson<int>(json['ingredientId']),
      quantityPerPerson: serializer.fromJson<double>(json['quantityPerPerson']),
      unit: serializer.fromJson<String?>(json['unit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recipeId': serializer.toJson<int>(recipeId),
      'ingredientId': serializer.toJson<int>(ingredientId),
      'quantityPerPerson': serializer.toJson<double>(quantityPerPerson),
      'unit': serializer.toJson<String?>(unit),
    };
  }

  RecipeIngredient copyWith(
          {int? recipeId,
          int? ingredientId,
          double? quantityPerPerson,
          Value<String?> unit = const Value.absent()}) =>
      RecipeIngredient(
        recipeId: recipeId ?? this.recipeId,
        ingredientId: ingredientId ?? this.ingredientId,
        quantityPerPerson: quantityPerPerson ?? this.quantityPerPerson,
        unit: unit.present ? unit.value : this.unit,
      );
  RecipeIngredient copyWithCompanion(RecipeIngredientsCompanion data) {
    return RecipeIngredient(
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      quantityPerPerson: data.quantityPerPerson.present
          ? data.quantityPerPerson.value
          : this.quantityPerPerson,
      unit: data.unit.present ? data.unit.value : this.unit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeIngredient(')
          ..write('recipeId: $recipeId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantityPerPerson: $quantityPerPerson, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(recipeId, ingredientId, quantityPerPerson, unit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeIngredient &&
          other.recipeId == this.recipeId &&
          other.ingredientId == this.ingredientId &&
          other.quantityPerPerson == this.quantityPerPerson &&
          other.unit == this.unit);
}

class RecipeIngredientsCompanion extends UpdateCompanion<RecipeIngredient> {
  final Value<int> recipeId;
  final Value<int> ingredientId;
  final Value<double> quantityPerPerson;
  final Value<String?> unit;
  final Value<int> rowid;
  const RecipeIngredientsCompanion({
    this.recipeId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.quantityPerPerson = const Value.absent(),
    this.unit = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeIngredientsCompanion.insert({
    required int recipeId,
    required int ingredientId,
    required double quantityPerPerson,
    this.unit = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : recipeId = Value(recipeId),
        ingredientId = Value(ingredientId),
        quantityPerPerson = Value(quantityPerPerson);
  static Insertable<RecipeIngredient> custom({
    Expression<int>? recipeId,
    Expression<int>? ingredientId,
    Expression<double>? quantityPerPerson,
    Expression<String>? unit,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recipeId != null) 'recipe_id': recipeId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (quantityPerPerson != null) 'quantity_per_person': quantityPerPerson,
      if (unit != null) 'unit': unit,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeIngredientsCompanion copyWith(
      {Value<int>? recipeId,
      Value<int>? ingredientId,
      Value<double>? quantityPerPerson,
      Value<String?>? unit,
      Value<int>? rowid}) {
    return RecipeIngredientsCompanion(
      recipeId: recipeId ?? this.recipeId,
      ingredientId: ingredientId ?? this.ingredientId,
      quantityPerPerson: quantityPerPerson ?? this.quantityPerPerson,
      unit: unit ?? this.unit,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<int>(ingredientId.value);
    }
    if (quantityPerPerson.present) {
      map['quantity_per_person'] = Variable<double>(quantityPerPerson.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeIngredientsCompanion(')
          ..write('recipeId: $recipeId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantityPerPerson: $quantityPerPerson, ')
          ..write('unit: $unit, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContraindicationsTable extends Contraindications
    with TableInfo<$ContraindicationsTable, Contraindication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContraindicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _displayNameDeMeta =
      const VerificationMeta('displayNameDe');
  @override
  late final GeneratedColumn<String> displayNameDe = GeneratedColumn<String>(
      'display_name_de', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameEnMeta =
      const VerificationMeta('displayNameEn');
  @override
  late final GeneratedColumn<String> displayNameEn = GeneratedColumn<String>(
      'display_name_en', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _excludedIngredientsJsonMeta =
      const VerificationMeta('excludedIngredientsJson');
  @override
  late final GeneratedColumn<String> excludedIngredientsJson =
      GeneratedColumn<String>('excluded_ingredients_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _excludedRiskTagsJsonMeta =
      const VerificationMeta('excludedRiskTagsJson');
  @override
  late final GeneratedColumn<String> excludedRiskTagsJson =
      GeneratedColumn<String>('excluded_risk_tags_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _severityMeta =
      const VerificationMeta('severity');
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
      'severity', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('avoid'));
  static const VerificationMeta _warningTextDeMeta =
      const VerificationMeta('warningTextDe');
  @override
  late final GeneratedColumn<String> warningTextDe = GeneratedColumn<String>(
      'warning_text_de', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _warningTextEnMeta =
      const VerificationMeta('warningTextEn');
  @override
  late final GeneratedColumn<String> warningTextEn = GeneratedColumn<String>(
      'warning_text_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        type,
        code,
        displayNameDe,
        displayNameEn,
        excludedIngredientsJson,
        excludedRiskTagsJson,
        severity,
        warningTextDe,
        warningTextEn
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contraindications';
  @override
  VerificationContext validateIntegrity(Insertable<Contraindication> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('display_name_de')) {
      context.handle(
          _displayNameDeMeta,
          displayNameDe.isAcceptableOrUnknown(
              data['display_name_de']!, _displayNameDeMeta));
    } else if (isInserting) {
      context.missing(_displayNameDeMeta);
    }
    if (data.containsKey('display_name_en')) {
      context.handle(
          _displayNameEnMeta,
          displayNameEn.isAcceptableOrUnknown(
              data['display_name_en']!, _displayNameEnMeta));
    } else if (isInserting) {
      context.missing(_displayNameEnMeta);
    }
    if (data.containsKey('excluded_ingredients_json')) {
      context.handle(
          _excludedIngredientsJsonMeta,
          excludedIngredientsJson.isAcceptableOrUnknown(
              data['excluded_ingredients_json']!,
              _excludedIngredientsJsonMeta));
    }
    if (data.containsKey('excluded_risk_tags_json')) {
      context.handle(
          _excludedRiskTagsJsonMeta,
          excludedRiskTagsJson.isAcceptableOrUnknown(
              data['excluded_risk_tags_json']!, _excludedRiskTagsJsonMeta));
    }
    if (data.containsKey('severity')) {
      context.handle(_severityMeta,
          severity.isAcceptableOrUnknown(data['severity']!, _severityMeta));
    }
    if (data.containsKey('warning_text_de')) {
      context.handle(
          _warningTextDeMeta,
          warningTextDe.isAcceptableOrUnknown(
              data['warning_text_de']!, _warningTextDeMeta));
    }
    if (data.containsKey('warning_text_en')) {
      context.handle(
          _warningTextEnMeta,
          warningTextEn.isAcceptableOrUnknown(
              data['warning_text_en']!, _warningTextEnMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contraindication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contraindication(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      displayNameDe: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}display_name_de'])!,
      displayNameEn: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}display_name_en'])!,
      excludedIngredientsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}excluded_ingredients_json'])!,
      excludedRiskTagsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}excluded_risk_tags_json'])!,
      severity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}severity'])!,
      warningTextDe: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}warning_text_de']),
      warningTextEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}warning_text_en']),
    );
  }

  @override
  $ContraindicationsTable createAlias(String alias) {
    return $ContraindicationsTable(attachedDatabase, alias);
  }
}

class Contraindication extends DataClass
    implements Insertable<Contraindication> {
  final int id;
  final String type;
  final String code;
  final String displayNameDe;
  final String displayNameEn;
  final String excludedIngredientsJson;
  final String excludedRiskTagsJson;
  final String severity;
  final String? warningTextDe;
  final String? warningTextEn;
  const Contraindication(
      {required this.id,
      required this.type,
      required this.code,
      required this.displayNameDe,
      required this.displayNameEn,
      required this.excludedIngredientsJson,
      required this.excludedRiskTagsJson,
      required this.severity,
      this.warningTextDe,
      this.warningTextEn});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['code'] = Variable<String>(code);
    map['display_name_de'] = Variable<String>(displayNameDe);
    map['display_name_en'] = Variable<String>(displayNameEn);
    map['excluded_ingredients_json'] =
        Variable<String>(excludedIngredientsJson);
    map['excluded_risk_tags_json'] = Variable<String>(excludedRiskTagsJson);
    map['severity'] = Variable<String>(severity);
    if (!nullToAbsent || warningTextDe != null) {
      map['warning_text_de'] = Variable<String>(warningTextDe);
    }
    if (!nullToAbsent || warningTextEn != null) {
      map['warning_text_en'] = Variable<String>(warningTextEn);
    }
    return map;
  }

  ContraindicationsCompanion toCompanion(bool nullToAbsent) {
    return ContraindicationsCompanion(
      id: Value(id),
      type: Value(type),
      code: Value(code),
      displayNameDe: Value(displayNameDe),
      displayNameEn: Value(displayNameEn),
      excludedIngredientsJson: Value(excludedIngredientsJson),
      excludedRiskTagsJson: Value(excludedRiskTagsJson),
      severity: Value(severity),
      warningTextDe: warningTextDe == null && nullToAbsent
          ? const Value.absent()
          : Value(warningTextDe),
      warningTextEn: warningTextEn == null && nullToAbsent
          ? const Value.absent()
          : Value(warningTextEn),
    );
  }

  factory Contraindication.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contraindication(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      code: serializer.fromJson<String>(json['code']),
      displayNameDe: serializer.fromJson<String>(json['displayNameDe']),
      displayNameEn: serializer.fromJson<String>(json['displayNameEn']),
      excludedIngredientsJson:
          serializer.fromJson<String>(json['excludedIngredientsJson']),
      excludedRiskTagsJson:
          serializer.fromJson<String>(json['excludedRiskTagsJson']),
      severity: serializer.fromJson<String>(json['severity']),
      warningTextDe: serializer.fromJson<String?>(json['warningTextDe']),
      warningTextEn: serializer.fromJson<String?>(json['warningTextEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'code': serializer.toJson<String>(code),
      'displayNameDe': serializer.toJson<String>(displayNameDe),
      'displayNameEn': serializer.toJson<String>(displayNameEn),
      'excludedIngredientsJson':
          serializer.toJson<String>(excludedIngredientsJson),
      'excludedRiskTagsJson': serializer.toJson<String>(excludedRiskTagsJson),
      'severity': serializer.toJson<String>(severity),
      'warningTextDe': serializer.toJson<String?>(warningTextDe),
      'warningTextEn': serializer.toJson<String?>(warningTextEn),
    };
  }

  Contraindication copyWith(
          {int? id,
          String? type,
          String? code,
          String? displayNameDe,
          String? displayNameEn,
          String? excludedIngredientsJson,
          String? excludedRiskTagsJson,
          String? severity,
          Value<String?> warningTextDe = const Value.absent(),
          Value<String?> warningTextEn = const Value.absent()}) =>
      Contraindication(
        id: id ?? this.id,
        type: type ?? this.type,
        code: code ?? this.code,
        displayNameDe: displayNameDe ?? this.displayNameDe,
        displayNameEn: displayNameEn ?? this.displayNameEn,
        excludedIngredientsJson:
            excludedIngredientsJson ?? this.excludedIngredientsJson,
        excludedRiskTagsJson: excludedRiskTagsJson ?? this.excludedRiskTagsJson,
        severity: severity ?? this.severity,
        warningTextDe:
            warningTextDe.present ? warningTextDe.value : this.warningTextDe,
        warningTextEn:
            warningTextEn.present ? warningTextEn.value : this.warningTextEn,
      );
  Contraindication copyWithCompanion(ContraindicationsCompanion data) {
    return Contraindication(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      code: data.code.present ? data.code.value : this.code,
      displayNameDe: data.displayNameDe.present
          ? data.displayNameDe.value
          : this.displayNameDe,
      displayNameEn: data.displayNameEn.present
          ? data.displayNameEn.value
          : this.displayNameEn,
      excludedIngredientsJson: data.excludedIngredientsJson.present
          ? data.excludedIngredientsJson.value
          : this.excludedIngredientsJson,
      excludedRiskTagsJson: data.excludedRiskTagsJson.present
          ? data.excludedRiskTagsJson.value
          : this.excludedRiskTagsJson,
      severity: data.severity.present ? data.severity.value : this.severity,
      warningTextDe: data.warningTextDe.present
          ? data.warningTextDe.value
          : this.warningTextDe,
      warningTextEn: data.warningTextEn.present
          ? data.warningTextEn.value
          : this.warningTextEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Contraindication(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('code: $code, ')
          ..write('displayNameDe: $displayNameDe, ')
          ..write('displayNameEn: $displayNameEn, ')
          ..write('excludedIngredientsJson: $excludedIngredientsJson, ')
          ..write('excludedRiskTagsJson: $excludedRiskTagsJson, ')
          ..write('severity: $severity, ')
          ..write('warningTextDe: $warningTextDe, ')
          ..write('warningTextEn: $warningTextEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      type,
      code,
      displayNameDe,
      displayNameEn,
      excludedIngredientsJson,
      excludedRiskTagsJson,
      severity,
      warningTextDe,
      warningTextEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contraindication &&
          other.id == this.id &&
          other.type == this.type &&
          other.code == this.code &&
          other.displayNameDe == this.displayNameDe &&
          other.displayNameEn == this.displayNameEn &&
          other.excludedIngredientsJson == this.excludedIngredientsJson &&
          other.excludedRiskTagsJson == this.excludedRiskTagsJson &&
          other.severity == this.severity &&
          other.warningTextDe == this.warningTextDe &&
          other.warningTextEn == this.warningTextEn);
}

class ContraindicationsCompanion extends UpdateCompanion<Contraindication> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> code;
  final Value<String> displayNameDe;
  final Value<String> displayNameEn;
  final Value<String> excludedIngredientsJson;
  final Value<String> excludedRiskTagsJson;
  final Value<String> severity;
  final Value<String?> warningTextDe;
  final Value<String?> warningTextEn;
  const ContraindicationsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.code = const Value.absent(),
    this.displayNameDe = const Value.absent(),
    this.displayNameEn = const Value.absent(),
    this.excludedIngredientsJson = const Value.absent(),
    this.excludedRiskTagsJson = const Value.absent(),
    this.severity = const Value.absent(),
    this.warningTextDe = const Value.absent(),
    this.warningTextEn = const Value.absent(),
  });
  ContraindicationsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String code,
    required String displayNameDe,
    required String displayNameEn,
    this.excludedIngredientsJson = const Value.absent(),
    this.excludedRiskTagsJson = const Value.absent(),
    this.severity = const Value.absent(),
    this.warningTextDe = const Value.absent(),
    this.warningTextEn = const Value.absent(),
  })  : type = Value(type),
        code = Value(code),
        displayNameDe = Value(displayNameDe),
        displayNameEn = Value(displayNameEn);
  static Insertable<Contraindication> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? code,
    Expression<String>? displayNameDe,
    Expression<String>? displayNameEn,
    Expression<String>? excludedIngredientsJson,
    Expression<String>? excludedRiskTagsJson,
    Expression<String>? severity,
    Expression<String>? warningTextDe,
    Expression<String>? warningTextEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (code != null) 'code': code,
      if (displayNameDe != null) 'display_name_de': displayNameDe,
      if (displayNameEn != null) 'display_name_en': displayNameEn,
      if (excludedIngredientsJson != null)
        'excluded_ingredients_json': excludedIngredientsJson,
      if (excludedRiskTagsJson != null)
        'excluded_risk_tags_json': excludedRiskTagsJson,
      if (severity != null) 'severity': severity,
      if (warningTextDe != null) 'warning_text_de': warningTextDe,
      if (warningTextEn != null) 'warning_text_en': warningTextEn,
    });
  }

  ContraindicationsCompanion copyWith(
      {Value<int>? id,
      Value<String>? type,
      Value<String>? code,
      Value<String>? displayNameDe,
      Value<String>? displayNameEn,
      Value<String>? excludedIngredientsJson,
      Value<String>? excludedRiskTagsJson,
      Value<String>? severity,
      Value<String?>? warningTextDe,
      Value<String?>? warningTextEn}) {
    return ContraindicationsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      code: code ?? this.code,
      displayNameDe: displayNameDe ?? this.displayNameDe,
      displayNameEn: displayNameEn ?? this.displayNameEn,
      excludedIngredientsJson:
          excludedIngredientsJson ?? this.excludedIngredientsJson,
      excludedRiskTagsJson: excludedRiskTagsJson ?? this.excludedRiskTagsJson,
      severity: severity ?? this.severity,
      warningTextDe: warningTextDe ?? this.warningTextDe,
      warningTextEn: warningTextEn ?? this.warningTextEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (displayNameDe.present) {
      map['display_name_de'] = Variable<String>(displayNameDe.value);
    }
    if (displayNameEn.present) {
      map['display_name_en'] = Variable<String>(displayNameEn.value);
    }
    if (excludedIngredientsJson.present) {
      map['excluded_ingredients_json'] =
          Variable<String>(excludedIngredientsJson.value);
    }
    if (excludedRiskTagsJson.present) {
      map['excluded_risk_tags_json'] =
          Variable<String>(excludedRiskTagsJson.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (warningTextDe.present) {
      map['warning_text_de'] = Variable<String>(warningTextDe.value);
    }
    if (warningTextEn.present) {
      map['warning_text_en'] = Variable<String>(warningTextEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContraindicationsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('code: $code, ')
          ..write('displayNameDe: $displayNameDe, ')
          ..write('displayNameEn: $displayNameEn, ')
          ..write('excludedIngredientsJson: $excludedIngredientsJson, ')
          ..write('excludedRiskTagsJson: $excludedRiskTagsJson, ')
          ..write('severity: $severity, ')
          ..write('warningTextDe: $warningTextDe, ')
          ..write('warningTextEn: $warningTextEn')
          ..write(')'))
        .toString();
  }
}

class $UserContraindicationsTable extends UserContraindications
    with TableInfo<$UserContraindicationsTable, UserContraindication> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserContraindicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _contraindicationIdMeta =
      const VerificationMeta('contraindicationId');
  @override
  late final GeneratedColumn<int> contraindicationId = GeneratedColumn<int>(
      'contraindication_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES contraindications (id) ON DELETE CASCADE'));
  static const VerificationMeta _severityOverrideMeta =
      const VerificationMeta('severityOverride');
  @override
  late final GeneratedColumn<String> severityOverride = GeneratedColumn<String>(
      'severity_override', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addedAtMeta =
      const VerificationMeta('addedAt');
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
      'added_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, contraindicationId, severityOverride, addedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_contraindications';
  @override
  VerificationContext validateIntegrity(
      Insertable<UserContraindication> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('contraindication_id')) {
      context.handle(
          _contraindicationIdMeta,
          contraindicationId.isAcceptableOrUnknown(
              data['contraindication_id']!, _contraindicationIdMeta));
    } else if (isInserting) {
      context.missing(_contraindicationIdMeta);
    }
    if (data.containsKey('severity_override')) {
      context.handle(
          _severityOverrideMeta,
          severityOverride.isAcceptableOrUnknown(
              data['severity_override']!, _severityOverrideMeta));
    }
    if (data.containsKey('added_at')) {
      context.handle(_addedAtMeta,
          addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta));
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserContraindication map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserContraindication(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      contraindicationId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}contraindication_id'])!,
      severityOverride: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}severity_override']),
      addedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added_at'])!,
    );
  }

  @override
  $UserContraindicationsTable createAlias(String alias) {
    return $UserContraindicationsTable(attachedDatabase, alias);
  }
}

class UserContraindication extends DataClass
    implements Insertable<UserContraindication> {
  final int id;
  final int contraindicationId;
  final String? severityOverride;
  final DateTime addedAt;
  const UserContraindication(
      {required this.id,
      required this.contraindicationId,
      this.severityOverride,
      required this.addedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['contraindication_id'] = Variable<int>(contraindicationId);
    if (!nullToAbsent || severityOverride != null) {
      map['severity_override'] = Variable<String>(severityOverride);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  UserContraindicationsCompanion toCompanion(bool nullToAbsent) {
    return UserContraindicationsCompanion(
      id: Value(id),
      contraindicationId: Value(contraindicationId),
      severityOverride: severityOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(severityOverride),
      addedAt: Value(addedAt),
    );
  }

  factory UserContraindication.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserContraindication(
      id: serializer.fromJson<int>(json['id']),
      contraindicationId: serializer.fromJson<int>(json['contraindicationId']),
      severityOverride: serializer.fromJson<String?>(json['severityOverride']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'contraindicationId': serializer.toJson<int>(contraindicationId),
      'severityOverride': serializer.toJson<String?>(severityOverride),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  UserContraindication copyWith(
          {int? id,
          int? contraindicationId,
          Value<String?> severityOverride = const Value.absent(),
          DateTime? addedAt}) =>
      UserContraindication(
        id: id ?? this.id,
        contraindicationId: contraindicationId ?? this.contraindicationId,
        severityOverride: severityOverride.present
            ? severityOverride.value
            : this.severityOverride,
        addedAt: addedAt ?? this.addedAt,
      );
  UserContraindication copyWithCompanion(UserContraindicationsCompanion data) {
    return UserContraindication(
      id: data.id.present ? data.id.value : this.id,
      contraindicationId: data.contraindicationId.present
          ? data.contraindicationId.value
          : this.contraindicationId,
      severityOverride: data.severityOverride.present
          ? data.severityOverride.value
          : this.severityOverride,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserContraindication(')
          ..write('id: $id, ')
          ..write('contraindicationId: $contraindicationId, ')
          ..write('severityOverride: $severityOverride, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, contraindicationId, severityOverride, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserContraindication &&
          other.id == this.id &&
          other.contraindicationId == this.contraindicationId &&
          other.severityOverride == this.severityOverride &&
          other.addedAt == this.addedAt);
}

class UserContraindicationsCompanion
    extends UpdateCompanion<UserContraindication> {
  final Value<int> id;
  final Value<int> contraindicationId;
  final Value<String?> severityOverride;
  final Value<DateTime> addedAt;
  const UserContraindicationsCompanion({
    this.id = const Value.absent(),
    this.contraindicationId = const Value.absent(),
    this.severityOverride = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  UserContraindicationsCompanion.insert({
    this.id = const Value.absent(),
    required int contraindicationId,
    this.severityOverride = const Value.absent(),
    required DateTime addedAt,
  })  : contraindicationId = Value(contraindicationId),
        addedAt = Value(addedAt);
  static Insertable<UserContraindication> custom({
    Expression<int>? id,
    Expression<int>? contraindicationId,
    Expression<String>? severityOverride,
    Expression<DateTime>? addedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (contraindicationId != null) 'contraindication_id': contraindicationId,
      if (severityOverride != null) 'severity_override': severityOverride,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  UserContraindicationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? contraindicationId,
      Value<String?>? severityOverride,
      Value<DateTime>? addedAt}) {
    return UserContraindicationsCompanion(
      id: id ?? this.id,
      contraindicationId: contraindicationId ?? this.contraindicationId,
      severityOverride: severityOverride ?? this.severityOverride,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (contraindicationId.present) {
      map['contraindication_id'] = Variable<int>(contraindicationId.value);
    }
    if (severityOverride.present) {
      map['severity_override'] = Variable<String>(severityOverride.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserContraindicationsCompanion(')
          ..write('id: $id, ')
          ..write('contraindicationId: $contraindicationId, ')
          ..write('severityOverride: $severityOverride, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

class $DiscountersTable extends Discounters
    with TableInfo<$DiscountersTable, Discounter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiscountersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _scraperClassMeta =
      const VerificationMeta('scraperClass');
  @override
  late final GeneratedColumn<String> scraperClass = GeneratedColumn<String>(
      'scraper_class', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _logoPathMeta =
      const VerificationMeta('logoPath');
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
      'logo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _apiTypeMeta =
      const VerificationMeta('apiType');
  @override
  late final GeneratedColumn<String> apiType = GeneratedColumn<String>(
      'api_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _apiBaseUrlMeta =
      const VerificationMeta('apiBaseUrl');
  @override
  late final GeneratedColumn<String> apiBaseUrl = GeneratedColumn<String>(
      'api_base_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _apiKeyEnvMeta =
      const VerificationMeta('apiKeyEnv');
  @override
  late final GeneratedColumn<String> apiKeyEnv = GeneratedColumn<String>(
      'api_key_env', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        scraperClass,
        enabled,
        logoPath,
        apiType,
        apiBaseUrl,
        apiKeyEnv
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'discounters';
  @override
  VerificationContext validateIntegrity(Insertable<Discounter> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('scraper_class')) {
      context.handle(
          _scraperClassMeta,
          scraperClass.isAcceptableOrUnknown(
              data['scraper_class']!, _scraperClassMeta));
    } else if (isInserting) {
      context.missing(_scraperClassMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('logo_path')) {
      context.handle(_logoPathMeta,
          logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta));
    }
    if (data.containsKey('api_type')) {
      context.handle(_apiTypeMeta,
          apiType.isAcceptableOrUnknown(data['api_type']!, _apiTypeMeta));
    }
    if (data.containsKey('api_base_url')) {
      context.handle(
          _apiBaseUrlMeta,
          apiBaseUrl.isAcceptableOrUnknown(
              data['api_base_url']!, _apiBaseUrlMeta));
    }
    if (data.containsKey('api_key_env')) {
      context.handle(
          _apiKeyEnvMeta,
          apiKeyEnv.isAcceptableOrUnknown(
              data['api_key_env']!, _apiKeyEnvMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Discounter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Discounter(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      scraperClass: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scraper_class'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      logoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_path']),
      apiType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}api_type']),
      apiBaseUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}api_base_url']),
      apiKeyEnv: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}api_key_env']),
    );
  }

  @override
  $DiscountersTable createAlias(String alias) {
    return $DiscountersTable(attachedDatabase, alias);
  }
}

class Discounter extends DataClass implements Insertable<Discounter> {
  final int id;
  final String name;
  final String scraperClass;
  final bool enabled;
  final String? logoPath;
  final String? apiType;
  final String? apiBaseUrl;
  final String? apiKeyEnv;
  const Discounter(
      {required this.id,
      required this.name,
      required this.scraperClass,
      required this.enabled,
      this.logoPath,
      this.apiType,
      this.apiBaseUrl,
      this.apiKeyEnv});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['scraper_class'] = Variable<String>(scraperClass);
    map['enabled'] = Variable<bool>(enabled);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    if (!nullToAbsent || apiType != null) {
      map['api_type'] = Variable<String>(apiType);
    }
    if (!nullToAbsent || apiBaseUrl != null) {
      map['api_base_url'] = Variable<String>(apiBaseUrl);
    }
    if (!nullToAbsent || apiKeyEnv != null) {
      map['api_key_env'] = Variable<String>(apiKeyEnv);
    }
    return map;
  }

  DiscountersCompanion toCompanion(bool nullToAbsent) {
    return DiscountersCompanion(
      id: Value(id),
      name: Value(name),
      scraperClass: Value(scraperClass),
      enabled: Value(enabled),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      apiType: apiType == null && nullToAbsent
          ? const Value.absent()
          : Value(apiType),
      apiBaseUrl: apiBaseUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(apiBaseUrl),
      apiKeyEnv: apiKeyEnv == null && nullToAbsent
          ? const Value.absent()
          : Value(apiKeyEnv),
    );
  }

  factory Discounter.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Discounter(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      scraperClass: serializer.fromJson<String>(json['scraperClass']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      apiType: serializer.fromJson<String?>(json['apiType']),
      apiBaseUrl: serializer.fromJson<String?>(json['apiBaseUrl']),
      apiKeyEnv: serializer.fromJson<String?>(json['apiKeyEnv']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'scraperClass': serializer.toJson<String>(scraperClass),
      'enabled': serializer.toJson<bool>(enabled),
      'logoPath': serializer.toJson<String?>(logoPath),
      'apiType': serializer.toJson<String?>(apiType),
      'apiBaseUrl': serializer.toJson<String?>(apiBaseUrl),
      'apiKeyEnv': serializer.toJson<String?>(apiKeyEnv),
    };
  }

  Discounter copyWith(
          {int? id,
          String? name,
          String? scraperClass,
          bool? enabled,
          Value<String?> logoPath = const Value.absent(),
          Value<String?> apiType = const Value.absent(),
          Value<String?> apiBaseUrl = const Value.absent(),
          Value<String?> apiKeyEnv = const Value.absent()}) =>
      Discounter(
        id: id ?? this.id,
        name: name ?? this.name,
        scraperClass: scraperClass ?? this.scraperClass,
        enabled: enabled ?? this.enabled,
        logoPath: logoPath.present ? logoPath.value : this.logoPath,
        apiType: apiType.present ? apiType.value : this.apiType,
        apiBaseUrl: apiBaseUrl.present ? apiBaseUrl.value : this.apiBaseUrl,
        apiKeyEnv: apiKeyEnv.present ? apiKeyEnv.value : this.apiKeyEnv,
      );
  Discounter copyWithCompanion(DiscountersCompanion data) {
    return Discounter(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      scraperClass: data.scraperClass.present
          ? data.scraperClass.value
          : this.scraperClass,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      apiType: data.apiType.present ? data.apiType.value : this.apiType,
      apiBaseUrl:
          data.apiBaseUrl.present ? data.apiBaseUrl.value : this.apiBaseUrl,
      apiKeyEnv: data.apiKeyEnv.present ? data.apiKeyEnv.value : this.apiKeyEnv,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Discounter(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('scraperClass: $scraperClass, ')
          ..write('enabled: $enabled, ')
          ..write('logoPath: $logoPath, ')
          ..write('apiType: $apiType, ')
          ..write('apiBaseUrl: $apiBaseUrl, ')
          ..write('apiKeyEnv: $apiKeyEnv')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, scraperClass, enabled, logoPath,
      apiType, apiBaseUrl, apiKeyEnv);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Discounter &&
          other.id == this.id &&
          other.name == this.name &&
          other.scraperClass == this.scraperClass &&
          other.enabled == this.enabled &&
          other.logoPath == this.logoPath &&
          other.apiType == this.apiType &&
          other.apiBaseUrl == this.apiBaseUrl &&
          other.apiKeyEnv == this.apiKeyEnv);
}

class DiscountersCompanion extends UpdateCompanion<Discounter> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> scraperClass;
  final Value<bool> enabled;
  final Value<String?> logoPath;
  final Value<String?> apiType;
  final Value<String?> apiBaseUrl;
  final Value<String?> apiKeyEnv;
  const DiscountersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.scraperClass = const Value.absent(),
    this.enabled = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.apiType = const Value.absent(),
    this.apiBaseUrl = const Value.absent(),
    this.apiKeyEnv = const Value.absent(),
  });
  DiscountersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String scraperClass,
    this.enabled = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.apiType = const Value.absent(),
    this.apiBaseUrl = const Value.absent(),
    this.apiKeyEnv = const Value.absent(),
  })  : name = Value(name),
        scraperClass = Value(scraperClass);
  static Insertable<Discounter> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? scraperClass,
    Expression<bool>? enabled,
    Expression<String>? logoPath,
    Expression<String>? apiType,
    Expression<String>? apiBaseUrl,
    Expression<String>? apiKeyEnv,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (scraperClass != null) 'scraper_class': scraperClass,
      if (enabled != null) 'enabled': enabled,
      if (logoPath != null) 'logo_path': logoPath,
      if (apiType != null) 'api_type': apiType,
      if (apiBaseUrl != null) 'api_base_url': apiBaseUrl,
      if (apiKeyEnv != null) 'api_key_env': apiKeyEnv,
    });
  }

  DiscountersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? scraperClass,
      Value<bool>? enabled,
      Value<String?>? logoPath,
      Value<String?>? apiType,
      Value<String?>? apiBaseUrl,
      Value<String?>? apiKeyEnv}) {
    return DiscountersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      scraperClass: scraperClass ?? this.scraperClass,
      enabled: enabled ?? this.enabled,
      logoPath: logoPath ?? this.logoPath,
      apiType: apiType ?? this.apiType,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      apiKeyEnv: apiKeyEnv ?? this.apiKeyEnv,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (scraperClass.present) {
      map['scraper_class'] = Variable<String>(scraperClass.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (apiType.present) {
      map['api_type'] = Variable<String>(apiType.value);
    }
    if (apiBaseUrl.present) {
      map['api_base_url'] = Variable<String>(apiBaseUrl.value);
    }
    if (apiKeyEnv.present) {
      map['api_key_env'] = Variable<String>(apiKeyEnv.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiscountersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('scraperClass: $scraperClass, ')
          ..write('enabled: $enabled, ')
          ..write('logoPath: $logoPath, ')
          ..write('apiType: $apiType, ')
          ..write('apiBaseUrl: $apiBaseUrl, ')
          ..write('apiKeyEnv: $apiKeyEnv')
          ..write(')'))
        .toString();
  }
}

class $OffersTable extends Offers with TableInfo<$OffersTable, Offer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OffersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _discounterIdMeta =
      const VerificationMeta('discounterId');
  @override
  late final GeneratedColumn<int> discounterId = GeneratedColumn<int>(
      'discounter_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES discounters (id) ON DELETE CASCADE'));
  static const VerificationMeta _ingredientIdMeta =
      const VerificationMeta('ingredientId');
  @override
  late final GeneratedColumn<int> ingredientId = GeneratedColumn<int>(
      'ingredient_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES ingredients (id) ON DELETE SET NULL'));
  static const VerificationMeta _rawNameMeta =
      const VerificationMeta('rawName');
  @override
  late final GeneratedColumn<String> rawName = GeneratedColumn<String>(
      'raw_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitTextMeta =
      const VerificationMeta('unitText');
  @override
  late final GeneratedColumn<String> unitText = GeneratedColumn<String>(
      'unit_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _validFromMeta =
      const VerificationMeta('validFrom');
  @override
  late final GeneratedColumn<DateTime> validFrom = GeneratedColumn<DateTime>(
      'valid_from', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _validToMeta =
      const VerificationMeta('validTo');
  @override
  late final GeneratedColumn<DateTime> validTo = GeneratedColumn<DateTime>(
      'valid_to', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _fetchedAtMeta =
      const VerificationMeta('fetchedAt');
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
      'fetched_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sourceUrlMeta =
      const VerificationMeta('sourceUrl');
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
      'source_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        discounterId,
        ingredientId,
        rawName,
        price,
        unitText,
        validFrom,
        validTo,
        fetchedAt,
        sourceUrl
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offers';
  @override
  VerificationContext validateIntegrity(Insertable<Offer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('discounter_id')) {
      context.handle(
          _discounterIdMeta,
          discounterId.isAcceptableOrUnknown(
              data['discounter_id']!, _discounterIdMeta));
    } else if (isInserting) {
      context.missing(_discounterIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
          _ingredientIdMeta,
          ingredientId.isAcceptableOrUnknown(
              data['ingredient_id']!, _ingredientIdMeta));
    }
    if (data.containsKey('raw_name')) {
      context.handle(_rawNameMeta,
          rawName.isAcceptableOrUnknown(data['raw_name']!, _rawNameMeta));
    } else if (isInserting) {
      context.missing(_rawNameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('unit_text')) {
      context.handle(_unitTextMeta,
          unitText.isAcceptableOrUnknown(data['unit_text']!, _unitTextMeta));
    }
    if (data.containsKey('valid_from')) {
      context.handle(_validFromMeta,
          validFrom.isAcceptableOrUnknown(data['valid_from']!, _validFromMeta));
    } else if (isInserting) {
      context.missing(_validFromMeta);
    }
    if (data.containsKey('valid_to')) {
      context.handle(_validToMeta,
          validTo.isAcceptableOrUnknown(data['valid_to']!, _validToMeta));
    } else if (isInserting) {
      context.missing(_validToMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(_fetchedAtMeta,
          fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta));
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('source_url')) {
      context.handle(_sourceUrlMeta,
          sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Offer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Offer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      discounterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discounter_id'])!,
      ingredientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ingredient_id']),
      rawName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}raw_name'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      unitText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_text']),
      validFrom: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}valid_from'])!,
      validTo: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}valid_to'])!,
      fetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fetched_at'])!,
      sourceUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_url']),
    );
  }

  @override
  $OffersTable createAlias(String alias) {
    return $OffersTable(attachedDatabase, alias);
  }
}

class Offer extends DataClass implements Insertable<Offer> {
  final int id;
  final int discounterId;
  final int? ingredientId;
  final String rawName;
  final double price;
  final String? unitText;
  final DateTime validFrom;
  final DateTime validTo;
  final DateTime fetchedAt;
  final String? sourceUrl;
  const Offer(
      {required this.id,
      required this.discounterId,
      this.ingredientId,
      required this.rawName,
      required this.price,
      this.unitText,
      required this.validFrom,
      required this.validTo,
      required this.fetchedAt,
      this.sourceUrl});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['discounter_id'] = Variable<int>(discounterId);
    if (!nullToAbsent || ingredientId != null) {
      map['ingredient_id'] = Variable<int>(ingredientId);
    }
    map['raw_name'] = Variable<String>(rawName);
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || unitText != null) {
      map['unit_text'] = Variable<String>(unitText);
    }
    map['valid_from'] = Variable<DateTime>(validFrom);
    map['valid_to'] = Variable<DateTime>(validTo);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    return map;
  }

  OffersCompanion toCompanion(bool nullToAbsent) {
    return OffersCompanion(
      id: Value(id),
      discounterId: Value(discounterId),
      ingredientId: ingredientId == null && nullToAbsent
          ? const Value.absent()
          : Value(ingredientId),
      rawName: Value(rawName),
      price: Value(price),
      unitText: unitText == null && nullToAbsent
          ? const Value.absent()
          : Value(unitText),
      validFrom: Value(validFrom),
      validTo: Value(validTo),
      fetchedAt: Value(fetchedAt),
      sourceUrl: sourceUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUrl),
    );
  }

  factory Offer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Offer(
      id: serializer.fromJson<int>(json['id']),
      discounterId: serializer.fromJson<int>(json['discounterId']),
      ingredientId: serializer.fromJson<int?>(json['ingredientId']),
      rawName: serializer.fromJson<String>(json['rawName']),
      price: serializer.fromJson<double>(json['price']),
      unitText: serializer.fromJson<String?>(json['unitText']),
      validFrom: serializer.fromJson<DateTime>(json['validFrom']),
      validTo: serializer.fromJson<DateTime>(json['validTo']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'discounterId': serializer.toJson<int>(discounterId),
      'ingredientId': serializer.toJson<int?>(ingredientId),
      'rawName': serializer.toJson<String>(rawName),
      'price': serializer.toJson<double>(price),
      'unitText': serializer.toJson<String?>(unitText),
      'validFrom': serializer.toJson<DateTime>(validFrom),
      'validTo': serializer.toJson<DateTime>(validTo),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
    };
  }

  Offer copyWith(
          {int? id,
          int? discounterId,
          Value<int?> ingredientId = const Value.absent(),
          String? rawName,
          double? price,
          Value<String?> unitText = const Value.absent(),
          DateTime? validFrom,
          DateTime? validTo,
          DateTime? fetchedAt,
          Value<String?> sourceUrl = const Value.absent()}) =>
      Offer(
        id: id ?? this.id,
        discounterId: discounterId ?? this.discounterId,
        ingredientId:
            ingredientId.present ? ingredientId.value : this.ingredientId,
        rawName: rawName ?? this.rawName,
        price: price ?? this.price,
        unitText: unitText.present ? unitText.value : this.unitText,
        validFrom: validFrom ?? this.validFrom,
        validTo: validTo ?? this.validTo,
        fetchedAt: fetchedAt ?? this.fetchedAt,
        sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
      );
  Offer copyWithCompanion(OffersCompanion data) {
    return Offer(
      id: data.id.present ? data.id.value : this.id,
      discounterId: data.discounterId.present
          ? data.discounterId.value
          : this.discounterId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      rawName: data.rawName.present ? data.rawName.value : this.rawName,
      price: data.price.present ? data.price.value : this.price,
      unitText: data.unitText.present ? data.unitText.value : this.unitText,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      validTo: data.validTo.present ? data.validTo.value : this.validTo,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Offer(')
          ..write('id: $id, ')
          ..write('discounterId: $discounterId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('rawName: $rawName, ')
          ..write('price: $price, ')
          ..write('unitText: $unitText, ')
          ..write('validFrom: $validFrom, ')
          ..write('validTo: $validTo, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('sourceUrl: $sourceUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, discounterId, ingredientId, rawName,
      price, unitText, validFrom, validTo, fetchedAt, sourceUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Offer &&
          other.id == this.id &&
          other.discounterId == this.discounterId &&
          other.ingredientId == this.ingredientId &&
          other.rawName == this.rawName &&
          other.price == this.price &&
          other.unitText == this.unitText &&
          other.validFrom == this.validFrom &&
          other.validTo == this.validTo &&
          other.fetchedAt == this.fetchedAt &&
          other.sourceUrl == this.sourceUrl);
}

class OffersCompanion extends UpdateCompanion<Offer> {
  final Value<int> id;
  final Value<int> discounterId;
  final Value<int?> ingredientId;
  final Value<String> rawName;
  final Value<double> price;
  final Value<String?> unitText;
  final Value<DateTime> validFrom;
  final Value<DateTime> validTo;
  final Value<DateTime> fetchedAt;
  final Value<String?> sourceUrl;
  const OffersCompanion({
    this.id = const Value.absent(),
    this.discounterId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.rawName = const Value.absent(),
    this.price = const Value.absent(),
    this.unitText = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validTo = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.sourceUrl = const Value.absent(),
  });
  OffersCompanion.insert({
    this.id = const Value.absent(),
    required int discounterId,
    this.ingredientId = const Value.absent(),
    required String rawName,
    required double price,
    this.unitText = const Value.absent(),
    required DateTime validFrom,
    required DateTime validTo,
    required DateTime fetchedAt,
    this.sourceUrl = const Value.absent(),
  })  : discounterId = Value(discounterId),
        rawName = Value(rawName),
        price = Value(price),
        validFrom = Value(validFrom),
        validTo = Value(validTo),
        fetchedAt = Value(fetchedAt);
  static Insertable<Offer> custom({
    Expression<int>? id,
    Expression<int>? discounterId,
    Expression<int>? ingredientId,
    Expression<String>? rawName,
    Expression<double>? price,
    Expression<String>? unitText,
    Expression<DateTime>? validFrom,
    Expression<DateTime>? validTo,
    Expression<DateTime>? fetchedAt,
    Expression<String>? sourceUrl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (discounterId != null) 'discounter_id': discounterId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (rawName != null) 'raw_name': rawName,
      if (price != null) 'price': price,
      if (unitText != null) 'unit_text': unitText,
      if (validFrom != null) 'valid_from': validFrom,
      if (validTo != null) 'valid_to': validTo,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (sourceUrl != null) 'source_url': sourceUrl,
    });
  }

  OffersCompanion copyWith(
      {Value<int>? id,
      Value<int>? discounterId,
      Value<int?>? ingredientId,
      Value<String>? rawName,
      Value<double>? price,
      Value<String?>? unitText,
      Value<DateTime>? validFrom,
      Value<DateTime>? validTo,
      Value<DateTime>? fetchedAt,
      Value<String?>? sourceUrl}) {
    return OffersCompanion(
      id: id ?? this.id,
      discounterId: discounterId ?? this.discounterId,
      ingredientId: ingredientId ?? this.ingredientId,
      rawName: rawName ?? this.rawName,
      price: price ?? this.price,
      unitText: unitText ?? this.unitText,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      sourceUrl: sourceUrl ?? this.sourceUrl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (discounterId.present) {
      map['discounter_id'] = Variable<int>(discounterId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<int>(ingredientId.value);
    }
    if (rawName.present) {
      map['raw_name'] = Variable<String>(rawName.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (unitText.present) {
      map['unit_text'] = Variable<String>(unitText.value);
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<DateTime>(validFrom.value);
    }
    if (validTo.present) {
      map['valid_to'] = Variable<DateTime>(validTo.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OffersCompanion(')
          ..write('id: $id, ')
          ..write('discounterId: $discounterId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('rawName: $rawName, ')
          ..write('price: $price, ')
          ..write('unitText: $unitText, ')
          ..write('validFrom: $validFrom, ')
          ..write('validTo: $validTo, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('sourceUrl: $sourceUrl')
          ..write(')'))
        .toString();
  }
}

class $WeeklyPlansTable extends WeeklyPlans
    with TableInfo<$WeeklyPlansTable, WeeklyPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _weekStartMeta =
      const VerificationMeta('weekStart');
  @override
  late final GeneratedColumn<DateTime> weekStart = GeneratedColumn<DateTime>(
      'week_start', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _personsMeta =
      const VerificationMeta('persons');
  @override
  late final GeneratedColumn<int> persons = GeneratedColumn<int>(
      'persons', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(2));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('draft'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, weekStart, persons, status, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_plans';
  @override
  VerificationContext validateIntegrity(Insertable<WeeklyPlan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('week_start')) {
      context.handle(_weekStartMeta,
          weekStart.isAcceptableOrUnknown(data['week_start']!, _weekStartMeta));
    } else if (isInserting) {
      context.missing(_weekStartMeta);
    }
    if (data.containsKey('persons')) {
      context.handle(_personsMeta,
          persons.isAcceptableOrUnknown(data['persons']!, _personsMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeeklyPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyPlan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      weekStart: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}week_start'])!,
      persons: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}persons'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $WeeklyPlansTable createAlias(String alias) {
    return $WeeklyPlansTable(attachedDatabase, alias);
  }
}

class WeeklyPlan extends DataClass implements Insertable<WeeklyPlan> {
  final int id;
  final DateTime weekStart;
  final int persons;
  final String status;
  final DateTime createdAt;
  const WeeklyPlan(
      {required this.id,
      required this.weekStart,
      required this.persons,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['week_start'] = Variable<DateTime>(weekStart);
    map['persons'] = Variable<int>(persons);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WeeklyPlansCompanion toCompanion(bool nullToAbsent) {
    return WeeklyPlansCompanion(
      id: Value(id),
      weekStart: Value(weekStart),
      persons: Value(persons),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory WeeklyPlan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyPlan(
      id: serializer.fromJson<int>(json['id']),
      weekStart: serializer.fromJson<DateTime>(json['weekStart']),
      persons: serializer.fromJson<int>(json['persons']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weekStart': serializer.toJson<DateTime>(weekStart),
      'persons': serializer.toJson<int>(persons),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WeeklyPlan copyWith(
          {int? id,
          DateTime? weekStart,
          int? persons,
          String? status,
          DateTime? createdAt}) =>
      WeeklyPlan(
        id: id ?? this.id,
        weekStart: weekStart ?? this.weekStart,
        persons: persons ?? this.persons,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  WeeklyPlan copyWithCompanion(WeeklyPlansCompanion data) {
    return WeeklyPlan(
      id: data.id.present ? data.id.value : this.id,
      weekStart: data.weekStart.present ? data.weekStart.value : this.weekStart,
      persons: data.persons.present ? data.persons.value : this.persons,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyPlan(')
          ..write('id: $id, ')
          ..write('weekStart: $weekStart, ')
          ..write('persons: $persons, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, weekStart, persons, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyPlan &&
          other.id == this.id &&
          other.weekStart == this.weekStart &&
          other.persons == this.persons &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class WeeklyPlansCompanion extends UpdateCompanion<WeeklyPlan> {
  final Value<int> id;
  final Value<DateTime> weekStart;
  final Value<int> persons;
  final Value<String> status;
  final Value<DateTime> createdAt;
  const WeeklyPlansCompanion({
    this.id = const Value.absent(),
    this.weekStart = const Value.absent(),
    this.persons = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WeeklyPlansCompanion.insert({
    this.id = const Value.absent(),
    required DateTime weekStart,
    this.persons = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime createdAt,
  })  : weekStart = Value(weekStart),
        createdAt = Value(createdAt);
  static Insertable<WeeklyPlan> custom({
    Expression<int>? id,
    Expression<DateTime>? weekStart,
    Expression<int>? persons,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weekStart != null) 'week_start': weekStart,
      if (persons != null) 'persons': persons,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WeeklyPlansCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? weekStart,
      Value<int>? persons,
      Value<String>? status,
      Value<DateTime>? createdAt}) {
    return WeeklyPlansCompanion(
      id: id ?? this.id,
      weekStart: weekStart ?? this.weekStart,
      persons: persons ?? this.persons,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weekStart.present) {
      map['week_start'] = Variable<DateTime>(weekStart.value);
    }
    if (persons.present) {
      map['persons'] = Variable<int>(persons.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyPlansCompanion(')
          ..write('id: $id, ')
          ..write('weekStart: $weekStart, ')
          ..write('persons: $persons, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PlanMealsTable extends PlanMeals
    with TableInfo<$PlanMealsTable, PlanMeal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanMealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
      'plan_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES weekly_plans (id) ON DELETE CASCADE'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _mealTypeMeta =
      const VerificationMeta('mealType');
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
      'meal_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
      'recipe_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES recipes (id) ON DELETE SET NULL'));
  static const VerificationMeta _customNameMeta =
      const VerificationMeta('customName');
  @override
  late final GeneratedColumn<String> customName = GeneratedColumn<String>(
      'custom_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _servesMeta = const VerificationMeta('serves');
  @override
  late final GeneratedColumn<int> serves = GeneratedColumn<int>(
      'serves', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns =>
      [id, planId, date, mealType, recipeId, customName, serves];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_meals';
  @override
  VerificationContext validateIntegrity(Insertable<PlanMeal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_id')) {
      context.handle(_planIdMeta,
          planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta));
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(_mealTypeMeta,
          mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta));
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    }
    if (data.containsKey('custom_name')) {
      context.handle(
          _customNameMeta,
          customName.isAcceptableOrUnknown(
              data['custom_name']!, _customNameMeta));
    }
    if (data.containsKey('serves')) {
      context.handle(_servesMeta,
          serves.isAcceptableOrUnknown(data['serves']!, _servesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanMeal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanMeal(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      planId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plan_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      mealType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meal_type'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recipe_id']),
      customName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_name']),
      serves: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}serves'])!,
    );
  }

  @override
  $PlanMealsTable createAlias(String alias) {
    return $PlanMealsTable(attachedDatabase, alias);
  }
}

class PlanMeal extends DataClass implements Insertable<PlanMeal> {
  final int id;
  final int planId;
  final DateTime date;
  final String mealType;
  final int? recipeId;
  final String? customName;
  final int serves;
  const PlanMeal(
      {required this.id,
      required this.planId,
      required this.date,
      required this.mealType,
      this.recipeId,
      this.customName,
      required this.serves});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_id'] = Variable<int>(planId);
    map['date'] = Variable<DateTime>(date);
    map['meal_type'] = Variable<String>(mealType);
    if (!nullToAbsent || recipeId != null) {
      map['recipe_id'] = Variable<int>(recipeId);
    }
    if (!nullToAbsent || customName != null) {
      map['custom_name'] = Variable<String>(customName);
    }
    map['serves'] = Variable<int>(serves);
    return map;
  }

  PlanMealsCompanion toCompanion(bool nullToAbsent) {
    return PlanMealsCompanion(
      id: Value(id),
      planId: Value(planId),
      date: Value(date),
      mealType: Value(mealType),
      recipeId: recipeId == null && nullToAbsent
          ? const Value.absent()
          : Value(recipeId),
      customName: customName == null && nullToAbsent
          ? const Value.absent()
          : Value(customName),
      serves: Value(serves),
    );
  }

  factory PlanMeal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanMeal(
      id: serializer.fromJson<int>(json['id']),
      planId: serializer.fromJson<int>(json['planId']),
      date: serializer.fromJson<DateTime>(json['date']),
      mealType: serializer.fromJson<String>(json['mealType']),
      recipeId: serializer.fromJson<int?>(json['recipeId']),
      customName: serializer.fromJson<String?>(json['customName']),
      serves: serializer.fromJson<int>(json['serves']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planId': serializer.toJson<int>(planId),
      'date': serializer.toJson<DateTime>(date),
      'mealType': serializer.toJson<String>(mealType),
      'recipeId': serializer.toJson<int?>(recipeId),
      'customName': serializer.toJson<String?>(customName),
      'serves': serializer.toJson<int>(serves),
    };
  }

  PlanMeal copyWith(
          {int? id,
          int? planId,
          DateTime? date,
          String? mealType,
          Value<int?> recipeId = const Value.absent(),
          Value<String?> customName = const Value.absent(),
          int? serves}) =>
      PlanMeal(
        id: id ?? this.id,
        planId: planId ?? this.planId,
        date: date ?? this.date,
        mealType: mealType ?? this.mealType,
        recipeId: recipeId.present ? recipeId.value : this.recipeId,
        customName: customName.present ? customName.value : this.customName,
        serves: serves ?? this.serves,
      );
  PlanMeal copyWithCompanion(PlanMealsCompanion data) {
    return PlanMeal(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      date: data.date.present ? data.date.value : this.date,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      customName:
          data.customName.present ? data.customName.value : this.customName,
      serves: data.serves.present ? data.serves.value : this.serves,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanMeal(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('date: $date, ')
          ..write('mealType: $mealType, ')
          ..write('recipeId: $recipeId, ')
          ..write('customName: $customName, ')
          ..write('serves: $serves')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, planId, date, mealType, recipeId, customName, serves);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanMeal &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.date == this.date &&
          other.mealType == this.mealType &&
          other.recipeId == this.recipeId &&
          other.customName == this.customName &&
          other.serves == this.serves);
}

class PlanMealsCompanion extends UpdateCompanion<PlanMeal> {
  final Value<int> id;
  final Value<int> planId;
  final Value<DateTime> date;
  final Value<String> mealType;
  final Value<int?> recipeId;
  final Value<String?> customName;
  final Value<int> serves;
  const PlanMealsCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.date = const Value.absent(),
    this.mealType = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.customName = const Value.absent(),
    this.serves = const Value.absent(),
  });
  PlanMealsCompanion.insert({
    this.id = const Value.absent(),
    required int planId,
    required DateTime date,
    required String mealType,
    this.recipeId = const Value.absent(),
    this.customName = const Value.absent(),
    this.serves = const Value.absent(),
  })  : planId = Value(planId),
        date = Value(date),
        mealType = Value(mealType);
  static Insertable<PlanMeal> custom({
    Expression<int>? id,
    Expression<int>? planId,
    Expression<DateTime>? date,
    Expression<String>? mealType,
    Expression<int>? recipeId,
    Expression<String>? customName,
    Expression<int>? serves,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (date != null) 'date': date,
      if (mealType != null) 'meal_type': mealType,
      if (recipeId != null) 'recipe_id': recipeId,
      if (customName != null) 'custom_name': customName,
      if (serves != null) 'serves': serves,
    });
  }

  PlanMealsCompanion copyWith(
      {Value<int>? id,
      Value<int>? planId,
      Value<DateTime>? date,
      Value<String>? mealType,
      Value<int?>? recipeId,
      Value<String?>? customName,
      Value<int>? serves}) {
    return PlanMealsCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      recipeId: recipeId ?? this.recipeId,
      customName: customName ?? this.customName,
      serves: serves ?? this.serves,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (customName.present) {
      map['custom_name'] = Variable<String>(customName.value);
    }
    if (serves.present) {
      map['serves'] = Variable<int>(serves.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanMealsCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('date: $date, ')
          ..write('mealType: $mealType, ')
          ..write('recipeId: $recipeId, ')
          ..write('customName: $customName, ')
          ..write('serves: $serves')
          ..write(')'))
        .toString();
  }
}

class $PlanIngredientsTable extends PlanIngredients
    with TableInfo<$PlanIngredientsTable, PlanIngredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanIngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
      'plan_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES weekly_plans (id) ON DELETE CASCADE'));
  static const VerificationMeta _ingredientIdMeta =
      const VerificationMeta('ingredientId');
  @override
  late final GeneratedColumn<int> ingredientId = GeneratedColumn<int>(
      'ingredient_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES ingredients (id) ON DELETE RESTRICT'));
  static const VerificationMeta _totalQuantityMeta =
      const VerificationMeta('totalQuantity');
  @override
  late final GeneratedColumn<double> totalQuantity = GeneratedColumn<double>(
      'total_quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _offerIdMeta =
      const VerificationMeta('offerId');
  @override
  late final GeneratedColumn<int> offerId = GeneratedColumn<int>(
      'offer_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES offers (id) ON DELETE SET NULL'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, planId, ingredientId, totalQuantity, unit, offerId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_ingredients';
  @override
  VerificationContext validateIntegrity(Insertable<PlanIngredient> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_id')) {
      context.handle(_planIdMeta,
          planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta));
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
          _ingredientIdMeta,
          ingredientId.isAcceptableOrUnknown(
              data['ingredient_id']!, _ingredientIdMeta));
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('total_quantity')) {
      context.handle(
          _totalQuantityMeta,
          totalQuantity.isAcceptableOrUnknown(
              data['total_quantity']!, _totalQuantityMeta));
    } else if (isInserting) {
      context.missing(_totalQuantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('offer_id')) {
      context.handle(_offerIdMeta,
          offerId.isAcceptableOrUnknown(data['offer_id']!, _offerIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanIngredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanIngredient(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      planId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plan_id'])!,
      ingredientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ingredient_id'])!,
      totalQuantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_quantity'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      offerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}offer_id']),
    );
  }

  @override
  $PlanIngredientsTable createAlias(String alias) {
    return $PlanIngredientsTable(attachedDatabase, alias);
  }
}

class PlanIngredient extends DataClass implements Insertable<PlanIngredient> {
  final int id;
  final int planId;
  final int ingredientId;
  final double totalQuantity;
  final String? unit;
  final int? offerId;
  const PlanIngredient(
      {required this.id,
      required this.planId,
      required this.ingredientId,
      required this.totalQuantity,
      this.unit,
      this.offerId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_id'] = Variable<int>(planId);
    map['ingredient_id'] = Variable<int>(ingredientId);
    map['total_quantity'] = Variable<double>(totalQuantity);
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || offerId != null) {
      map['offer_id'] = Variable<int>(offerId);
    }
    return map;
  }

  PlanIngredientsCompanion toCompanion(bool nullToAbsent) {
    return PlanIngredientsCompanion(
      id: Value(id),
      planId: Value(planId),
      ingredientId: Value(ingredientId),
      totalQuantity: Value(totalQuantity),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      offerId: offerId == null && nullToAbsent
          ? const Value.absent()
          : Value(offerId),
    );
  }

  factory PlanIngredient.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanIngredient(
      id: serializer.fromJson<int>(json['id']),
      planId: serializer.fromJson<int>(json['planId']),
      ingredientId: serializer.fromJson<int>(json['ingredientId']),
      totalQuantity: serializer.fromJson<double>(json['totalQuantity']),
      unit: serializer.fromJson<String?>(json['unit']),
      offerId: serializer.fromJson<int?>(json['offerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planId': serializer.toJson<int>(planId),
      'ingredientId': serializer.toJson<int>(ingredientId),
      'totalQuantity': serializer.toJson<double>(totalQuantity),
      'unit': serializer.toJson<String?>(unit),
      'offerId': serializer.toJson<int?>(offerId),
    };
  }

  PlanIngredient copyWith(
          {int? id,
          int? planId,
          int? ingredientId,
          double? totalQuantity,
          Value<String?> unit = const Value.absent(),
          Value<int?> offerId = const Value.absent()}) =>
      PlanIngredient(
        id: id ?? this.id,
        planId: planId ?? this.planId,
        ingredientId: ingredientId ?? this.ingredientId,
        totalQuantity: totalQuantity ?? this.totalQuantity,
        unit: unit.present ? unit.value : this.unit,
        offerId: offerId.present ? offerId.value : this.offerId,
      );
  PlanIngredient copyWithCompanion(PlanIngredientsCompanion data) {
    return PlanIngredient(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      totalQuantity: data.totalQuantity.present
          ? data.totalQuantity.value
          : this.totalQuantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      offerId: data.offerId.present ? data.offerId.value : this.offerId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanIngredient(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('totalQuantity: $totalQuantity, ')
          ..write('unit: $unit, ')
          ..write('offerId: $offerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, planId, ingredientId, totalQuantity, unit, offerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanIngredient &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.ingredientId == this.ingredientId &&
          other.totalQuantity == this.totalQuantity &&
          other.unit == this.unit &&
          other.offerId == this.offerId);
}

class PlanIngredientsCompanion extends UpdateCompanion<PlanIngredient> {
  final Value<int> id;
  final Value<int> planId;
  final Value<int> ingredientId;
  final Value<double> totalQuantity;
  final Value<String?> unit;
  final Value<int?> offerId;
  const PlanIngredientsCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.totalQuantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.offerId = const Value.absent(),
  });
  PlanIngredientsCompanion.insert({
    this.id = const Value.absent(),
    required int planId,
    required int ingredientId,
    required double totalQuantity,
    this.unit = const Value.absent(),
    this.offerId = const Value.absent(),
  })  : planId = Value(planId),
        ingredientId = Value(ingredientId),
        totalQuantity = Value(totalQuantity);
  static Insertable<PlanIngredient> custom({
    Expression<int>? id,
    Expression<int>? planId,
    Expression<int>? ingredientId,
    Expression<double>? totalQuantity,
    Expression<String>? unit,
    Expression<int>? offerId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (totalQuantity != null) 'total_quantity': totalQuantity,
      if (unit != null) 'unit': unit,
      if (offerId != null) 'offer_id': offerId,
    });
  }

  PlanIngredientsCompanion copyWith(
      {Value<int>? id,
      Value<int>? planId,
      Value<int>? ingredientId,
      Value<double>? totalQuantity,
      Value<String?>? unit,
      Value<int?>? offerId}) {
    return PlanIngredientsCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      ingredientId: ingredientId ?? this.ingredientId,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      unit: unit ?? this.unit,
      offerId: offerId ?? this.offerId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<int>(ingredientId.value);
    }
    if (totalQuantity.present) {
      map['total_quantity'] = Variable<double>(totalQuantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (offerId.present) {
      map['offer_id'] = Variable<int>(offerId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanIngredientsCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('totalQuantity: $totalQuantity, ')
          ..write('unit: $unit, ')
          ..write('offerId: $offerId')
          ..write(')'))
        .toString();
  }
}

class $UserProfileTable extends UserProfile
    with TableInfo<$UserProfileTable, UserProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _personsMeta =
      const VerificationMeta('persons');
  @override
  late final GeneratedColumn<int> persons = GeneratedColumn<int>(
      'persons', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(2));
  static const VerificationMeta _zipCodeMeta =
      const VerificationMeta('zipCode');
  @override
  late final GeneratedColumn<String> zipCode = GeneratedColumn<String>(
      'zip_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _selectedDiscountersJsonMeta =
      const VerificationMeta('selectedDiscountersJson');
  @override
  late final GeneratedColumn<String> selectedDiscountersJson =
      GeneratedColumn<String>('selected_discounters_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _weeklyPlanAutoMeta =
      const VerificationMeta('weeklyPlanAuto');
  @override
  late final GeneratedColumn<bool> weeklyPlanAuto = GeneratedColumn<bool>(
      'weekly_plan_auto', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("weekly_plan_auto" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _planDowMeta =
      const VerificationMeta('planDow');
  @override
  late final GeneratedColumn<int> planDow = GeneratedColumn<int>(
      'plan_dow', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _marktguruEnabledMeta =
      const VerificationMeta('marktguruEnabled');
  @override
  late final GeneratedColumn<bool> marktguruEnabled = GeneratedColumn<bool>(
      'marktguru_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("marktguru_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        persons,
        zipCode,
        selectedDiscountersJson,
        weeklyPlanAuto,
        planDow,
        marktguruEnabled
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile';
  @override
  VerificationContext validateIntegrity(Insertable<UserProfileData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('persons')) {
      context.handle(_personsMeta,
          persons.isAcceptableOrUnknown(data['persons']!, _personsMeta));
    }
    if (data.containsKey('zip_code')) {
      context.handle(_zipCodeMeta,
          zipCode.isAcceptableOrUnknown(data['zip_code']!, _zipCodeMeta));
    }
    if (data.containsKey('selected_discounters_json')) {
      context.handle(
          _selectedDiscountersJsonMeta,
          selectedDiscountersJson.isAcceptableOrUnknown(
              data['selected_discounters_json']!,
              _selectedDiscountersJsonMeta));
    }
    if (data.containsKey('weekly_plan_auto')) {
      context.handle(
          _weeklyPlanAutoMeta,
          weeklyPlanAuto.isAcceptableOrUnknown(
              data['weekly_plan_auto']!, _weeklyPlanAutoMeta));
    }
    if (data.containsKey('plan_dow')) {
      context.handle(_planDowMeta,
          planDow.isAcceptableOrUnknown(data['plan_dow']!, _planDowMeta));
    }
    if (data.containsKey('marktguru_enabled')) {
      context.handle(
          _marktguruEnabledMeta,
          marktguruEnabled.isAcceptableOrUnknown(
              data['marktguru_enabled']!, _marktguruEnabledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      persons: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}persons'])!,
      zipCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}zip_code']),
      selectedDiscountersJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}selected_discounters_json'])!,
      weeklyPlanAuto: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}weekly_plan_auto'])!,
      planDow: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plan_dow'])!,
      marktguruEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}marktguru_enabled'])!,
    );
  }

  @override
  $UserProfileTable createAlias(String alias) {
    return $UserProfileTable(attachedDatabase, alias);
  }
}

class UserProfileData extends DataClass implements Insertable<UserProfileData> {
  final int id;
  final int persons;
  final String? zipCode;
  final String selectedDiscountersJson;
  final bool weeklyPlanAuto;
  final int planDow;
  final bool marktguruEnabled;
  const UserProfileData(
      {required this.id,
      required this.persons,
      this.zipCode,
      required this.selectedDiscountersJson,
      required this.weeklyPlanAuto,
      required this.planDow,
      required this.marktguruEnabled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['persons'] = Variable<int>(persons);
    if (!nullToAbsent || zipCode != null) {
      map['zip_code'] = Variable<String>(zipCode);
    }
    map['selected_discounters_json'] =
        Variable<String>(selectedDiscountersJson);
    map['weekly_plan_auto'] = Variable<bool>(weeklyPlanAuto);
    map['plan_dow'] = Variable<int>(planDow);
    map['marktguru_enabled'] = Variable<bool>(marktguruEnabled);
    return map;
  }

  UserProfileCompanion toCompanion(bool nullToAbsent) {
    return UserProfileCompanion(
      id: Value(id),
      persons: Value(persons),
      zipCode: zipCode == null && nullToAbsent
          ? const Value.absent()
          : Value(zipCode),
      selectedDiscountersJson: Value(selectedDiscountersJson),
      weeklyPlanAuto: Value(weeklyPlanAuto),
      planDow: Value(planDow),
      marktguruEnabled: Value(marktguruEnabled),
    );
  }

  factory UserProfileData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileData(
      id: serializer.fromJson<int>(json['id']),
      persons: serializer.fromJson<int>(json['persons']),
      zipCode: serializer.fromJson<String?>(json['zipCode']),
      selectedDiscountersJson:
          serializer.fromJson<String>(json['selectedDiscountersJson']),
      weeklyPlanAuto: serializer.fromJson<bool>(json['weeklyPlanAuto']),
      planDow: serializer.fromJson<int>(json['planDow']),
      marktguruEnabled: serializer.fromJson<bool>(json['marktguruEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'persons': serializer.toJson<int>(persons),
      'zipCode': serializer.toJson<String?>(zipCode),
      'selectedDiscountersJson':
          serializer.toJson<String>(selectedDiscountersJson),
      'weeklyPlanAuto': serializer.toJson<bool>(weeklyPlanAuto),
      'planDow': serializer.toJson<int>(planDow),
      'marktguruEnabled': serializer.toJson<bool>(marktguruEnabled),
    };
  }

  UserProfileData copyWith(
          {int? id,
          int? persons,
          Value<String?> zipCode = const Value.absent(),
          String? selectedDiscountersJson,
          bool? weeklyPlanAuto,
          int? planDow,
          bool? marktguruEnabled}) =>
      UserProfileData(
        id: id ?? this.id,
        persons: persons ?? this.persons,
        zipCode: zipCode.present ? zipCode.value : this.zipCode,
        selectedDiscountersJson:
            selectedDiscountersJson ?? this.selectedDiscountersJson,
        weeklyPlanAuto: weeklyPlanAuto ?? this.weeklyPlanAuto,
        planDow: planDow ?? this.planDow,
        marktguruEnabled: marktguruEnabled ?? this.marktguruEnabled,
      );
  UserProfileData copyWithCompanion(UserProfileCompanion data) {
    return UserProfileData(
      id: data.id.present ? data.id.value : this.id,
      persons: data.persons.present ? data.persons.value : this.persons,
      zipCode: data.zipCode.present ? data.zipCode.value : this.zipCode,
      selectedDiscountersJson: data.selectedDiscountersJson.present
          ? data.selectedDiscountersJson.value
          : this.selectedDiscountersJson,
      weeklyPlanAuto: data.weeklyPlanAuto.present
          ? data.weeklyPlanAuto.value
          : this.weeklyPlanAuto,
      planDow: data.planDow.present ? data.planDow.value : this.planDow,
      marktguruEnabled: data.marktguruEnabled.present
          ? data.marktguruEnabled.value
          : this.marktguruEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileData(')
          ..write('id: $id, ')
          ..write('persons: $persons, ')
          ..write('zipCode: $zipCode, ')
          ..write('selectedDiscountersJson: $selectedDiscountersJson, ')
          ..write('weeklyPlanAuto: $weeklyPlanAuto, ')
          ..write('planDow: $planDow, ')
          ..write('marktguruEnabled: $marktguruEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, persons, zipCode, selectedDiscountersJson,
      weeklyPlanAuto, planDow, marktguruEnabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileData &&
          other.id == this.id &&
          other.persons == this.persons &&
          other.zipCode == this.zipCode &&
          other.selectedDiscountersJson == this.selectedDiscountersJson &&
          other.weeklyPlanAuto == this.weeklyPlanAuto &&
          other.planDow == this.planDow &&
          other.marktguruEnabled == this.marktguruEnabled);
}

class UserProfileCompanion extends UpdateCompanion<UserProfileData> {
  final Value<int> id;
  final Value<int> persons;
  final Value<String?> zipCode;
  final Value<String> selectedDiscountersJson;
  final Value<bool> weeklyPlanAuto;
  final Value<int> planDow;
  final Value<bool> marktguruEnabled;
  const UserProfileCompanion({
    this.id = const Value.absent(),
    this.persons = const Value.absent(),
    this.zipCode = const Value.absent(),
    this.selectedDiscountersJson = const Value.absent(),
    this.weeklyPlanAuto = const Value.absent(),
    this.planDow = const Value.absent(),
    this.marktguruEnabled = const Value.absent(),
  });
  UserProfileCompanion.insert({
    this.id = const Value.absent(),
    this.persons = const Value.absent(),
    this.zipCode = const Value.absent(),
    this.selectedDiscountersJson = const Value.absent(),
    this.weeklyPlanAuto = const Value.absent(),
    this.planDow = const Value.absent(),
    this.marktguruEnabled = const Value.absent(),
  });
  static Insertable<UserProfileData> custom({
    Expression<int>? id,
    Expression<int>? persons,
    Expression<String>? zipCode,
    Expression<String>? selectedDiscountersJson,
    Expression<bool>? weeklyPlanAuto,
    Expression<int>? planDow,
    Expression<bool>? marktguruEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (persons != null) 'persons': persons,
      if (zipCode != null) 'zip_code': zipCode,
      if (selectedDiscountersJson != null)
        'selected_discounters_json': selectedDiscountersJson,
      if (weeklyPlanAuto != null) 'weekly_plan_auto': weeklyPlanAuto,
      if (planDow != null) 'plan_dow': planDow,
      if (marktguruEnabled != null) 'marktguru_enabled': marktguruEnabled,
    });
  }

  UserProfileCompanion copyWith(
      {Value<int>? id,
      Value<int>? persons,
      Value<String?>? zipCode,
      Value<String>? selectedDiscountersJson,
      Value<bool>? weeklyPlanAuto,
      Value<int>? planDow,
      Value<bool>? marktguruEnabled}) {
    return UserProfileCompanion(
      id: id ?? this.id,
      persons: persons ?? this.persons,
      zipCode: zipCode ?? this.zipCode,
      selectedDiscountersJson:
          selectedDiscountersJson ?? this.selectedDiscountersJson,
      weeklyPlanAuto: weeklyPlanAuto ?? this.weeklyPlanAuto,
      planDow: planDow ?? this.planDow,
      marktguruEnabled: marktguruEnabled ?? this.marktguruEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (persons.present) {
      map['persons'] = Variable<int>(persons.value);
    }
    if (zipCode.present) {
      map['zip_code'] = Variable<String>(zipCode.value);
    }
    if (selectedDiscountersJson.present) {
      map['selected_discounters_json'] =
          Variable<String>(selectedDiscountersJson.value);
    }
    if (weeklyPlanAuto.present) {
      map['weekly_plan_auto'] = Variable<bool>(weeklyPlanAuto.value);
    }
    if (planDow.present) {
      map['plan_dow'] = Variable<int>(planDow.value);
    }
    if (marktguruEnabled.present) {
      map['marktguru_enabled'] = Variable<bool>(marktguruEnabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileCompanion(')
          ..write('id: $id, ')
          ..write('persons: $persons, ')
          ..write('zipCode: $zipCode, ')
          ..write('selectedDiscountersJson: $selectedDiscountersJson, ')
          ..write('weeklyPlanAuto: $weeklyPlanAuto, ')
          ..write('planDow: $planDow, ')
          ..write('marktguruEnabled: $marktguruEnabled')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $ShoppingItemsTable shoppingItems = $ShoppingItemsTable(this);
  late final $FoodLogTable foodLog = $FoodLogTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $IngredientsTable ingredients = $IngredientsTable(this);
  late final $RecipeIngredientsTable recipeIngredients =
      $RecipeIngredientsTable(this);
  late final $ContraindicationsTable contraindications =
      $ContraindicationsTable(this);
  late final $UserContraindicationsTable userContraindications =
      $UserContraindicationsTable(this);
  late final $DiscountersTable discounters = $DiscountersTable(this);
  late final $OffersTable offers = $OffersTable(this);
  late final $WeeklyPlansTable weeklyPlans = $WeeklyPlansTable(this);
  late final $PlanMealsTable planMeals = $PlanMealsTable(this);
  late final $PlanIngredientsTable planIngredients =
      $PlanIngredientsTable(this);
  late final $UserProfileTable userProfile = $UserProfileTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        recipes,
        shoppingItems,
        foodLog,
        settings,
        ingredients,
        recipeIngredients,
        contraindications,
        userContraindications,
        discounters,
        offers,
        weeklyPlans,
        planMeals,
        planIngredients,
        userProfile
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('recipes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('recipe_ingredients', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('contraindications',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('user_contraindications', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('discounters',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('offers', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('ingredients',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('offers', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('weekly_plans',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('plan_meals', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('recipes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('plan_meals', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('weekly_plans',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('plan_ingredients', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('offers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('plan_ingredients', kind: UpdateKind.update),
            ],
          ),
        ],
      );
}

typedef $$RecipesTableCreateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> description,
  Value<int?> prepTime,
  Value<int?> calories,
  Value<double?> protein,
  Value<double?> carbs,
  Value<double?> fat,
  required DateTime createdAt,
});
typedef $$RecipesTableUpdateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<int?> prepTime,
  Value<int?> calories,
  Value<double?> protein,
  Value<double?> carbs,
  Value<double?> fat,
  Value<DateTime> createdAt,
});

final class $$RecipesTableReferences
    extends BaseReferences<_$AppDatabase, $RecipesTable, Recipe> {
  $$RecipesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecipeIngredientsTable, List<RecipeIngredient>>
      _recipeIngredientsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.recipeIngredients,
              aliasName: $_aliasNameGenerator(
                  db.recipes.id, db.recipeIngredients.recipeId));

  $$RecipeIngredientsTableProcessedTableManager get recipeIngredientsRefs {
    final manager =
        $$RecipeIngredientsTableTableManager($_db, $_db.recipeIngredients)
            .filter((f) => f.recipeId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_recipeIngredientsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PlanMealsTable, List<PlanMeal>>
      _planMealsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.planMeals,
              aliasName:
                  $_aliasNameGenerator(db.recipes.id, db.planMeals.recipeId));

  $$PlanMealsTableProcessedTableManager get planMealsRefs {
    final manager = $$PlanMealsTableTableManager($_db, $_db.planMeals)
        .filter((f) => f.recipeId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_planMealsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get prepTime => $composableBuilder(
      column: $table.prepTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get calories => $composableBuilder(
      column: $table.calories, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get protein => $composableBuilder(
      column: $table.protein, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get carbs => $composableBuilder(
      column: $table.carbs, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fat => $composableBuilder(
      column: $table.fat, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> recipeIngredientsRefs(
      Expression<bool> Function($$RecipeIngredientsTableFilterComposer f) f) {
    final $$RecipeIngredientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recipeIngredients,
        getReferencedColumn: (t) => t.recipeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipeIngredientsTableFilterComposer(
              $db: $db,
              $table: $db.recipeIngredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> planMealsRefs(
      Expression<bool> Function($$PlanMealsTableFilterComposer f) f) {
    final $$PlanMealsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.planMeals,
        getReferencedColumn: (t) => t.recipeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlanMealsTableFilterComposer(
              $db: $db,
              $table: $db.planMeals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get prepTime => $composableBuilder(
      column: $table.prepTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get calories => $composableBuilder(
      column: $table.calories, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get protein => $composableBuilder(
      column: $table.protein, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get carbs => $composableBuilder(
      column: $table.carbs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fat => $composableBuilder(
      column: $table.fat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get prepTime =>
      $composableBuilder(column: $table.prepTime, builder: (column) => column);

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> recipeIngredientsRefs<T extends Object>(
      Expression<T> Function($$RecipeIngredientsTableAnnotationComposer a) f) {
    final $$RecipeIngredientsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.recipeIngredients,
            getReferencedColumn: (t) => t.recipeId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$RecipeIngredientsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.recipeIngredients,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> planMealsRefs<T extends Object>(
      Expression<T> Function($$PlanMealsTableAnnotationComposer a) f) {
    final $$PlanMealsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.planMeals,
        getReferencedColumn: (t) => t.recipeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlanMealsTableAnnotationComposer(
              $db: $db,
              $table: $db.planMeals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RecipesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecipesTable,
    Recipe,
    $$RecipesTableFilterComposer,
    $$RecipesTableOrderingComposer,
    $$RecipesTableAnnotationComposer,
    $$RecipesTableCreateCompanionBuilder,
    $$RecipesTableUpdateCompanionBuilder,
    (Recipe, $$RecipesTableReferences),
    Recipe,
    PrefetchHooks Function({bool recipeIngredientsRefs, bool planMealsRefs})> {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int?> prepTime = const Value.absent(),
            Value<int?> calories = const Value.absent(),
            Value<double?> protein = const Value.absent(),
            Value<double?> carbs = const Value.absent(),
            Value<double?> fat = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              RecipesCompanion(
            id: id,
            name: name,
            description: description,
            prepTime: prepTime,
            calories: calories,
            protein: protein,
            carbs: carbs,
            fat: fat,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            Value<int?> prepTime = const Value.absent(),
            Value<int?> calories = const Value.absent(),
            Value<double?> protein = const Value.absent(),
            Value<double?> carbs = const Value.absent(),
            Value<double?> fat = const Value.absent(),
            required DateTime createdAt,
          }) =>
              RecipesCompanion.insert(
            id: id,
            name: name,
            description: description,
            prepTime: prepTime,
            calories: calories,
            protein: protein,
            carbs: carbs,
            fat: fat,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$RecipesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {recipeIngredientsRefs = false, planMealsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (recipeIngredientsRefs) db.recipeIngredients,
                if (planMealsRefs) db.planMeals
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recipeIngredientsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$RecipesTableReferences
                            ._recipeIngredientsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RecipesTableReferences(db, table, p0)
                                .recipeIngredientsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.recipeId == item.id),
                        typedResults: items),
                  if (planMealsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$RecipesTableReferences._planMealsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RecipesTableReferences(db, table, p0)
                                .planMealsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.recipeId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RecipesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecipesTable,
    Recipe,
    $$RecipesTableFilterComposer,
    $$RecipesTableOrderingComposer,
    $$RecipesTableAnnotationComposer,
    $$RecipesTableCreateCompanionBuilder,
    $$RecipesTableUpdateCompanionBuilder,
    (Recipe, $$RecipesTableReferences),
    Recipe,
    PrefetchHooks Function({bool recipeIngredientsRefs, bool planMealsRefs})>;
typedef $$ShoppingItemsTableCreateCompanionBuilder = ShoppingItemsCompanion
    Function({
  Value<int> id,
  required String item,
  Value<double?> quantity,
  Value<String?> unit,
  Value<bool> checked,
});
typedef $$ShoppingItemsTableUpdateCompanionBuilder = ShoppingItemsCompanion
    Function({
  Value<int> id,
  Value<String> item,
  Value<double?> quantity,
  Value<String?> unit,
  Value<bool> checked,
});

class $$ShoppingItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get item => $composableBuilder(
      column: $table.item, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get checked => $composableBuilder(
      column: $table.checked, builder: (column) => ColumnFilters(column));
}

class $$ShoppingItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get item => $composableBuilder(
      column: $table.item, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get checked => $composableBuilder(
      column: $table.checked, builder: (column) => ColumnOrderings(column));
}

class $$ShoppingItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get item =>
      $composableBuilder(column: $table.item, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get checked =>
      $composableBuilder(column: $table.checked, builder: (column) => column);
}

class $$ShoppingItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShoppingItemsTable,
    ShoppingItem,
    $$ShoppingItemsTableFilterComposer,
    $$ShoppingItemsTableOrderingComposer,
    $$ShoppingItemsTableAnnotationComposer,
    $$ShoppingItemsTableCreateCompanionBuilder,
    $$ShoppingItemsTableUpdateCompanionBuilder,
    (
      ShoppingItem,
      BaseReferences<_$AppDatabase, $ShoppingItemsTable, ShoppingItem>
    ),
    ShoppingItem,
    PrefetchHooks Function()> {
  $$ShoppingItemsTableTableManager(_$AppDatabase db, $ShoppingItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> item = const Value.absent(),
            Value<double?> quantity = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<bool> checked = const Value.absent(),
          }) =>
              ShoppingItemsCompanion(
            id: id,
            item: item,
            quantity: quantity,
            unit: unit,
            checked: checked,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String item,
            Value<double?> quantity = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<bool> checked = const Value.absent(),
          }) =>
              ShoppingItemsCompanion.insert(
            id: id,
            item: item,
            quantity: quantity,
            unit: unit,
            checked: checked,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ShoppingItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ShoppingItemsTable,
    ShoppingItem,
    $$ShoppingItemsTableFilterComposer,
    $$ShoppingItemsTableOrderingComposer,
    $$ShoppingItemsTableAnnotationComposer,
    $$ShoppingItemsTableCreateCompanionBuilder,
    $$ShoppingItemsTableUpdateCompanionBuilder,
    (
      ShoppingItem,
      BaseReferences<_$AppDatabase, $ShoppingItemsTable, ShoppingItem>
    ),
    ShoppingItem,
    PrefetchHooks Function()>;
typedef $$FoodLogTableCreateCompanionBuilder = FoodLogCompanion Function({
  Value<int> id,
  required String date,
  required String mealType,
  Value<int?> calories,
  Value<double?> protein,
  Value<double?> carbs,
  Value<double?> fat,
  Value<String?> customName,
});
typedef $$FoodLogTableUpdateCompanionBuilder = FoodLogCompanion Function({
  Value<int> id,
  Value<String> date,
  Value<String> mealType,
  Value<int?> calories,
  Value<double?> protein,
  Value<double?> carbs,
  Value<double?> fat,
  Value<String?> customName,
});

class $$FoodLogTableFilterComposer
    extends Composer<_$AppDatabase, $FoodLogTable> {
  $$FoodLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get calories => $composableBuilder(
      column: $table.calories, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get protein => $composableBuilder(
      column: $table.protein, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get carbs => $composableBuilder(
      column: $table.carbs, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fat => $composableBuilder(
      column: $table.fat, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customName => $composableBuilder(
      column: $table.customName, builder: (column) => ColumnFilters(column));
}

class $$FoodLogTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodLogTable> {
  $$FoodLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get calories => $composableBuilder(
      column: $table.calories, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get protein => $composableBuilder(
      column: $table.protein, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get carbs => $composableBuilder(
      column: $table.carbs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fat => $composableBuilder(
      column: $table.fat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customName => $composableBuilder(
      column: $table.customName, builder: (column) => ColumnOrderings(column));
}

class $$FoodLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodLogTable> {
  $$FoodLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<String> get customName => $composableBuilder(
      column: $table.customName, builder: (column) => column);
}

class $$FoodLogTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FoodLogTable,
    FoodLogData,
    $$FoodLogTableFilterComposer,
    $$FoodLogTableOrderingComposer,
    $$FoodLogTableAnnotationComposer,
    $$FoodLogTableCreateCompanionBuilder,
    $$FoodLogTableUpdateCompanionBuilder,
    (FoodLogData, BaseReferences<_$AppDatabase, $FoodLogTable, FoodLogData>),
    FoodLogData,
    PrefetchHooks Function()> {
  $$FoodLogTableTableManager(_$AppDatabase db, $FoodLogTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String> mealType = const Value.absent(),
            Value<int?> calories = const Value.absent(),
            Value<double?> protein = const Value.absent(),
            Value<double?> carbs = const Value.absent(),
            Value<double?> fat = const Value.absent(),
            Value<String?> customName = const Value.absent(),
          }) =>
              FoodLogCompanion(
            id: id,
            date: date,
            mealType: mealType,
            calories: calories,
            protein: protein,
            carbs: carbs,
            fat: fat,
            customName: customName,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String date,
            required String mealType,
            Value<int?> calories = const Value.absent(),
            Value<double?> protein = const Value.absent(),
            Value<double?> carbs = const Value.absent(),
            Value<double?> fat = const Value.absent(),
            Value<String?> customName = const Value.absent(),
          }) =>
              FoodLogCompanion.insert(
            id: id,
            date: date,
            mealType: mealType,
            calories: calories,
            protein: protein,
            carbs: carbs,
            fat: fat,
            customName: customName,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FoodLogTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FoodLogTable,
    FoodLogData,
    $$FoodLogTableFilterComposer,
    $$FoodLogTableOrderingComposer,
    $$FoodLogTableAnnotationComposer,
    $$FoodLogTableCreateCompanionBuilder,
    $$FoodLogTableUpdateCompanionBuilder,
    (FoodLogData, BaseReferences<_$AppDatabase, $FoodLogTable, FoodLogData>),
    FoodLogData,
    PrefetchHooks Function()>;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<String> locale,
  Value<String> units,
  Value<String> theme,
  Value<int?> calorieGoal,
  Value<double?> proteinGoal,
  Value<double?> carbsGoal,
  Value<double?> fatGoal,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<String> locale,
  Value<String> units,
  Value<String> theme,
  Value<int?> calorieGoal,
  Value<double?> proteinGoal,
  Value<double?> carbsGoal,
  Value<double?> fatGoal,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locale => $composableBuilder(
      column: $table.locale, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get units => $composableBuilder(
      column: $table.units, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get theme => $composableBuilder(
      column: $table.theme, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get calorieGoal => $composableBuilder(
      column: $table.calorieGoal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get proteinGoal => $composableBuilder(
      column: $table.proteinGoal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get carbsGoal => $composableBuilder(
      column: $table.carbsGoal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fatGoal => $composableBuilder(
      column: $table.fatGoal, builder: (column) => ColumnFilters(column));
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locale => $composableBuilder(
      column: $table.locale, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get units => $composableBuilder(
      column: $table.units, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get theme => $composableBuilder(
      column: $table.theme, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get calorieGoal => $composableBuilder(
      column: $table.calorieGoal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get proteinGoal => $composableBuilder(
      column: $table.proteinGoal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get carbsGoal => $composableBuilder(
      column: $table.carbsGoal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fatGoal => $composableBuilder(
      column: $table.fatGoal, builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get units =>
      $composableBuilder(column: $table.units, builder: (column) => column);

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<int> get calorieGoal => $composableBuilder(
      column: $table.calorieGoal, builder: (column) => column);

  GeneratedColumn<double> get proteinGoal => $composableBuilder(
      column: $table.proteinGoal, builder: (column) => column);

  GeneratedColumn<double> get carbsGoal =>
      $composableBuilder(column: $table.carbsGoal, builder: (column) => column);

  GeneratedColumn<double> get fatGoal =>
      $composableBuilder(column: $table.fatGoal, builder: (column) => column);
}

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> locale = const Value.absent(),
            Value<String> units = const Value.absent(),
            Value<String> theme = const Value.absent(),
            Value<int?> calorieGoal = const Value.absent(),
            Value<double?> proteinGoal = const Value.absent(),
            Value<double?> carbsGoal = const Value.absent(),
            Value<double?> fatGoal = const Value.absent(),
          }) =>
              SettingsCompanion(
            id: id,
            locale: locale,
            units: units,
            theme: theme,
            calorieGoal: calorieGoal,
            proteinGoal: proteinGoal,
            carbsGoal: carbsGoal,
            fatGoal: fatGoal,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> locale = const Value.absent(),
            Value<String> units = const Value.absent(),
            Value<String> theme = const Value.absent(),
            Value<int?> calorieGoal = const Value.absent(),
            Value<double?> proteinGoal = const Value.absent(),
            Value<double?> carbsGoal = const Value.absent(),
            Value<double?> fatGoal = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            id: id,
            locale: locale,
            units: units,
            theme: theme,
            calorieGoal: calorieGoal,
            proteinGoal: proteinGoal,
            carbsGoal: carbsGoal,
            fatGoal: fatGoal,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()>;
typedef $$IngredientsTableCreateCompanionBuilder = IngredientsCompanion
    Function({
  Value<int> id,
  required String name,
  Value<String?> category,
  Value<int> seasonStart,
  Value<int> seasonEnd,
  Value<String> allergensJson,
  Value<String> riskTagsJson,
  Value<String?> unitDefault,
});
typedef $$IngredientsTableUpdateCompanionBuilder = IngredientsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String?> category,
  Value<int> seasonStart,
  Value<int> seasonEnd,
  Value<String> allergensJson,
  Value<String> riskTagsJson,
  Value<String?> unitDefault,
});

final class $$IngredientsTableReferences
    extends BaseReferences<_$AppDatabase, $IngredientsTable, Ingredient> {
  $$IngredientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecipeIngredientsTable, List<RecipeIngredient>>
      _recipeIngredientsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.recipeIngredients,
              aliasName: $_aliasNameGenerator(
                  db.ingredients.id, db.recipeIngredients.ingredientId));

  $$RecipeIngredientsTableProcessedTableManager get recipeIngredientsRefs {
    final manager =
        $$RecipeIngredientsTableTableManager($_db, $_db.recipeIngredients)
            .filter((f) => f.ingredientId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_recipeIngredientsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$OffersTable, List<Offer>> _offersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.offers,
          aliasName:
              $_aliasNameGenerator(db.ingredients.id, db.offers.ingredientId));

  $$OffersTableProcessedTableManager get offersRefs {
    final manager = $$OffersTableTableManager($_db, $_db.offers)
        .filter((f) => f.ingredientId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_offersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PlanIngredientsTable, List<PlanIngredient>>
      _planIngredientsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.planIngredients,
              aliasName: $_aliasNameGenerator(
                  db.ingredients.id, db.planIngredients.ingredientId));

  $$PlanIngredientsTableProcessedTableManager get planIngredientsRefs {
    final manager =
        $$PlanIngredientsTableTableManager($_db, $_db.planIngredients)
            .filter((f) => f.ingredientId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_planIngredientsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$IngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get seasonStart => $composableBuilder(
      column: $table.seasonStart, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get seasonEnd => $composableBuilder(
      column: $table.seasonEnd, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get allergensJson => $composableBuilder(
      column: $table.allergensJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get riskTagsJson => $composableBuilder(
      column: $table.riskTagsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitDefault => $composableBuilder(
      column: $table.unitDefault, builder: (column) => ColumnFilters(column));

  Expression<bool> recipeIngredientsRefs(
      Expression<bool> Function($$RecipeIngredientsTableFilterComposer f) f) {
    final $$RecipeIngredientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recipeIngredients,
        getReferencedColumn: (t) => t.ingredientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipeIngredientsTableFilterComposer(
              $db: $db,
              $table: $db.recipeIngredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> offersRefs(
      Expression<bool> Function($$OffersTableFilterComposer f) f) {
    final $$OffersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.offers,
        getReferencedColumn: (t) => t.ingredientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OffersTableFilterComposer(
              $db: $db,
              $table: $db.offers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> planIngredientsRefs(
      Expression<bool> Function($$PlanIngredientsTableFilterComposer f) f) {
    final $$PlanIngredientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.planIngredients,
        getReferencedColumn: (t) => t.ingredientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlanIngredientsTableFilterComposer(
              $db: $db,
              $table: $db.planIngredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$IngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get seasonStart => $composableBuilder(
      column: $table.seasonStart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get seasonEnd => $composableBuilder(
      column: $table.seasonEnd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get allergensJson => $composableBuilder(
      column: $table.allergensJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get riskTagsJson => $composableBuilder(
      column: $table.riskTagsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitDefault => $composableBuilder(
      column: $table.unitDefault, builder: (column) => ColumnOrderings(column));
}

class $$IngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get seasonStart => $composableBuilder(
      column: $table.seasonStart, builder: (column) => column);

  GeneratedColumn<int> get seasonEnd =>
      $composableBuilder(column: $table.seasonEnd, builder: (column) => column);

  GeneratedColumn<String> get allergensJson => $composableBuilder(
      column: $table.allergensJson, builder: (column) => column);

  GeneratedColumn<String> get riskTagsJson => $composableBuilder(
      column: $table.riskTagsJson, builder: (column) => column);

  GeneratedColumn<String> get unitDefault => $composableBuilder(
      column: $table.unitDefault, builder: (column) => column);

  Expression<T> recipeIngredientsRefs<T extends Object>(
      Expression<T> Function($$RecipeIngredientsTableAnnotationComposer a) f) {
    final $$RecipeIngredientsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.recipeIngredients,
            getReferencedColumn: (t) => t.ingredientId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$RecipeIngredientsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.recipeIngredients,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> offersRefs<T extends Object>(
      Expression<T> Function($$OffersTableAnnotationComposer a) f) {
    final $$OffersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.offers,
        getReferencedColumn: (t) => t.ingredientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OffersTableAnnotationComposer(
              $db: $db,
              $table: $db.offers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> planIngredientsRefs<T extends Object>(
      Expression<T> Function($$PlanIngredientsTableAnnotationComposer a) f) {
    final $$PlanIngredientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.planIngredients,
        getReferencedColumn: (t) => t.ingredientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlanIngredientsTableAnnotationComposer(
              $db: $db,
              $table: $db.planIngredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$IngredientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IngredientsTable,
    Ingredient,
    $$IngredientsTableFilterComposer,
    $$IngredientsTableOrderingComposer,
    $$IngredientsTableAnnotationComposer,
    $$IngredientsTableCreateCompanionBuilder,
    $$IngredientsTableUpdateCompanionBuilder,
    (Ingredient, $$IngredientsTableReferences),
    Ingredient,
    PrefetchHooks Function(
        {bool recipeIngredientsRefs,
        bool offersRefs,
        bool planIngredientsRefs})> {
  $$IngredientsTableTableManager(_$AppDatabase db, $IngredientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<int> seasonStart = const Value.absent(),
            Value<int> seasonEnd = const Value.absent(),
            Value<String> allergensJson = const Value.absent(),
            Value<String> riskTagsJson = const Value.absent(),
            Value<String?> unitDefault = const Value.absent(),
          }) =>
              IngredientsCompanion(
            id: id,
            name: name,
            category: category,
            seasonStart: seasonStart,
            seasonEnd: seasonEnd,
            allergensJson: allergensJson,
            riskTagsJson: riskTagsJson,
            unitDefault: unitDefault,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> category = const Value.absent(),
            Value<int> seasonStart = const Value.absent(),
            Value<int> seasonEnd = const Value.absent(),
            Value<String> allergensJson = const Value.absent(),
            Value<String> riskTagsJson = const Value.absent(),
            Value<String?> unitDefault = const Value.absent(),
          }) =>
              IngredientsCompanion.insert(
            id: id,
            name: name,
            category: category,
            seasonStart: seasonStart,
            seasonEnd: seasonEnd,
            allergensJson: allergensJson,
            riskTagsJson: riskTagsJson,
            unitDefault: unitDefault,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$IngredientsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {recipeIngredientsRefs = false,
              offersRefs = false,
              planIngredientsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (recipeIngredientsRefs) db.recipeIngredients,
                if (offersRefs) db.offers,
                if (planIngredientsRefs) db.planIngredients
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recipeIngredientsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$IngredientsTableReferences
                            ._recipeIngredientsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$IngredientsTableReferences(db, table, p0)
                                .recipeIngredientsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.ingredientId == item.id),
                        typedResults: items),
                  if (offersRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$IngredientsTableReferences._offersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$IngredientsTableReferences(db, table, p0)
                                .offersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.ingredientId == item.id),
                        typedResults: items),
                  if (planIngredientsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$IngredientsTableReferences
                            ._planIngredientsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$IngredientsTableReferences(db, table, p0)
                                .planIngredientsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.ingredientId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$IngredientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $IngredientsTable,
    Ingredient,
    $$IngredientsTableFilterComposer,
    $$IngredientsTableOrderingComposer,
    $$IngredientsTableAnnotationComposer,
    $$IngredientsTableCreateCompanionBuilder,
    $$IngredientsTableUpdateCompanionBuilder,
    (Ingredient, $$IngredientsTableReferences),
    Ingredient,
    PrefetchHooks Function(
        {bool recipeIngredientsRefs,
        bool offersRefs,
        bool planIngredientsRefs})>;
typedef $$RecipeIngredientsTableCreateCompanionBuilder
    = RecipeIngredientsCompanion Function({
  required int recipeId,
  required int ingredientId,
  required double quantityPerPerson,
  Value<String?> unit,
  Value<int> rowid,
});
typedef $$RecipeIngredientsTableUpdateCompanionBuilder
    = RecipeIngredientsCompanion Function({
  Value<int> recipeId,
  Value<int> ingredientId,
  Value<double> quantityPerPerson,
  Value<String?> unit,
  Value<int> rowid,
});

final class $$RecipeIngredientsTableReferences extends BaseReferences<
    _$AppDatabase, $RecipeIngredientsTable, RecipeIngredient> {
  $$RecipeIngredientsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias(
          $_aliasNameGenerator(db.recipeIngredients.recipeId, db.recipes.id));

  $$RecipesTableProcessedTableManager get recipeId {
    final manager = $$RecipesTableTableManager($_db, $_db.recipes)
        .filter((f) => f.id($_item.recipeId));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) =>
      db.ingredients.createAlias($_aliasNameGenerator(
          db.recipeIngredients.ingredientId, db.ingredients.id));

  $$IngredientsTableProcessedTableManager get ingredientId {
    final manager = $$IngredientsTableTableManager($_db, $_db.ingredients)
        .filter((f) => f.id($_item.ingredientId));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RecipeIngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get quantityPerPerson => $composableBuilder(
      column: $table.quantityPerPerson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableFilterComposer(
              $db: $db,
              $table: $db.recipes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableFilterComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecipeIngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get quantityPerPerson => $composableBuilder(
      column: $table.quantityPerPerson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableOrderingComposer(
              $db: $db,
              $table: $db.recipes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableOrderingComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecipeIngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get quantityPerPerson => $composableBuilder(
      column: $table.quantityPerPerson, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableAnnotationComposer(
              $db: $db,
              $table: $db.recipes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableAnnotationComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecipeIngredientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecipeIngredientsTable,
    RecipeIngredient,
    $$RecipeIngredientsTableFilterComposer,
    $$RecipeIngredientsTableOrderingComposer,
    $$RecipeIngredientsTableAnnotationComposer,
    $$RecipeIngredientsTableCreateCompanionBuilder,
    $$RecipeIngredientsTableUpdateCompanionBuilder,
    (RecipeIngredient, $$RecipeIngredientsTableReferences),
    RecipeIngredient,
    PrefetchHooks Function({bool recipeId, bool ingredientId})> {
  $$RecipeIngredientsTableTableManager(
      _$AppDatabase db, $RecipeIngredientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeIngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeIngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeIngredientsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> recipeId = const Value.absent(),
            Value<int> ingredientId = const Value.absent(),
            Value<double> quantityPerPerson = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipeIngredientsCompanion(
            recipeId: recipeId,
            ingredientId: ingredientId,
            quantityPerPerson: quantityPerPerson,
            unit: unit,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int recipeId,
            required int ingredientId,
            required double quantityPerPerson,
            Value<String?> unit = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipeIngredientsCompanion.insert(
            recipeId: recipeId,
            ingredientId: ingredientId,
            quantityPerPerson: quantityPerPerson,
            unit: unit,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RecipeIngredientsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({recipeId = false, ingredientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (recipeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.recipeId,
                    referencedTable:
                        $$RecipeIngredientsTableReferences._recipeIdTable(db),
                    referencedColumn: $$RecipeIngredientsTableReferences
                        ._recipeIdTable(db)
                        .id,
                  ) as T;
                }
                if (ingredientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ingredientId,
                    referencedTable: $$RecipeIngredientsTableReferences
                        ._ingredientIdTable(db),
                    referencedColumn: $$RecipeIngredientsTableReferences
                        ._ingredientIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RecipeIngredientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecipeIngredientsTable,
    RecipeIngredient,
    $$RecipeIngredientsTableFilterComposer,
    $$RecipeIngredientsTableOrderingComposer,
    $$RecipeIngredientsTableAnnotationComposer,
    $$RecipeIngredientsTableCreateCompanionBuilder,
    $$RecipeIngredientsTableUpdateCompanionBuilder,
    (RecipeIngredient, $$RecipeIngredientsTableReferences),
    RecipeIngredient,
    PrefetchHooks Function({bool recipeId, bool ingredientId})>;
typedef $$ContraindicationsTableCreateCompanionBuilder
    = ContraindicationsCompanion Function({
  Value<int> id,
  required String type,
  required String code,
  required String displayNameDe,
  required String displayNameEn,
  Value<String> excludedIngredientsJson,
  Value<String> excludedRiskTagsJson,
  Value<String> severity,
  Value<String?> warningTextDe,
  Value<String?> warningTextEn,
});
typedef $$ContraindicationsTableUpdateCompanionBuilder
    = ContraindicationsCompanion Function({
  Value<int> id,
  Value<String> type,
  Value<String> code,
  Value<String> displayNameDe,
  Value<String> displayNameEn,
  Value<String> excludedIngredientsJson,
  Value<String> excludedRiskTagsJson,
  Value<String> severity,
  Value<String?> warningTextDe,
  Value<String?> warningTextEn,
});

final class $$ContraindicationsTableReferences extends BaseReferences<
    _$AppDatabase, $ContraindicationsTable, Contraindication> {
  $$ContraindicationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UserContraindicationsTable,
      List<UserContraindication>> _userContraindicationsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.userContraindications,
          aliasName: $_aliasNameGenerator(db.contraindications.id,
              db.userContraindications.contraindicationId));

  $$UserContraindicationsTableProcessedTableManager
      get userContraindicationsRefs {
    final manager = $$UserContraindicationsTableTableManager(
            $_db, $_db.userContraindications)
        .filter((f) => f.contraindicationId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_userContraindicationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ContraindicationsTableFilterComposer
    extends Composer<_$AppDatabase, $ContraindicationsTable> {
  $$ContraindicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayNameDe => $composableBuilder(
      column: $table.displayNameDe, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayNameEn => $composableBuilder(
      column: $table.displayNameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get excludedIngredientsJson => $composableBuilder(
      column: $table.excludedIngredientsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get excludedRiskTagsJson => $composableBuilder(
      column: $table.excludedRiskTagsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get warningTextDe => $composableBuilder(
      column: $table.warningTextDe, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get warningTextEn => $composableBuilder(
      column: $table.warningTextEn, builder: (column) => ColumnFilters(column));

  Expression<bool> userContraindicationsRefs(
      Expression<bool> Function($$UserContraindicationsTableFilterComposer f)
          f) {
    final $$UserContraindicationsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.userContraindications,
            getReferencedColumn: (t) => t.contraindicationId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$UserContraindicationsTableFilterComposer(
                  $db: $db,
                  $table: $db.userContraindications,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ContraindicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContraindicationsTable> {
  $$ContraindicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayNameDe => $composableBuilder(
      column: $table.displayNameDe,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayNameEn => $composableBuilder(
      column: $table.displayNameEn,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get excludedIngredientsJson => $composableBuilder(
      column: $table.excludedIngredientsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get excludedRiskTagsJson => $composableBuilder(
      column: $table.excludedRiskTagsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get warningTextDe => $composableBuilder(
      column: $table.warningTextDe,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get warningTextEn => $composableBuilder(
      column: $table.warningTextEn,
      builder: (column) => ColumnOrderings(column));
}

class $$ContraindicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContraindicationsTable> {
  $$ContraindicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get displayNameDe => $composableBuilder(
      column: $table.displayNameDe, builder: (column) => column);

  GeneratedColumn<String> get displayNameEn => $composableBuilder(
      column: $table.displayNameEn, builder: (column) => column);

  GeneratedColumn<String> get excludedIngredientsJson => $composableBuilder(
      column: $table.excludedIngredientsJson, builder: (column) => column);

  GeneratedColumn<String> get excludedRiskTagsJson => $composableBuilder(
      column: $table.excludedRiskTagsJson, builder: (column) => column);

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get warningTextDe => $composableBuilder(
      column: $table.warningTextDe, builder: (column) => column);

  GeneratedColumn<String> get warningTextEn => $composableBuilder(
      column: $table.warningTextEn, builder: (column) => column);

  Expression<T> userContraindicationsRefs<T extends Object>(
      Expression<T> Function($$UserContraindicationsTableAnnotationComposer a)
          f) {
    final $$UserContraindicationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.userContraindications,
            getReferencedColumn: (t) => t.contraindicationId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$UserContraindicationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.userContraindications,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ContraindicationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ContraindicationsTable,
    Contraindication,
    $$ContraindicationsTableFilterComposer,
    $$ContraindicationsTableOrderingComposer,
    $$ContraindicationsTableAnnotationComposer,
    $$ContraindicationsTableCreateCompanionBuilder,
    $$ContraindicationsTableUpdateCompanionBuilder,
    (Contraindication, $$ContraindicationsTableReferences),
    Contraindication,
    PrefetchHooks Function({bool userContraindicationsRefs})> {
  $$ContraindicationsTableTableManager(
      _$AppDatabase db, $ContraindicationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContraindicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContraindicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContraindicationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> displayNameDe = const Value.absent(),
            Value<String> displayNameEn = const Value.absent(),
            Value<String> excludedIngredientsJson = const Value.absent(),
            Value<String> excludedRiskTagsJson = const Value.absent(),
            Value<String> severity = const Value.absent(),
            Value<String?> warningTextDe = const Value.absent(),
            Value<String?> warningTextEn = const Value.absent(),
          }) =>
              ContraindicationsCompanion(
            id: id,
            type: type,
            code: code,
            displayNameDe: displayNameDe,
            displayNameEn: displayNameEn,
            excludedIngredientsJson: excludedIngredientsJson,
            excludedRiskTagsJson: excludedRiskTagsJson,
            severity: severity,
            warningTextDe: warningTextDe,
            warningTextEn: warningTextEn,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String type,
            required String code,
            required String displayNameDe,
            required String displayNameEn,
            Value<String> excludedIngredientsJson = const Value.absent(),
            Value<String> excludedRiskTagsJson = const Value.absent(),
            Value<String> severity = const Value.absent(),
            Value<String?> warningTextDe = const Value.absent(),
            Value<String?> warningTextEn = const Value.absent(),
          }) =>
              ContraindicationsCompanion.insert(
            id: id,
            type: type,
            code: code,
            displayNameDe: displayNameDe,
            displayNameEn: displayNameEn,
            excludedIngredientsJson: excludedIngredientsJson,
            excludedRiskTagsJson: excludedRiskTagsJson,
            severity: severity,
            warningTextDe: warningTextDe,
            warningTextEn: warningTextEn,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ContraindicationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userContraindicationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (userContraindicationsRefs) db.userContraindications
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userContraindicationsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$ContraindicationsTableReferences
                            ._userContraindicationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ContraindicationsTableReferences(db, table, p0)
                                .userContraindicationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.contraindicationId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ContraindicationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ContraindicationsTable,
    Contraindication,
    $$ContraindicationsTableFilterComposer,
    $$ContraindicationsTableOrderingComposer,
    $$ContraindicationsTableAnnotationComposer,
    $$ContraindicationsTableCreateCompanionBuilder,
    $$ContraindicationsTableUpdateCompanionBuilder,
    (Contraindication, $$ContraindicationsTableReferences),
    Contraindication,
    PrefetchHooks Function({bool userContraindicationsRefs})>;
typedef $$UserContraindicationsTableCreateCompanionBuilder
    = UserContraindicationsCompanion Function({
  Value<int> id,
  required int contraindicationId,
  Value<String?> severityOverride,
  required DateTime addedAt,
});
typedef $$UserContraindicationsTableUpdateCompanionBuilder
    = UserContraindicationsCompanion Function({
  Value<int> id,
  Value<int> contraindicationId,
  Value<String?> severityOverride,
  Value<DateTime> addedAt,
});

final class $$UserContraindicationsTableReferences extends BaseReferences<
    _$AppDatabase, $UserContraindicationsTable, UserContraindication> {
  $$UserContraindicationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ContraindicationsTable _contraindicationIdTable(_$AppDatabase db) =>
      db.contraindications.createAlias($_aliasNameGenerator(
          db.userContraindications.contraindicationId,
          db.contraindications.id));

  $$ContraindicationsTableProcessedTableManager get contraindicationId {
    final manager =
        $$ContraindicationsTableTableManager($_db, $_db.contraindications)
            .filter((f) => f.id($_item.contraindicationId));
    final item = $_typedResult.readTableOrNull(_contraindicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$UserContraindicationsTableFilterComposer
    extends Composer<_$AppDatabase, $UserContraindicationsTable> {
  $$UserContraindicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get severityOverride => $composableBuilder(
      column: $table.severityOverride,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnFilters(column));

  $$ContraindicationsTableFilterComposer get contraindicationId {
    final $$ContraindicationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.contraindicationId,
        referencedTable: $db.contraindications,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ContraindicationsTableFilterComposer(
              $db: $db,
              $table: $db.contraindications,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UserContraindicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserContraindicationsTable> {
  $$UserContraindicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get severityOverride => $composableBuilder(
      column: $table.severityOverride,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnOrderings(column));

  $$ContraindicationsTableOrderingComposer get contraindicationId {
    final $$ContraindicationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.contraindicationId,
        referencedTable: $db.contraindications,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ContraindicationsTableOrderingComposer(
              $db: $db,
              $table: $db.contraindications,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UserContraindicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserContraindicationsTable> {
  $$UserContraindicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get severityOverride => $composableBuilder(
      column: $table.severityOverride, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  $$ContraindicationsTableAnnotationComposer get contraindicationId {
    final $$ContraindicationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.contraindicationId,
            referencedTable: $db.contraindications,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ContraindicationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.contraindications,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$UserContraindicationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserContraindicationsTable,
    UserContraindication,
    $$UserContraindicationsTableFilterComposer,
    $$UserContraindicationsTableOrderingComposer,
    $$UserContraindicationsTableAnnotationComposer,
    $$UserContraindicationsTableCreateCompanionBuilder,
    $$UserContraindicationsTableUpdateCompanionBuilder,
    (UserContraindication, $$UserContraindicationsTableReferences),
    UserContraindication,
    PrefetchHooks Function({bool contraindicationId})> {
  $$UserContraindicationsTableTableManager(
      _$AppDatabase db, $UserContraindicationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserContraindicationsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$UserContraindicationsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserContraindicationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> contraindicationId = const Value.absent(),
            Value<String?> severityOverride = const Value.absent(),
            Value<DateTime> addedAt = const Value.absent(),
          }) =>
              UserContraindicationsCompanion(
            id: id,
            contraindicationId: contraindicationId,
            severityOverride: severityOverride,
            addedAt: addedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int contraindicationId,
            Value<String?> severityOverride = const Value.absent(),
            required DateTime addedAt,
          }) =>
              UserContraindicationsCompanion.insert(
            id: id,
            contraindicationId: contraindicationId,
            severityOverride: severityOverride,
            addedAt: addedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$UserContraindicationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({contraindicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (contraindicationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.contraindicationId,
                    referencedTable: $$UserContraindicationsTableReferences
                        ._contraindicationIdTable(db),
                    referencedColumn: $$UserContraindicationsTableReferences
                        ._contraindicationIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$UserContraindicationsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $UserContraindicationsTable,
        UserContraindication,
        $$UserContraindicationsTableFilterComposer,
        $$UserContraindicationsTableOrderingComposer,
        $$UserContraindicationsTableAnnotationComposer,
        $$UserContraindicationsTableCreateCompanionBuilder,
        $$UserContraindicationsTableUpdateCompanionBuilder,
        (UserContraindication, $$UserContraindicationsTableReferences),
        UserContraindication,
        PrefetchHooks Function({bool contraindicationId})>;
typedef $$DiscountersTableCreateCompanionBuilder = DiscountersCompanion
    Function({
  Value<int> id,
  required String name,
  required String scraperClass,
  Value<bool> enabled,
  Value<String?> logoPath,
  Value<String?> apiType,
  Value<String?> apiBaseUrl,
  Value<String?> apiKeyEnv,
});
typedef $$DiscountersTableUpdateCompanionBuilder = DiscountersCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> scraperClass,
  Value<bool> enabled,
  Value<String?> logoPath,
  Value<String?> apiType,
  Value<String?> apiBaseUrl,
  Value<String?> apiKeyEnv,
});

final class $$DiscountersTableReferences
    extends BaseReferences<_$AppDatabase, $DiscountersTable, Discounter> {
  $$DiscountersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OffersTable, List<Offer>> _offersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.offers,
          aliasName:
              $_aliasNameGenerator(db.discounters.id, db.offers.discounterId));

  $$OffersTableProcessedTableManager get offersRefs {
    final manager = $$OffersTableTableManager($_db, $_db.offers)
        .filter((f) => f.discounterId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_offersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DiscountersTableFilterComposer
    extends Composer<_$AppDatabase, $DiscountersTable> {
  $$DiscountersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scraperClass => $composableBuilder(
      column: $table.scraperClass, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logoPath => $composableBuilder(
      column: $table.logoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get apiType => $composableBuilder(
      column: $table.apiType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get apiBaseUrl => $composableBuilder(
      column: $table.apiBaseUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get apiKeyEnv => $composableBuilder(
      column: $table.apiKeyEnv, builder: (column) => ColumnFilters(column));

  Expression<bool> offersRefs(
      Expression<bool> Function($$OffersTableFilterComposer f) f) {
    final $$OffersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.offers,
        getReferencedColumn: (t) => t.discounterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OffersTableFilterComposer(
              $db: $db,
              $table: $db.offers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DiscountersTableOrderingComposer
    extends Composer<_$AppDatabase, $DiscountersTable> {
  $$DiscountersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scraperClass => $composableBuilder(
      column: $table.scraperClass,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logoPath => $composableBuilder(
      column: $table.logoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get apiType => $composableBuilder(
      column: $table.apiType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get apiBaseUrl => $composableBuilder(
      column: $table.apiBaseUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get apiKeyEnv => $composableBuilder(
      column: $table.apiKeyEnv, builder: (column) => ColumnOrderings(column));
}

class $$DiscountersTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiscountersTable> {
  $$DiscountersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get scraperClass => $composableBuilder(
      column: $table.scraperClass, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<String> get apiType =>
      $composableBuilder(column: $table.apiType, builder: (column) => column);

  GeneratedColumn<String> get apiBaseUrl => $composableBuilder(
      column: $table.apiBaseUrl, builder: (column) => column);

  GeneratedColumn<String> get apiKeyEnv =>
      $composableBuilder(column: $table.apiKeyEnv, builder: (column) => column);

  Expression<T> offersRefs<T extends Object>(
      Expression<T> Function($$OffersTableAnnotationComposer a) f) {
    final $$OffersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.offers,
        getReferencedColumn: (t) => t.discounterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OffersTableAnnotationComposer(
              $db: $db,
              $table: $db.offers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DiscountersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DiscountersTable,
    Discounter,
    $$DiscountersTableFilterComposer,
    $$DiscountersTableOrderingComposer,
    $$DiscountersTableAnnotationComposer,
    $$DiscountersTableCreateCompanionBuilder,
    $$DiscountersTableUpdateCompanionBuilder,
    (Discounter, $$DiscountersTableReferences),
    Discounter,
    PrefetchHooks Function({bool offersRefs})> {
  $$DiscountersTableTableManager(_$AppDatabase db, $DiscountersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiscountersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiscountersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiscountersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> scraperClass = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            Value<String?> apiType = const Value.absent(),
            Value<String?> apiBaseUrl = const Value.absent(),
            Value<String?> apiKeyEnv = const Value.absent(),
          }) =>
              DiscountersCompanion(
            id: id,
            name: name,
            scraperClass: scraperClass,
            enabled: enabled,
            logoPath: logoPath,
            apiType: apiType,
            apiBaseUrl: apiBaseUrl,
            apiKeyEnv: apiKeyEnv,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String scraperClass,
            Value<bool> enabled = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            Value<String?> apiType = const Value.absent(),
            Value<String?> apiBaseUrl = const Value.absent(),
            Value<String?> apiKeyEnv = const Value.absent(),
          }) =>
              DiscountersCompanion.insert(
            id: id,
            name: name,
            scraperClass: scraperClass,
            enabled: enabled,
            logoPath: logoPath,
            apiType: apiType,
            apiBaseUrl: apiBaseUrl,
            apiKeyEnv: apiKeyEnv,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DiscountersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({offersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (offersRefs) db.offers],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (offersRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$DiscountersTableReferences._offersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DiscountersTableReferences(db, table, p0)
                                .offersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.discounterId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DiscountersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DiscountersTable,
    Discounter,
    $$DiscountersTableFilterComposer,
    $$DiscountersTableOrderingComposer,
    $$DiscountersTableAnnotationComposer,
    $$DiscountersTableCreateCompanionBuilder,
    $$DiscountersTableUpdateCompanionBuilder,
    (Discounter, $$DiscountersTableReferences),
    Discounter,
    PrefetchHooks Function({bool offersRefs})>;
typedef $$OffersTableCreateCompanionBuilder = OffersCompanion Function({
  Value<int> id,
  required int discounterId,
  Value<int?> ingredientId,
  required String rawName,
  required double price,
  Value<String?> unitText,
  required DateTime validFrom,
  required DateTime validTo,
  required DateTime fetchedAt,
  Value<String?> sourceUrl,
});
typedef $$OffersTableUpdateCompanionBuilder = OffersCompanion Function({
  Value<int> id,
  Value<int> discounterId,
  Value<int?> ingredientId,
  Value<String> rawName,
  Value<double> price,
  Value<String?> unitText,
  Value<DateTime> validFrom,
  Value<DateTime> validTo,
  Value<DateTime> fetchedAt,
  Value<String?> sourceUrl,
});

final class $$OffersTableReferences
    extends BaseReferences<_$AppDatabase, $OffersTable, Offer> {
  $$OffersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DiscountersTable _discounterIdTable(_$AppDatabase db) =>
      db.discounters.createAlias(
          $_aliasNameGenerator(db.offers.discounterId, db.discounters.id));

  $$DiscountersTableProcessedTableManager get discounterId {
    final manager = $$DiscountersTableTableManager($_db, $_db.discounters)
        .filter((f) => f.id($_item.discounterId));
    final item = $_typedResult.readTableOrNull(_discounterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) =>
      db.ingredients.createAlias(
          $_aliasNameGenerator(db.offers.ingredientId, db.ingredients.id));

  $$IngredientsTableProcessedTableManager? get ingredientId {
    if ($_item.ingredientId == null) return null;
    final manager = $$IngredientsTableTableManager($_db, $_db.ingredients)
        .filter((f) => f.id($_item.ingredientId!));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PlanIngredientsTable, List<PlanIngredient>>
      _planIngredientsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.planIngredients,
              aliasName: $_aliasNameGenerator(
                  db.offers.id, db.planIngredients.offerId));

  $$PlanIngredientsTableProcessedTableManager get planIngredientsRefs {
    final manager =
        $$PlanIngredientsTableTableManager($_db, $_db.planIngredients)
            .filter((f) => f.offerId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_planIngredientsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$OffersTableFilterComposer
    extends Composer<_$AppDatabase, $OffersTable> {
  $$OffersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rawName => $composableBuilder(
      column: $table.rawName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitText => $composableBuilder(
      column: $table.unitText, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get validFrom => $composableBuilder(
      column: $table.validFrom, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get validTo => $composableBuilder(
      column: $table.validTo, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceUrl => $composableBuilder(
      column: $table.sourceUrl, builder: (column) => ColumnFilters(column));

  $$DiscountersTableFilterComposer get discounterId {
    final $$DiscountersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.discounterId,
        referencedTable: $db.discounters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiscountersTableFilterComposer(
              $db: $db,
              $table: $db.discounters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableFilterComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> planIngredientsRefs(
      Expression<bool> Function($$PlanIngredientsTableFilterComposer f) f) {
    final $$PlanIngredientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.planIngredients,
        getReferencedColumn: (t) => t.offerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlanIngredientsTableFilterComposer(
              $db: $db,
              $table: $db.planIngredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OffersTableOrderingComposer
    extends Composer<_$AppDatabase, $OffersTable> {
  $$OffersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rawName => $composableBuilder(
      column: $table.rawName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitText => $composableBuilder(
      column: $table.unitText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get validFrom => $composableBuilder(
      column: $table.validFrom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get validTo => $composableBuilder(
      column: $table.validTo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
      column: $table.sourceUrl, builder: (column) => ColumnOrderings(column));

  $$DiscountersTableOrderingComposer get discounterId {
    final $$DiscountersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.discounterId,
        referencedTable: $db.discounters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiscountersTableOrderingComposer(
              $db: $db,
              $table: $db.discounters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableOrderingComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OffersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OffersTable> {
  $$OffersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rawName =>
      $composableBuilder(column: $table.rawName, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get unitText =>
      $composableBuilder(column: $table.unitText, builder: (column) => column);

  GeneratedColumn<DateTime> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<DateTime> get validTo =>
      $composableBuilder(column: $table.validTo, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  $$DiscountersTableAnnotationComposer get discounterId {
    final $$DiscountersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.discounterId,
        referencedTable: $db.discounters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiscountersTableAnnotationComposer(
              $db: $db,
              $table: $db.discounters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableAnnotationComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> planIngredientsRefs<T extends Object>(
      Expression<T> Function($$PlanIngredientsTableAnnotationComposer a) f) {
    final $$PlanIngredientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.planIngredients,
        getReferencedColumn: (t) => t.offerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlanIngredientsTableAnnotationComposer(
              $db: $db,
              $table: $db.planIngredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OffersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OffersTable,
    Offer,
    $$OffersTableFilterComposer,
    $$OffersTableOrderingComposer,
    $$OffersTableAnnotationComposer,
    $$OffersTableCreateCompanionBuilder,
    $$OffersTableUpdateCompanionBuilder,
    (Offer, $$OffersTableReferences),
    Offer,
    PrefetchHooks Function(
        {bool discounterId, bool ingredientId, bool planIngredientsRefs})> {
  $$OffersTableTableManager(_$AppDatabase db, $OffersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OffersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OffersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OffersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> discounterId = const Value.absent(),
            Value<int?> ingredientId = const Value.absent(),
            Value<String> rawName = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String?> unitText = const Value.absent(),
            Value<DateTime> validFrom = const Value.absent(),
            Value<DateTime> validTo = const Value.absent(),
            Value<DateTime> fetchedAt = const Value.absent(),
            Value<String?> sourceUrl = const Value.absent(),
          }) =>
              OffersCompanion(
            id: id,
            discounterId: discounterId,
            ingredientId: ingredientId,
            rawName: rawName,
            price: price,
            unitText: unitText,
            validFrom: validFrom,
            validTo: validTo,
            fetchedAt: fetchedAt,
            sourceUrl: sourceUrl,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int discounterId,
            Value<int?> ingredientId = const Value.absent(),
            required String rawName,
            required double price,
            Value<String?> unitText = const Value.absent(),
            required DateTime validFrom,
            required DateTime validTo,
            required DateTime fetchedAt,
            Value<String?> sourceUrl = const Value.absent(),
          }) =>
              OffersCompanion.insert(
            id: id,
            discounterId: discounterId,
            ingredientId: ingredientId,
            rawName: rawName,
            price: price,
            unitText: unitText,
            validFrom: validFrom,
            validTo: validTo,
            fetchedAt: fetchedAt,
            sourceUrl: sourceUrl,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$OffersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {discounterId = false,
              ingredientId = false,
              planIngredientsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (planIngredientsRefs) db.planIngredients
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (discounterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.discounterId,
                    referencedTable:
                        $$OffersTableReferences._discounterIdTable(db),
                    referencedColumn:
                        $$OffersTableReferences._discounterIdTable(db).id,
                  ) as T;
                }
                if (ingredientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ingredientId,
                    referencedTable:
                        $$OffersTableReferences._ingredientIdTable(db),
                    referencedColumn:
                        $$OffersTableReferences._ingredientIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (planIngredientsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$OffersTableReferences
                            ._planIngredientsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OffersTableReferences(db, table, p0)
                                .planIngredientsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.offerId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$OffersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OffersTable,
    Offer,
    $$OffersTableFilterComposer,
    $$OffersTableOrderingComposer,
    $$OffersTableAnnotationComposer,
    $$OffersTableCreateCompanionBuilder,
    $$OffersTableUpdateCompanionBuilder,
    (Offer, $$OffersTableReferences),
    Offer,
    PrefetchHooks Function(
        {bool discounterId, bool ingredientId, bool planIngredientsRefs})>;
typedef $$WeeklyPlansTableCreateCompanionBuilder = WeeklyPlansCompanion
    Function({
  Value<int> id,
  required DateTime weekStart,
  Value<int> persons,
  Value<String> status,
  required DateTime createdAt,
});
typedef $$WeeklyPlansTableUpdateCompanionBuilder = WeeklyPlansCompanion
    Function({
  Value<int> id,
  Value<DateTime> weekStart,
  Value<int> persons,
  Value<String> status,
  Value<DateTime> createdAt,
});

final class $$WeeklyPlansTableReferences
    extends BaseReferences<_$AppDatabase, $WeeklyPlansTable, WeeklyPlan> {
  $$WeeklyPlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlanMealsTable, List<PlanMeal>>
      _planMealsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.planMeals,
              aliasName:
                  $_aliasNameGenerator(db.weeklyPlans.id, db.planMeals.planId));

  $$PlanMealsTableProcessedTableManager get planMealsRefs {
    final manager = $$PlanMealsTableTableManager($_db, $_db.planMeals)
        .filter((f) => f.planId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_planMealsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PlanIngredientsTable, List<PlanIngredient>>
      _planIngredientsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.planIngredients,
              aliasName: $_aliasNameGenerator(
                  db.weeklyPlans.id, db.planIngredients.planId));

  $$PlanIngredientsTableProcessedTableManager get planIngredientsRefs {
    final manager =
        $$PlanIngredientsTableTableManager($_db, $_db.planIngredients)
            .filter((f) => f.planId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_planIngredientsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WeeklyPlansTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyPlansTable> {
  $$WeeklyPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get weekStart => $composableBuilder(
      column: $table.weekStart, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get persons => $composableBuilder(
      column: $table.persons, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> planMealsRefs(
      Expression<bool> Function($$PlanMealsTableFilterComposer f) f) {
    final $$PlanMealsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.planMeals,
        getReferencedColumn: (t) => t.planId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlanMealsTableFilterComposer(
              $db: $db,
              $table: $db.planMeals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> planIngredientsRefs(
      Expression<bool> Function($$PlanIngredientsTableFilterComposer f) f) {
    final $$PlanIngredientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.planIngredients,
        getReferencedColumn: (t) => t.planId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlanIngredientsTableFilterComposer(
              $db: $db,
              $table: $db.planIngredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WeeklyPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyPlansTable> {
  $$WeeklyPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get weekStart => $composableBuilder(
      column: $table.weekStart, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get persons => $composableBuilder(
      column: $table.persons, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$WeeklyPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyPlansTable> {
  $$WeeklyPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get weekStart =>
      $composableBuilder(column: $table.weekStart, builder: (column) => column);

  GeneratedColumn<int> get persons =>
      $composableBuilder(column: $table.persons, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> planMealsRefs<T extends Object>(
      Expression<T> Function($$PlanMealsTableAnnotationComposer a) f) {
    final $$PlanMealsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.planMeals,
        getReferencedColumn: (t) => t.planId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlanMealsTableAnnotationComposer(
              $db: $db,
              $table: $db.planMeals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> planIngredientsRefs<T extends Object>(
      Expression<T> Function($$PlanIngredientsTableAnnotationComposer a) f) {
    final $$PlanIngredientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.planIngredients,
        getReferencedColumn: (t) => t.planId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlanIngredientsTableAnnotationComposer(
              $db: $db,
              $table: $db.planIngredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WeeklyPlansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WeeklyPlansTable,
    WeeklyPlan,
    $$WeeklyPlansTableFilterComposer,
    $$WeeklyPlansTableOrderingComposer,
    $$WeeklyPlansTableAnnotationComposer,
    $$WeeklyPlansTableCreateCompanionBuilder,
    $$WeeklyPlansTableUpdateCompanionBuilder,
    (WeeklyPlan, $$WeeklyPlansTableReferences),
    WeeklyPlan,
    PrefetchHooks Function({bool planMealsRefs, bool planIngredientsRefs})> {
  $$WeeklyPlansTableTableManager(_$AppDatabase db, $WeeklyPlansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeeklyPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> weekStart = const Value.absent(),
            Value<int> persons = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              WeeklyPlansCompanion(
            id: id,
            weekStart: weekStart,
            persons: persons,
            status: status,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime weekStart,
            Value<int> persons = const Value.absent(),
            Value<String> status = const Value.absent(),
            required DateTime createdAt,
          }) =>
              WeeklyPlansCompanion.insert(
            id: id,
            weekStart: weekStart,
            persons: persons,
            status: status,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WeeklyPlansTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {planMealsRefs = false, planIngredientsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (planMealsRefs) db.planMeals,
                if (planIngredientsRefs) db.planIngredients
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (planMealsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$WeeklyPlansTableReferences
                            ._planMealsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WeeklyPlansTableReferences(db, table, p0)
                                .planMealsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.planId == item.id),
                        typedResults: items),
                  if (planIngredientsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$WeeklyPlansTableReferences
                            ._planIngredientsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WeeklyPlansTableReferences(db, table, p0)
                                .planIngredientsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.planId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WeeklyPlansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WeeklyPlansTable,
    WeeklyPlan,
    $$WeeklyPlansTableFilterComposer,
    $$WeeklyPlansTableOrderingComposer,
    $$WeeklyPlansTableAnnotationComposer,
    $$WeeklyPlansTableCreateCompanionBuilder,
    $$WeeklyPlansTableUpdateCompanionBuilder,
    (WeeklyPlan, $$WeeklyPlansTableReferences),
    WeeklyPlan,
    PrefetchHooks Function({bool planMealsRefs, bool planIngredientsRefs})>;
typedef $$PlanMealsTableCreateCompanionBuilder = PlanMealsCompanion Function({
  Value<int> id,
  required int planId,
  required DateTime date,
  required String mealType,
  Value<int?> recipeId,
  Value<String?> customName,
  Value<int> serves,
});
typedef $$PlanMealsTableUpdateCompanionBuilder = PlanMealsCompanion Function({
  Value<int> id,
  Value<int> planId,
  Value<DateTime> date,
  Value<String> mealType,
  Value<int?> recipeId,
  Value<String?> customName,
  Value<int> serves,
});

final class $$PlanMealsTableReferences
    extends BaseReferences<_$AppDatabase, $PlanMealsTable, PlanMeal> {
  $$PlanMealsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WeeklyPlansTable _planIdTable(_$AppDatabase db) =>
      db.weeklyPlans.createAlias(
          $_aliasNameGenerator(db.planMeals.planId, db.weeklyPlans.id));

  $$WeeklyPlansTableProcessedTableManager get planId {
    final manager = $$WeeklyPlansTableTableManager($_db, $_db.weeklyPlans)
        .filter((f) => f.id($_item.planId));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $RecipesTable _recipeIdTable(_$AppDatabase db) => db.recipes
      .createAlias($_aliasNameGenerator(db.planMeals.recipeId, db.recipes.id));

  $$RecipesTableProcessedTableManager? get recipeId {
    if ($_item.recipeId == null) return null;
    final manager = $$RecipesTableTableManager($_db, $_db.recipes)
        .filter((f) => f.id($_item.recipeId!));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PlanMealsTableFilterComposer
    extends Composer<_$AppDatabase, $PlanMealsTable> {
  $$PlanMealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customName => $composableBuilder(
      column: $table.customName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serves => $composableBuilder(
      column: $table.serves, builder: (column) => ColumnFilters(column));

  $$WeeklyPlansTableFilterComposer get planId {
    final $$WeeklyPlansTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.planId,
        referencedTable: $db.weeklyPlans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WeeklyPlansTableFilterComposer(
              $db: $db,
              $table: $db.weeklyPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableFilterComposer(
              $db: $db,
              $table: $db.recipes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlanMealsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanMealsTable> {
  $$PlanMealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customName => $composableBuilder(
      column: $table.customName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serves => $composableBuilder(
      column: $table.serves, builder: (column) => ColumnOrderings(column));

  $$WeeklyPlansTableOrderingComposer get planId {
    final $$WeeklyPlansTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.planId,
        referencedTable: $db.weeklyPlans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WeeklyPlansTableOrderingComposer(
              $db: $db,
              $table: $db.weeklyPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableOrderingComposer(
              $db: $db,
              $table: $db.recipes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlanMealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanMealsTable> {
  $$PlanMealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<String> get customName => $composableBuilder(
      column: $table.customName, builder: (column) => column);

  GeneratedColumn<int> get serves =>
      $composableBuilder(column: $table.serves, builder: (column) => column);

  $$WeeklyPlansTableAnnotationComposer get planId {
    final $$WeeklyPlansTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.planId,
        referencedTable: $db.weeklyPlans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WeeklyPlansTableAnnotationComposer(
              $db: $db,
              $table: $db.weeklyPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableAnnotationComposer(
              $db: $db,
              $table: $db.recipes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlanMealsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlanMealsTable,
    PlanMeal,
    $$PlanMealsTableFilterComposer,
    $$PlanMealsTableOrderingComposer,
    $$PlanMealsTableAnnotationComposer,
    $$PlanMealsTableCreateCompanionBuilder,
    $$PlanMealsTableUpdateCompanionBuilder,
    (PlanMeal, $$PlanMealsTableReferences),
    PlanMeal,
    PrefetchHooks Function({bool planId, bool recipeId})> {
  $$PlanMealsTableTableManager(_$AppDatabase db, $PlanMealsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanMealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanMealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanMealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> planId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> mealType = const Value.absent(),
            Value<int?> recipeId = const Value.absent(),
            Value<String?> customName = const Value.absent(),
            Value<int> serves = const Value.absent(),
          }) =>
              PlanMealsCompanion(
            id: id,
            planId: planId,
            date: date,
            mealType: mealType,
            recipeId: recipeId,
            customName: customName,
            serves: serves,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int planId,
            required DateTime date,
            required String mealType,
            Value<int?> recipeId = const Value.absent(),
            Value<String?> customName = const Value.absent(),
            Value<int> serves = const Value.absent(),
          }) =>
              PlanMealsCompanion.insert(
            id: id,
            planId: planId,
            date: date,
            mealType: mealType,
            recipeId: recipeId,
            customName: customName,
            serves: serves,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PlanMealsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({planId = false, recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (planId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.planId,
                    referencedTable:
                        $$PlanMealsTableReferences._planIdTable(db),
                    referencedColumn:
                        $$PlanMealsTableReferences._planIdTable(db).id,
                  ) as T;
                }
                if (recipeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.recipeId,
                    referencedTable:
                        $$PlanMealsTableReferences._recipeIdTable(db),
                    referencedColumn:
                        $$PlanMealsTableReferences._recipeIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PlanMealsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlanMealsTable,
    PlanMeal,
    $$PlanMealsTableFilterComposer,
    $$PlanMealsTableOrderingComposer,
    $$PlanMealsTableAnnotationComposer,
    $$PlanMealsTableCreateCompanionBuilder,
    $$PlanMealsTableUpdateCompanionBuilder,
    (PlanMeal, $$PlanMealsTableReferences),
    PlanMeal,
    PrefetchHooks Function({bool planId, bool recipeId})>;
typedef $$PlanIngredientsTableCreateCompanionBuilder = PlanIngredientsCompanion
    Function({
  Value<int> id,
  required int planId,
  required int ingredientId,
  required double totalQuantity,
  Value<String?> unit,
  Value<int?> offerId,
});
typedef $$PlanIngredientsTableUpdateCompanionBuilder = PlanIngredientsCompanion
    Function({
  Value<int> id,
  Value<int> planId,
  Value<int> ingredientId,
  Value<double> totalQuantity,
  Value<String?> unit,
  Value<int?> offerId,
});

final class $$PlanIngredientsTableReferences extends BaseReferences<
    _$AppDatabase, $PlanIngredientsTable, PlanIngredient> {
  $$PlanIngredientsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $WeeklyPlansTable _planIdTable(_$AppDatabase db) =>
      db.weeklyPlans.createAlias(
          $_aliasNameGenerator(db.planIngredients.planId, db.weeklyPlans.id));

  $$WeeklyPlansTableProcessedTableManager get planId {
    final manager = $$WeeklyPlansTableTableManager($_db, $_db.weeklyPlans)
        .filter((f) => f.id($_item.planId));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) =>
      db.ingredients.createAlias($_aliasNameGenerator(
          db.planIngredients.ingredientId, db.ingredients.id));

  $$IngredientsTableProcessedTableManager get ingredientId {
    final manager = $$IngredientsTableTableManager($_db, $_db.ingredients)
        .filter((f) => f.id($_item.ingredientId));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $OffersTable _offerIdTable(_$AppDatabase db) => db.offers.createAlias(
      $_aliasNameGenerator(db.planIngredients.offerId, db.offers.id));

  $$OffersTableProcessedTableManager? get offerId {
    if ($_item.offerId == null) return null;
    final manager = $$OffersTableTableManager($_db, $_db.offers)
        .filter((f) => f.id($_item.offerId!));
    final item = $_typedResult.readTableOrNull(_offerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PlanIngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $PlanIngredientsTable> {
  $$PlanIngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalQuantity => $composableBuilder(
      column: $table.totalQuantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  $$WeeklyPlansTableFilterComposer get planId {
    final $$WeeklyPlansTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.planId,
        referencedTable: $db.weeklyPlans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WeeklyPlansTableFilterComposer(
              $db: $db,
              $table: $db.weeklyPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableFilterComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$OffersTableFilterComposer get offerId {
    final $$OffersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.offerId,
        referencedTable: $db.offers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OffersTableFilterComposer(
              $db: $db,
              $table: $db.offers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlanIngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanIngredientsTable> {
  $$PlanIngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalQuantity => $composableBuilder(
      column: $table.totalQuantity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  $$WeeklyPlansTableOrderingComposer get planId {
    final $$WeeklyPlansTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.planId,
        referencedTable: $db.weeklyPlans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WeeklyPlansTableOrderingComposer(
              $db: $db,
              $table: $db.weeklyPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableOrderingComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$OffersTableOrderingComposer get offerId {
    final $$OffersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.offerId,
        referencedTable: $db.offers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OffersTableOrderingComposer(
              $db: $db,
              $table: $db.offers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlanIngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanIngredientsTable> {
  $$PlanIngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get totalQuantity => $composableBuilder(
      column: $table.totalQuantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  $$WeeklyPlansTableAnnotationComposer get planId {
    final $$WeeklyPlansTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.planId,
        referencedTable: $db.weeklyPlans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WeeklyPlansTableAnnotationComposer(
              $db: $db,
              $table: $db.weeklyPlans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ingredientId,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableAnnotationComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$OffersTableAnnotationComposer get offerId {
    final $$OffersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.offerId,
        referencedTable: $db.offers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OffersTableAnnotationComposer(
              $db: $db,
              $table: $db.offers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlanIngredientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlanIngredientsTable,
    PlanIngredient,
    $$PlanIngredientsTableFilterComposer,
    $$PlanIngredientsTableOrderingComposer,
    $$PlanIngredientsTableAnnotationComposer,
    $$PlanIngredientsTableCreateCompanionBuilder,
    $$PlanIngredientsTableUpdateCompanionBuilder,
    (PlanIngredient, $$PlanIngredientsTableReferences),
    PlanIngredient,
    PrefetchHooks Function({bool planId, bool ingredientId, bool offerId})> {
  $$PlanIngredientsTableTableManager(
      _$AppDatabase db, $PlanIngredientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanIngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanIngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanIngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> planId = const Value.absent(),
            Value<int> ingredientId = const Value.absent(),
            Value<double> totalQuantity = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<int?> offerId = const Value.absent(),
          }) =>
              PlanIngredientsCompanion(
            id: id,
            planId: planId,
            ingredientId: ingredientId,
            totalQuantity: totalQuantity,
            unit: unit,
            offerId: offerId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int planId,
            required int ingredientId,
            required double totalQuantity,
            Value<String?> unit = const Value.absent(),
            Value<int?> offerId = const Value.absent(),
          }) =>
              PlanIngredientsCompanion.insert(
            id: id,
            planId: planId,
            ingredientId: ingredientId,
            totalQuantity: totalQuantity,
            unit: unit,
            offerId: offerId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PlanIngredientsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {planId = false, ingredientId = false, offerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (planId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.planId,
                    referencedTable:
                        $$PlanIngredientsTableReferences._planIdTable(db),
                    referencedColumn:
                        $$PlanIngredientsTableReferences._planIdTable(db).id,
                  ) as T;
                }
                if (ingredientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ingredientId,
                    referencedTable:
                        $$PlanIngredientsTableReferences._ingredientIdTable(db),
                    referencedColumn: $$PlanIngredientsTableReferences
                        ._ingredientIdTable(db)
                        .id,
                  ) as T;
                }
                if (offerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.offerId,
                    referencedTable:
                        $$PlanIngredientsTableReferences._offerIdTable(db),
                    referencedColumn:
                        $$PlanIngredientsTableReferences._offerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PlanIngredientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlanIngredientsTable,
    PlanIngredient,
    $$PlanIngredientsTableFilterComposer,
    $$PlanIngredientsTableOrderingComposer,
    $$PlanIngredientsTableAnnotationComposer,
    $$PlanIngredientsTableCreateCompanionBuilder,
    $$PlanIngredientsTableUpdateCompanionBuilder,
    (PlanIngredient, $$PlanIngredientsTableReferences),
    PlanIngredient,
    PrefetchHooks Function({bool planId, bool ingredientId, bool offerId})>;
typedef $$UserProfileTableCreateCompanionBuilder = UserProfileCompanion
    Function({
  Value<int> id,
  Value<int> persons,
  Value<String?> zipCode,
  Value<String> selectedDiscountersJson,
  Value<bool> weeklyPlanAuto,
  Value<int> planDow,
  Value<bool> marktguruEnabled,
});
typedef $$UserProfileTableUpdateCompanionBuilder = UserProfileCompanion
    Function({
  Value<int> id,
  Value<int> persons,
  Value<String?> zipCode,
  Value<String> selectedDiscountersJson,
  Value<bool> weeklyPlanAuto,
  Value<int> planDow,
  Value<bool> marktguruEnabled,
});

class $$UserProfileTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get persons => $composableBuilder(
      column: $table.persons, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get zipCode => $composableBuilder(
      column: $table.zipCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get selectedDiscountersJson => $composableBuilder(
      column: $table.selectedDiscountersJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get weeklyPlanAuto => $composableBuilder(
      column: $table.weeklyPlanAuto,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get planDow => $composableBuilder(
      column: $table.planDow, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get marktguruEnabled => $composableBuilder(
      column: $table.marktguruEnabled,
      builder: (column) => ColumnFilters(column));
}

class $$UserProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get persons => $composableBuilder(
      column: $table.persons, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get zipCode => $composableBuilder(
      column: $table.zipCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get selectedDiscountersJson => $composableBuilder(
      column: $table.selectedDiscountersJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get weeklyPlanAuto => $composableBuilder(
      column: $table.weeklyPlanAuto,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get planDow => $composableBuilder(
      column: $table.planDow, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get marktguruEnabled => $composableBuilder(
      column: $table.marktguruEnabled,
      builder: (column) => ColumnOrderings(column));
}

class $$UserProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get persons =>
      $composableBuilder(column: $table.persons, builder: (column) => column);

  GeneratedColumn<String> get zipCode =>
      $composableBuilder(column: $table.zipCode, builder: (column) => column);

  GeneratedColumn<String> get selectedDiscountersJson => $composableBuilder(
      column: $table.selectedDiscountersJson, builder: (column) => column);

  GeneratedColumn<bool> get weeklyPlanAuto => $composableBuilder(
      column: $table.weeklyPlanAuto, builder: (column) => column);

  GeneratedColumn<int> get planDow =>
      $composableBuilder(column: $table.planDow, builder: (column) => column);

  GeneratedColumn<bool> get marktguruEnabled => $composableBuilder(
      column: $table.marktguruEnabled, builder: (column) => column);
}

class $$UserProfileTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProfileTable,
    UserProfileData,
    $$UserProfileTableFilterComposer,
    $$UserProfileTableOrderingComposer,
    $$UserProfileTableAnnotationComposer,
    $$UserProfileTableCreateCompanionBuilder,
    $$UserProfileTableUpdateCompanionBuilder,
    (
      UserProfileData,
      BaseReferences<_$AppDatabase, $UserProfileTable, UserProfileData>
    ),
    UserProfileData,
    PrefetchHooks Function()> {
  $$UserProfileTableTableManager(_$AppDatabase db, $UserProfileTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> persons = const Value.absent(),
            Value<String?> zipCode = const Value.absent(),
            Value<String> selectedDiscountersJson = const Value.absent(),
            Value<bool> weeklyPlanAuto = const Value.absent(),
            Value<int> planDow = const Value.absent(),
            Value<bool> marktguruEnabled = const Value.absent(),
          }) =>
              UserProfileCompanion(
            id: id,
            persons: persons,
            zipCode: zipCode,
            selectedDiscountersJson: selectedDiscountersJson,
            weeklyPlanAuto: weeklyPlanAuto,
            planDow: planDow,
            marktguruEnabled: marktguruEnabled,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> persons = const Value.absent(),
            Value<String?> zipCode = const Value.absent(),
            Value<String> selectedDiscountersJson = const Value.absent(),
            Value<bool> weeklyPlanAuto = const Value.absent(),
            Value<int> planDow = const Value.absent(),
            Value<bool> marktguruEnabled = const Value.absent(),
          }) =>
              UserProfileCompanion.insert(
            id: id,
            persons: persons,
            zipCode: zipCode,
            selectedDiscountersJson: selectedDiscountersJson,
            weeklyPlanAuto: weeklyPlanAuto,
            planDow: planDow,
            marktguruEnabled: marktguruEnabled,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserProfileTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProfileTable,
    UserProfileData,
    $$UserProfileTableFilterComposer,
    $$UserProfileTableOrderingComposer,
    $$UserProfileTableAnnotationComposer,
    $$UserProfileTableCreateCompanionBuilder,
    $$UserProfileTableUpdateCompanionBuilder,
    (
      UserProfileData,
      BaseReferences<_$AppDatabase, $UserProfileTable, UserProfileData>
    ),
    UserProfileData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$ShoppingItemsTableTableManager get shoppingItems =>
      $$ShoppingItemsTableTableManager(_db, _db.shoppingItems);
  $$FoodLogTableTableManager get foodLog =>
      $$FoodLogTableTableManager(_db, _db.foodLog);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db, _db.ingredients);
  $$RecipeIngredientsTableTableManager get recipeIngredients =>
      $$RecipeIngredientsTableTableManager(_db, _db.recipeIngredients);
  $$ContraindicationsTableTableManager get contraindications =>
      $$ContraindicationsTableTableManager(_db, _db.contraindications);
  $$UserContraindicationsTableTableManager get userContraindications =>
      $$UserContraindicationsTableTableManager(_db, _db.userContraindications);
  $$DiscountersTableTableManager get discounters =>
      $$DiscountersTableTableManager(_db, _db.discounters);
  $$OffersTableTableManager get offers =>
      $$OffersTableTableManager(_db, _db.offers);
  $$WeeklyPlansTableTableManager get weeklyPlans =>
      $$WeeklyPlansTableTableManager(_db, _db.weeklyPlans);
  $$PlanMealsTableTableManager get planMeals =>
      $$PlanMealsTableTableManager(_db, _db.planMeals);
  $$PlanIngredientsTableTableManager get planIngredients =>
      $$PlanIngredientsTableTableManager(_db, _db.planIngredients);
  $$UserProfileTableTableManager get userProfile =>
      $$UserProfileTableTableManager(_db, _db.userProfile);
}
