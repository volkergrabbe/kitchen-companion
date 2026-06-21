// lib/ui/screens/food_journal_screen.dart
//
// Ernährungstagebuch — aus v1 übernommen.

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class FoodJournalScreen extends ConsumerStatefulWidget {
  const FoodJournalScreen({super.key});

  @override
  ConsumerState<FoodJournalScreen> createState() => _FoodJournalScreenState();
}

class _FoodJournalScreenState extends ConsumerState<FoodJournalScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final db = ref.watch(databaseProvider);
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
              if (date != null) setState(() => _selectedDate = date);
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: db.watchFoodLogForDate(dateStr),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final entries = snapshot.data!;
          if (entries.isEmpty) {
            return Center(child: Text(l10n.emptyFoodJournal));
          }
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, i) {
              final e = entries[i];
              return ListTile(
                leading: Icon(_icon(e.mealType)),
                title: Text(e.customName ?? '–'),
                subtitle: Text(e.mealType),
                trailing: e.calories != null
                    ? Text('${e.calories} ${l10n.kcal}')
                    : null,
              );
            },
          );
        },
      ),
    );
  }

  IconData _icon(String mealType) {
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
}