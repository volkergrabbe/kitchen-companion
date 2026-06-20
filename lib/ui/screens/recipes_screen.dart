// lib/ui/screens/recipes_screen.dart
//
// Rezepte-Verwaltung: Liste + Add/Edit Dialog.

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/entities.dart';
import '../providers.dart';

class RecipesScreen extends ConsumerWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.recipes)),
      body: const _RecipeList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final prepCtrl = TextEditingController();
    final calCtrl = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Neues Rezept'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Beschreibung'),
              ),
              TextField(
                controller: prepCtrl,
                decoration:
                    const InputDecoration(labelText: 'Zubereitungszeit (Min)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: calCtrl,
                decoration:
                    const InputDecoration(labelText: 'Kalorien (kcal)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Speichern'),
          ),
        ],
      ),
    );

    if (result == true && nameCtrl.text.isNotEmpty) {
      await ref.read(recipeRepositoryProvider).create(RecipeEntity(
            id: 0,
            name: nameCtrl.text,
            createdAt: DateTime.now(),
            description:
                descCtrl.text.isEmpty ? null : descCtrl.text,
            prepTimeMinutes: int.tryParse(prepCtrl.text),
            calories: int.tryParse(calCtrl.text),
          ));
    }
  }
}

class _RecipeList extends ConsumerWidget {
  const _RecipeList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return StreamBuilder<List<RecipeEntity>>(
      stream: ref.watch(recipeRepositoryProvider).watchAll(),
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
          itemBuilder: (context, i) {
            final r = recipes[i];
            return ListTile(
              title: Text(r.name),
              subtitle: r.prepTimeMinutes != null
                  ? Text('${r.prepTimeMinutes} ${l10n.minutes}')
                  : null,
              trailing: r.calories != null
                  ? Text('${r.calories} ${l10n.kcal}')
                  : null,
              onLongPress: () async {
                await ref
                    .read(recipeRepositoryProvider)
                    .delete(r.id);
              },
            );
          },
        );
      },
    );
  }
}