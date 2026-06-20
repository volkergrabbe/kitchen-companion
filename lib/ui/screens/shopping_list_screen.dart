// lib/ui/screens/shopping_list_screen.dart
//
// Einkaufsliste — manuell + aus Plan generiert.

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/database.dart';
import '../providers.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() =>
      _ShoppingListScreenState();
}

class _ShoppingListScreenState
    extends ConsumerState<ShoppingListScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final db = ref.watch(databaseProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.shoppingList),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => db.clearCheckedItems(),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: db.watchAllShoppingItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return Center(child: Text(l10n.emptyShoppingList));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final item = items[i];
              return CheckboxListTile(
                value: item.checked,
                title: Text(item.item),
                onChanged: (val) =>
                    db.toggleShoppingItem(item.id, val ?? false),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final ctrl = TextEditingController();
          await showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Neues Item'),
              content: TextField(
                controller: ctrl,
                autofocus: true,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Abbrechen'),
                ),
                FilledButton(
                  onPressed: () async {
                    if (ctrl.text.isNotEmpty) {
                      await db.into(db.shoppingItems).insert(
                            ShoppingItemsCompanion.insert(item: ctrl.text),
                          );
                    }
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}