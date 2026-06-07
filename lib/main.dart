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
    await _db.ensureSettingsExist();
    await _loadSettings();
  }

  @override
  void dispose() {
    _db.close();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final settings = await _db.getSettings();
    if (settings != null) {
      setState(() {
        _themeMode = _themeModeFromString(settings.theme);
      });
    }
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
      supportedLocales: const [
        Locale('de'),
        Locale('en'),
        Locale('fr'),
        Locale('es'),
        Locale('it'),
        Locale('pl'),
        Locale('nl'),
        Locale('cs'),
        Locale('pt'),
        Locale('sv'),
      ],
      home: HomeScreen(db: _db),
    );
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
              // TODO: Search
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
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final recipes = snapshot.data ?? [];
          if (recipes.isEmpty) {
            return Center(child: Text(l10n.noRecipes));
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
        onPressed: () {
          // TODO: Add recipe
        },
        child: Text(l10n.addRecipe),
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
            onPressed: () async {
              await widget.db.clearCheckedItems();
            },
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
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_cart_outlined,
                    size: 64, color: Colors.grey),
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
                    color: item.checked ? Colors.grey : null,
                  ),
                ),
                subtitle: item.quantity != null
                    ? Text('${item.quantity} ${item.unit ?? ''}')
                    : null,
                onChanged: (value) async {
                  await widget.db.toggleShoppingItem(item.id, value ?? false);
                },
              );
            },
          );
        },
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
                lastDate: DateTime.now(),
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
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final entries = snapshot.data ?? [];
          if (entries.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.book_outlined, size: 64, color: Colors.grey),
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
                title: Text(entry.customName ?? '—'),
                subtitle: Text(entry.mealType),
                trailing: entry.calories != null
                    ? Text('${entry.calories} kcal')
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // TODO: Add food log entry
        },
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
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final settings = snapshot.data;
          return ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(l10n.language),
                subtitle: Text(settings?.locale ?? 'de'),
                onTap: () {
                  // TODO: Language picker
                },
              ),
              ListTile(
                leading: const Icon(Icons.straighten),
                title: Text(l10n.units),
                subtitle: Text(settings?.units ?? 'metric'),
                onTap: () {
                  // TODO: Units picker
                },
              ),
              ListTile(
                leading: const Icon(Icons.palette),
                title: Text(l10n.theme),
                subtitle: Text(settings?.theme ?? 'system'),
                onTap: () {
                  // TODO: Theme picker
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.local_fire_department),
                title: Text(l10n.calorieGoal),
                subtitle: settings?.calorieGoal != null
                    ? Text('${settings!.calorieGoal} ${l10n.kcal}')
                    : Text(l10n.notSet),
                onTap: () {
                  // TODO: Calorie goal picker
                },
              ),
              ListTile(
                leading: const Icon(Icons.fitness_center),
                title: Text(l10n.proteinGoal),
                subtitle: settings?.proteinGoal != null
                    ? Text('${settings!.proteinGoal}${l10n.gram}')
                    : Text(l10n.notSet),
                onTap: () {
                  // TODO: Protein goal picker
                },
              ),
              ListTile(
                leading: const Icon(Icons.grain),
                title: Text(l10n.carbsGoal),
                subtitle: settings?.carbsGoal != null
                    ? Text('${settings!.carbsGoal}${l10n.gram}')
                    : Text(l10n.notSet),
                onTap: () {
                  // TODO: Carbs goal picker
                },
              ),
              ListTile(
                leading: const Icon(Icons.water_drop),
                title: Text(l10n.fatGoal),
                subtitle: settings?.fatGoal != null
                    ? Text('${settings!.fatGoal}${l10n.gram}')
                    : Text(l10n.notSet),
                onTap: () {
                  // TODO: Fat goal picker
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
