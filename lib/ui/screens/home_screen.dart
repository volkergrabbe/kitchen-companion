// lib/ui/screens/home_screen.dart
//
// 5-Tab-Hauptnavigation.

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'food_journal_screen.dart';
import 'offers_screen.dart';
import 'recipes_screen.dart';
import 'settings_screen.dart';
import 'shopping_list_screen.dart';
import 'weekly_plan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final screens = <Widget>[
      const WeeklyPlanScreen(),
      const RecipesScreen(),
      const ShoppingListScreen(),
      const OffersScreen(),
      const FoodJournalScreen(),
      const SettingsScreen(),
    ];

    final destinations = <NavigationDestination>[
      NavigationDestination(
        icon: const Icon(Icons.calendar_month),
        label: l10n.weeklyPlan,
      ),
      NavigationDestination(
        icon: const Icon(Icons.restaurant_menu),
        label: l10n.recipes,
      ),
      NavigationDestination(
        icon: const Icon(Icons.shopping_cart),
        label: l10n.shoppingList,
      ),
      NavigationDestination(
        icon: const Icon(Icons.local_offer),
        label: l10n.offers,
      ),
      NavigationDestination(
        icon: const Icon(Icons.book),
        label: l10n.foodJournal,
      ),
      NavigationDestination(
        icon: const Icon(Icons.settings),
        label: l10n.settings,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) =>
            setState(() => _currentIndex = index),
        destinations: destinations,
      ),
    );
  }
}