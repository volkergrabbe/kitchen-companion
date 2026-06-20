// lib/ui/screens/offers_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

class OffersScreen extends ConsumerWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final offersAsync = ref.watch(activeOffersStreamProvider);
    final discountersAsync = ref.watch(discountersStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.offers),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refreshOffers,
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.refreshing)),
              );
              try {
                final repo = ref.read(offerRepositoryProvider);
                final results = await repo.refreshAll();
                final success =
                    results.values.where((v) => v >= 0).length;
                final failed =
                    results.values.where((v) => v < 0).length;
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.refreshResult(success, failed)),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Fehler: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          discountersAsync.when(
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
            data: (discounters) {
              return SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  itemCount: discounters.length,
                  itemBuilder: (context, i) {
                    final d = discounters[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(d.name),
                        selected: d.enabled,
                        onSelected: (val) => ref
                            .read(discounterRepositoryProvider)
                            .setEnabled(d.id, val),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: offersAsync.when(
              loading: () => const Center(
                  child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Fehler: $e')),
              data: (offers) {
                if (offers.isEmpty) {
                  return Center(child: Text(l10n.noOffers));
                }
                return ListView.builder(
                  itemCount: offers.length,
                  itemBuilder: (context, i) {
                    final offer = offers[i];
                    return ListTile(
                      title: Text(offer.ingredientName ??
                          offer.rawName),
                      subtitle: Text(
                        '${offer.discounterName} · ${offer.unitText ?? ""}',
                      ),
                      trailing: Text(
                        '${offer.price.toStringAsFixed(2)}€',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}