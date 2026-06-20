// lib/ui/screens/weekly_plan_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/entities.dart';
import '../providers.dart';

class WeeklyPlanScreen extends ConsumerWidget {
  const WeeklyPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(activePlanStreamProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.weeklyPlan),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.generatePlan,
            onPressed: () => _generatePlan(context, ref),
          ),
        ],
      ),
      body: planAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (plan) {
          if (plan == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_month,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(l10n.noActivePlan),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(l10n.generatePlan),
                    onPressed: () => _generatePlan(context, ref),
                  ),
                ],
              ),
            );
          }
          return _PlanView(plan: plan);
        },
      ),
    );
  }

  Future<void> _generatePlan(BuildContext context, WidgetRef ref) async {
    final profile = ref.read(profileRepositoryProvider);
    final persons = await profile.getPersons();
    final repo = ref.read(weeklyPlanRepositoryProvider);

    try {
      await repo.generate(persons: persons);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e')),
        );
      }
    }
  }
}

class _PlanView extends ConsumerWidget {
  final WeeklyPlanEntity plan;
  const _PlanView({required this.plan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final byDate = <DateTime, List<PlanMealEntity>>{};
    for (final m in plan.meals) {
      final dateOnly = DateTime(m.date.year, m.date.month, m.date.day);
      byDate.putIfAbsent(dateOnly, () => []).add(m);
    }

    final sortedDates = byDate.keys.toList()..sort();

    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(Icons.calendar_today),
                    Text(DateFormat.yMMMd(
                            Localizations.localeOf(context).toString())
                        .format(plan.weekStart)),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.people),
                    Text(l10n.personsCount(plan.persons)),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.shopping_basket),
                    Text('${plan.shoppingList.length}'),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: sortedDates.length,
            itemBuilder: (context, i) {
              final date = sortedDates[i];
              final meals = byDate[date]!;
              meals.sort((a, b) =>
                  a.mealType.compareTo(b.mealType));
              return _DayCard(date: date, meals: meals);
            },
          ),
        ),
        if (plan.shoppingList.isNotEmpty)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: FilledButton.icon(
                icon: const Icon(Icons.shopping_cart),
                label: Text(
                    '${l10n.shoppingFromPlan} (${plan.shoppingList.length})'),
                onPressed: () => _showShoppingList(context, plan),
              ),
            ),
          ),
      ],
    );
  }

  void _showShoppingList(BuildContext context, WeeklyPlanEntity plan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        builder: (context, scroll) {
          return ListView.builder(
            controller: scroll,
            itemCount: plan.shoppingList.length + 1,
            itemBuilder: (context, i) {
              if (i == 0) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Einkaufszettel',
                      style: Theme.of(context).textTheme.headlineSmall),
                );
              }
              final item = plan.shoppingList[i - 1];
              return ListTile(
                title: Text(item.ingredientName),
                subtitle: Text(
                    '${item.quantity.toStringAsFixed(0)}${item.unit ?? 'g'}'),
                trailing: item.offerPrice != null
                    ? Text('${item.offerPrice!.toStringAsFixed(2)}€')
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final DateTime date;
  final List<PlanMealEntity> meals;
  const _DayCard({required this.date, required this.meals});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final weekdayName = _weekdayName(date.weekday, l10n);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(weekdayName,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...meals.map((m) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(_mealIcon(m.mealType), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_mealTypeLabel(m.mealType, l10n),
                                style: Theme.of(context).textTheme.bodySmall),
                            Text(m.recipeName ?? '–'),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  String _weekdayName(int weekday, AppLocalizations l10n) {
    switch (weekday) {
      case 1:
        return l10n.monday;
      case 2:
        return l10n.tuesday;
      case 3:
        return l10n.wednesday;
      case 4:
        return l10n.thursday;
      case 5:
        return l10n.friday;
      case 6:
        return l10n.saturday;
      case 7:
        return l10n.sunday;
    }
    return '';
  }

  IconData _mealIcon(String mealType) {
    switch (mealType) {
      case 'breakfast':
        return Icons.free_breakfast;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      case 'snack':
        return Icons.cookie;
    }
    return Icons.restaurant;
  }

  String _mealTypeLabel(String mealType, AppLocalizations l10n) {
    switch (mealType) {
      case 'breakfast':
        return l10n.breakfast;
      case 'lunch':
        return l10n.lunch;
      case 'dinner':
        return l10n.dinner;
      case 'snack':
        return l10n.snack;
    }
    return '';
  }
}