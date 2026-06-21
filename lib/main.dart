import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'database/database.dart';

void main() {
  runApp(const KitchenCompanionApp());
}

class KitchenCompanionApp extends StatefulWidget {
  const KitchenCompanionApp({super.key});

  @override
  State<KitchenCompanionApp> createState() => _KitchenCompanionAppState();
}

class _KitchenCompanionAppState extends State<KitchenCompanionApp> {
  late final AppDatabase _db;
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _db.ensureSettingsExist();
      // P1-FIX: mounted-Check nach jedem await — verhindert setState auf disposed Widget
      if (!mounted) return;
      final settings = await _db.getSettings();
      if (!mounted) return;
      if (settings != null) {
        setState(() {
          _themeMode = _themeModeFromString(settings.theme);
        });
      }
    } catch (e) {
      // P0-FIX: Fehler nicht schlucken — bei DB-Init-Fehler auf System-Theme fallback
      debugPrint('Failed to initialize app: $e');
    }
  }

  @override
  void dispose() {
    // P0-FIX: Korrekte Reihenfolge — DB schließen, dann super.dispose()
    _db.close();
    super.dispose();
  }

  ThemeMode _themeModeFromString(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kitchen Companion',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // P0-FIX: Nur Locales deklarieren, für die ARB-Dateien existieren
      supportedLocales: const [
        Locale('de'),
        Locale('en'),
      ],
      home: HomeScreen(db: _db),
    );
  }
}

// ─────────────────────────────────────────────
// Hilfsfunktion: Sichere DB-Operation mit Fehler-Feedback
// ─────────────────────────────────────────────
Future<void> _runDbOp(BuildContext context, Future<void> Function() op) async {
  try {
    await op();
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler: $e')),
      );
    }
  }
}

