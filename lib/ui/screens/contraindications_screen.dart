// lib/ui/screens/contraindications_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/entities.dart';
import '../providers.dart';

class ContraindicationsScreen extends ConsumerWidget {
  const ContraindicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // P0-1 (Architecture Review): userContraindicationsProvider liefert
    // ActiveContraindication-Entities mit userContraindicationId, damit
    // der "Minus"-Button die korrekte Join-Tabellen-ID bekommt.
    final activeAsync = ref.watch(userContraindicationsProvider);
    final allAsync = ref.watch(allContraindicationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.contraindications)),
      body: activeAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (active) {
          final activeIds = active.map((a) => a.contraindicationId).toSet();
          return allAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Fehler: $e')),
            data: (all) {
              final disease = all
                  .where((c) => c.type == 'disease')
                  .toList();
              final medication = all
                  .where((c) => c.type == 'medication')
                  .toList();

              return ListView(
                children: [
                  _SectionHeader(title: l10n.activeContraindications),
                  if (active.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('—'),
                    )
                  else
                    // P0-1 (Architecture Review): userContraindicationId
                    // kommt jetzt DIREKT aus dem Provider-Stream — keine
                    // Workaround-Funktion mehr nötig.
                    ...active.map((a) => _ActiveContraTile(item: a)),
                  _SectionHeader(title: l10n.disease),
                  ...disease.map((c) => _ContraTile(
                        item: c,
                        isActive: activeIds.contains(c.id),
                        onToggle: () => ref
                            .read(contraindicationRepositoryProvider)
                            .activateForUser(c.id),
                      )),
                  _SectionHeader(title: l10n.medication),
                  ...medication.map((c) => _ContraTile(
                        item: c,
                        isActive: activeIds.contains(c.id),
                        onToggle: () => ref
                            .read(contraindicationRepositoryProvider)
                            .activateForUser(c.id),
                      )),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              )),
    );
  }
}

class _ContraTile extends StatelessWidget {
  final ContraindicationEntity item;
  final bool isActive;
  final VoidCallback onToggle;
  const _ContraTile({
    required this.item,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: Icon(
          isActive
              ? Icons.check_circle
              : item.type == 'disease'
                  ? Icons.medical_services
                  : Icons.medication,
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : null,
        ),
        title: Text(item.displayName(locale)),
        subtitle: Text(
          _severityLabel(item.severity, AppLocalizations.of(context)!),
        ),
        trailing: isActive
            ? const Icon(Icons.remove_circle_outline)
            : const Icon(Icons.add_circle_outline),
        onTap: onToggle,
      ),
    );
  }

  String _severityLabel(String severity, AppLocalizations l10n) {
    switch (severity) {
      case 'avoid':
        return l10n.severityAvoid;
      case 'limit':
        return l10n.severityLimit;
      case 'caution':
        return l10n.severityCaution;
    }
    return severity;
  }
}

/// P0-1 (Architecture Review): Tile für eine bereits aktivierte
/// Kontraindikation. Verwendet die Join-Tabellen-ID (userContraindicationId),
/// damit der "Minus"-Button tatsächlich die richtige Zeile löscht.
class _ActiveContraTile extends ConsumerWidget {
  final ActiveContraindication item;
  const _ActiveContraTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).languageCode;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: Icon(
          Icons.check_circle,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(item.displayName(locale)),
        subtitle: Text(_severityLabel(context, item.severity)),
        trailing: const Icon(Icons.remove_circle_outline),
        onTap: () {
          // P0-1: Hier wird die echte user_contraindication.id gelöscht.
          ref
              .read(contraindicationRepositoryProvider)
              .deactivateForUser(item.userContraindicationId);
        },
      ),
    );
  }

  String _severityLabel(BuildContext context, String severity) {
    final l10n = AppLocalizations.of(context)!;
    switch (severity) {
      case 'avoid':
        return l10n.severityAvoid;
      case 'limit':
        return l10n.severityLimit;
      case 'caution':
        return l10n.severityCaution;
    }
    return severity;
  }
}