// ─────────────────────────────────────────────
// Home Screen — Bottom Navigation
// ─────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  final AppDatabase db;

  const HomeScreen({super.key, required this.db});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          RecipesScreen(db: widget.db),
          ShoppingListScreen(db: widget.db),
          FoodJournalScreen(db: widget.db),
          SettingsScreen(db: widget.db),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.restaurant_menu),
            label: l10n.recipes,
          ),
          NavigationDestination(
            icon: const Icon(Icons.shopping_cart),
            label: l10n.shoppingList,
          ),
          NavigationDestination(
            icon: const Icon(Icons.book),
            label: l10n.foodJournal,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Rezepte Screen
// ─────────────────────────────────────────────
class RecipesScreen extends StatefulWidget {
  final AppDatabase db;

  const RecipesScreen({super.key, required this.db});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.recipes),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Search — Feature für spätere Version
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.search)),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: widget.db.watchAllRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(l10n.error));
          }
          final recipes = snapshot.data ?? [];
          if (recipes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu_outlined,
                      size: 64, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(l10n.noRecipes),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return ListTile(
                title: Text(recipe.name),
                subtitle: recipe.prepTime != null
                    ? Text('${recipe.prepTime} ${l10n.minutes}')
                    : null,
                trailing: recipe.calories != null
                    ? Text('${recipe.calories} kcal')
                    : null,
                onTap: () {
                  // TODO: Navigate to recipe detail
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRecipeDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddRecipeDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final prepTimeController = TextEditingController();
    final caloriesController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addRecipe),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: l10n.name),
              autofocus: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: prepTimeController,
              decoration: InputDecoration(labelText: '${l10n.prepTime} (${l10n.minutes})'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: caloriesController,
              decoration: InputDecoration(labelText: '${l10n.calories} (${l10n.kcal})'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) return;
              final prepTime = int.tryParse(prepTimeController.text);
              final calories = int.tryParse(caloriesController.text);
              Navigator.pop(ctx);
              _runDbOp(context, () async {
                await widget.db.insertRecipe(RecipesCompanion.insert(
                  name: name,
                  prepTime: prepTime != null ? Value(prepTime) : const Value.absent(),
                  calories: calories != null ? Value(calories) : const Value.absent(),
                ));
              });
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Einkaufsliste Screen
// ─────────────────────────────────────────────
class ShoppingListScreen extends StatefulWidget {
  final AppDatabase db;

  const ShoppingListScreen({super.key, required this.db});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.shoppingList),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            // P1-FIX: Bestätigungsdialog vor dem Löschen
            onPressed: () => _confirmClearChecked(context),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: widget.db.watchAllShoppingItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(l10n.error));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined,
                    size: 64, color: Theme.of(context).colorScheme.outline),
                const SizedBox(height: 16),
                Text(l10n.emptyShoppingList),
              ],
            ));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return CheckboxListTile(
                value: item.checked,
                title: Text(
                  item.item,
                  style: TextStyle(
                    decoration:
                        item.checked ? TextDecoration.lineThrough : null,
                    color: item.checked
                        ? Theme.of(context).colorScheme.outline
                        : null,
                  ),
                ),
                subtitle: item.quantity != null
                    ? Text('${item.quantity} ${item.unit ?? ''}')
                    : null,
                onChanged: (value) {
                  _runDbOp(context, () async {
                    await widget.db.toggleShoppingItem(item.id, value ?? false);
                  });
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddShoppingItemDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmClearChecked(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.clearCheckedConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _runDbOp(context, () async {
                await widget.db.clearCheckedItems();
              });
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showAddShoppingItemDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final itemController = TextEditingController();
    final qtyController = TextEditingController();
    final unitController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addToShoppingList),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: itemController,
              decoration: InputDecoration(labelText: l10n.name),
              autofocus: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: qtyController,
              decoration: InputDecoration(labelText: l10n.quantity),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: unitController,
              decoration: InputDecoration(labelText: l10n.unit),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final item = itemController.text.trim();
              if (item.isEmpty) return;
              final qty = qtyController.text.trim();
              final unit = unitController.text.trim();
              Navigator.pop(ctx);
              _runDbOp(context, () async {
                await widget.db.insertShoppingItem(
                  ShoppingListItemsCompanion.insert(
                    item: item,
                    quantity: qty.isNotEmpty ? Value(qty) : const Value.absent(),
                    unit: unit.isNotEmpty ? Value(unit) : const Value.absent(),
                  ),
                );
              });
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Ernährungstagebuch Screen
// ─────────────────────────────────────────────
class FoodJournalScreen extends StatefulWidget {
  final AppDatabase db;

  const FoodJournalScreen({super.key, required this.db});

  @override
  State<FoodJournalScreen> createState() => _FoodJournalScreenState();
}

class _FoodJournalScreenState extends State<FoodJournalScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateStr = _selectedDate.toIso8601String().substring(0, 10);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.foodJournal),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                // P1-FIX: lastDate in Zukunft erlauben — Meal-Prep/Planung
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                setState(() => _selectedDate = date);
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: widget.db.watchFoodLogForDate(dateStr),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(l10n.error));
          }
          final entries = snapshot.data ?? [];
          if (entries.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.book_outlined,
                    size: 64, color: Theme.of(context).colorScheme.outline),
                const SizedBox(height: 16),
                Text(l10n.emptyFoodJournal),
              ],
            ));
          }
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return ListTile(
                leading: _mealIcon(entry.mealType),
                // P0-FIX: mealType lokalisiert statt Roh-String
                title: Text(entry.customName ?? _mealTypeLabel(entry.mealType, l10n)),
                subtitle: Text(_mealTypeLabel(entry.mealType, l10n)),
                trailing: entry.calories != null
                    ? Text('${entry.calories} kcal')
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFoodLogDialog(context, dateStr),
        child: const Icon(Icons.add),
      ),
    );
  }

  Icon _mealIcon(String mealType) {
    switch (mealType) {
      case 'breakfast':
        return const Icon(Icons.free_breakfast);
      case 'lunch':
        return const Icon(Icons.lunch_dining);
      case 'dinner':
        return const Icon(Icons.dinner_dining);
      case 'snack':
        return const Icon(Icons.cookie);
      default:
        return const Icon(Icons.restaurant);
    }
  }

  // P0-FIX: mealType übersetzen statt Roh-String anzeigen
  String _mealTypeLabel(String mealType, AppLocalizations l10n) {
    switch (mealType) {
      case 'breakfast':
        return l10n.mealTypeBreakfast;
      case 'lunch':
        return l10n.mealTypeLunch;
      case 'dinner':
        return l10n.mealTypeDinner;
      case 'snack':
        return l10n.mealTypeSnack;
      default:
        return mealType;
    }
  }

  void _showAddFoodLogDialog(BuildContext context, String dateStr) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();
    String selectedMealType = 'breakfast';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(l10n.foodJournal),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedMealType,
                decoration: InputDecoration(labelText: l10n.foodJournal),
                items: [
                  DropdownMenuItem(value: 'breakfast', child: Text(l10n.mealTypeBreakfast)),
                  DropdownMenuItem(value: 'lunch', child: Text(l10n.mealTypeLunch)),
                  DropdownMenuItem(value: 'dinner', child: Text(l10n.mealTypeDinner)),
                  DropdownMenuItem(value: 'snack', child: Text(l10n.mealTypeSnack)),
                ],
                onChanged: (v) => setState(() => selectedMealType = v!),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: l10n.name),
                autofocus: true,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: caloriesController,
                decoration: InputDecoration(labelText: '${l10n.calories} (${l10n.kcal})'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                final calories = int.tryParse(caloriesController.text);
                Navigator.pop(ctx);
                _runDbOp(context, () async {
                  await widget.db.insertFoodLogEntry(
                    FoodLogEntriesCompanion.insert(
                      date: dateStr,
                      mealType: selectedMealType,
                      customName: name.isNotEmpty ? Value(name) : const Value.absent(),
                      calories: calories != null ? Value(calories) : const Value.absent(),
                    ),
                  );
                });
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Einstellungen Screen
// ─────────────────────────────────────────────
class SettingsScreen extends StatefulWidget {
  final AppDatabase db;

  const SettingsScreen({super.key, required this.db});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: StreamBuilder(
        stream: widget.db.watchSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(l10n.error));
          }
          final settings = snapshot.data;
          return ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(l10n.language),
                // P3-FIX: Lokalisierte Werte statt Roh-Strings
                subtitle: Text(settings?.locale == 'en' ? 'English' : 'Deutsch'),
                onTap: () => _showLanguagePicker(context, settings),
              ),
              ListTile(
                leading: const Icon(Icons.straighten),
                title: Text(l10n.units),
                subtitle: Text(settings?.units == 'imperial'
                    ? l10n.unitsImperial
                    : l10n.unitsMetric),
                onTap: () => _showUnitsPicker(context, settings),
              ),
              ListTile(
                leading: const Icon(Icons.palette),
                title: Text(l10n.theme),
                subtitle: Text(_themeLabel(settings?.theme ?? 'system', l10n)),
                onTap: () => _showThemePicker(context, settings),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.local_fire_department),
                title: Text(l10n.calorieGoal),
                subtitle: settings?.calorieGoal != null
                    ? Text('${settings!.calorieGoal} ${l10n.kcal}')
                    : Text(l10n.notSet),
                onTap: () => _showNumberPicker(
                  context, settings, 'calorieGoal', l10n.calorieGoal, l10n.kcal,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.fitness_center),
                title: Text(l10n.proteinGoal),
                subtitle: settings?.proteinGoal != null
                    ? Text('${settings!.proteinGoal}${l10n.gram}')
                    : Text(l10n.notSet),
                onTap: () => _showNumberPicker(
                  context, settings, 'proteinGoal', l10n.proteinGoal, l10n.gram,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.grain),
                title: Text(l10n.carbsGoal),
                subtitle: settings?.carbsGoal != null
                    ? Text('${settings!.carbsGoal}${l10n.gram}')
                    : Text(l10n.notSet),
                onTap: () => _showNumberPicker(
                  context, settings, 'carbsGoal', l10n.carbsGoal, l10n.gram,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.water_drop),
                title: Text(l10n.fatGoal),
                subtitle: settings?.fatGoal != null
                    ? Text('${settings!.fatGoal}${l10n.gram}')
                    : Text(l10n.notSet),
                onTap: () => _showNumberPicker(
                  context, settings, 'fatGoal', l10n.fatGoal, l10n.gram,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _themeLabel(String theme, AppLocalizations l10n) {
    switch (theme) {
      case 'light':
        return l10n.themeLight;
      case 'dark':
        return l10n.themeDark;
      default:
        return l10n.themeSystem;
    }
  }

  void _showLanguagePicker(BuildContext context, AppSetting? settings) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.language),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              _saveSetting(context, const AppSettingsCompanion(locale: Value('de')));
            },
            child: const Text('Deutsch'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              _saveSetting(context, const AppSettingsCompanion(locale: Value('en')));
            },
            child: const Text('English'),
          ),
        ],
      ),
    );
  }

  void _showUnitsPicker(BuildContext context, AppSetting? settings) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.units),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              _saveSetting(context, const AppSettingsCompanion(units: Value('metric')));
            },
            child: Text(l10n.unitsMetric),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              _saveSetting(context, const AppSettingsCompanion(units: Value('imperial')));
            },
            child: Text(l10n.unitsImperial),
          ),
        ],
      ),
    );
  }

  void _showThemePicker(BuildContext context, AppSetting? settings) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.theme),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              _saveSetting(context, const AppSettingsCompanion(theme: Value('system')));
            },
            child: Text(l10n.themeSystem),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              _saveSetting(context, const AppSettingsCompanion(theme: Value('light')));
            },
            child: Text(l10n.themeLight),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(ctx);
              _saveSetting(context, const AppSettingsCompanion(theme: Value('dark')));
            },
            child: Text(l10n.themeDark),
          ),
        ],
      ),
    );
  }

  void _showNumberPicker(BuildContext context, AppSetting? settings,
      String field, String title, String unit) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: '$title ($unit)'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final text = controller.text.trim();
              Navigator.pop(ctx);
              if (text.isEmpty) return;
              final value = double.tryParse(text);
              if (value == null) return;
              final companion = switch (field) {
                'calorieGoal' => AppSettingsCompanion(calorieGoal: Value(value.round())),
                'proteinGoal' => AppSettingsCompanion(proteinGoal: Value(value)),
                'carbsGoal' => AppSettingsCompanion(carbsGoal: Value(value)),
                'fatGoal' => AppSettingsCompanion(fatGoal: Value(value)),
                _ => null,
              };
              if (companion != null) {
                _saveSetting(context, companion);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _saveSetting(BuildContext context, AppSettingsCompanion companion) {
    _runDbOp(context, () async {
      await widget.db.upsertSettings(companion);
    });
  }
}
