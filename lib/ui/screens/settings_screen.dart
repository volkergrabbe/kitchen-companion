// lib/ui/screens/settings_screen.dart
//
// Erweiterte Settings: Personen, PLZ, Marktguru-API, Auto-Plan, Notifications.

import 'package:flutter/material.dart';
// P0-3 (Privacy Review): POST_NOTIFICATIONS Runtime-Permission
// wird hier über permission_handler angefordert.
// ignore: depend_on_referenced_packages
import 'package:permission_handler/permission_handler.dart' as ph;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'contraindications_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profileRepo = ref.read(profileRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: FutureBuilder(
        future: Future.wait([
          profileRepo.getPersons(),
          profileRepo.getZipCode(),
          profileRepo.getMarktguruEnabled(),
          profileRepo.getMarktguruApiKey(),
        ]),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final persons = snap.data![0] as int;
          final zip = snap.data![1] as String?;
          final marktguruEnabled = snap.data![2] as bool;
          final marktguruKey = snap.data![3] as String?;

          return ListView(
            children: [
              // ─── Personen ───
              ListTile(
                leading: const Icon(Icons.people),
                title: Text(l10n.settingsPersons),
                subtitle: Text(l10n.personsCount(persons)),
                trailing: DropdownButton<int>(
                  value: persons,
                  items: [1, 2, 3, 4]
                      .map((n) => DropdownMenuItem(
                            value: n,
                            child: Text('$n'),
                          ))
                      .toList(),
                  onChanged: (val) async {
                    if (val != null) {
                      await profileRepo.setPersons(val);
                      ref.invalidate(profileRepositoryProvider);
                    }
                  },
                ),
              ),

              // ─── PLZ ───
              ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(l10n.settingsZipCode),
                subtitle: Text(zip ?? '–'),
                onTap: () async {
                  final controller = TextEditingController(text: zip ?? '');
                  final result = await showDialog<String?>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(l10n.settingsZipCode),
                      content: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        maxLength: 5,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Abbrechen'),
                        ),
                        FilledButton(
                          onPressed: () =>
                              Navigator.pop(ctx, controller.text),
                          child: const Text('Speichern'),
                        ),
                      ],
                    ),
                  );
                  if (result != null) {
                    await profileRepo.setZipCode(
                        result.isEmpty ? null : result);
                    ref.invalidate(profileRepositoryProvider);
                  }
                },
              ),

              const Divider(),

              // ─── Benachrichtigungen (P0-3 Privacy) ───
              const _NotificationsSection(),

              const Divider(),

              // ─── Kontraindikationen ───
              ListTile(
                leading: const Icon(Icons.medical_services),
                title: Text(l10n.contraindications),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ContraindicationsScreen(),
                    ),
                  );
                },
              ),

              const Divider(),

              // ─── Marktguru ───
              ListTile(
                leading: const Icon(Icons.api),
                title: Text(l10n.settingsMarktguru),
                subtitle: Text(l10n.settingsMarktguruHint),
              ),
              SwitchListTile(
                title: Text(l10n.settingsMarktguru),
                value: marktguruEnabled,
                onChanged: (val) async {
                  await profileRepo.setMarktguruEnabled(val);
                  ref.invalidate(profileRepositoryProvider);
                },
              ),
              if (marktguruEnabled)
                ListTile(
                  leading: const Icon(Icons.key),
                  title: Text(l10n.settingsMarktguruApiKey),
                  subtitle: Text(marktguruKey != null && marktguruKey.isNotEmpty
                      ? '••••••••'
                      : '–'),
                  onTap: () async {
                    final controller = TextEditingController(
                        text: marktguruKey ?? '');
                    final result = await showDialog<String?>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(l10n.settingsMarktguruApiKey),
                        content: TextField(
                          controller: controller,
                          obscureText: true,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Abbrechen'),
                          ),
                          FilledButton(
                            onPressed: () =>
                                Navigator.pop(ctx, controller.text),
                            child: const Text('Speichern'),
                          ),
                        ],
                      ),
                    );
                    if (result != null) {
                      await profileRepo.setMarktguruApiKey(
                          result.isEmpty ? null : result);
                      ref.invalidate(profileRepositoryProvider);
                    }
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

/// P0-3 (Privacy Review): Runtime-Permission für POST_NOTIFICATIONS.
///
/// Android 13+ (API 33+) verlangt eine explizite User-Zustimmung für
/// Benachrichtigungen. Wir zeigen den aktuellen Status, einen Button
/// zum Anfordern und einen Fallback-Link zu den System-Einstellungen,
/// falls der User die Permission dauerhaft verweigert hat.
class _NotificationsSection extends StatefulWidget {
  const _NotificationsSection();

  @override
  State<_NotificationsSection> createState() => _NotificationsSectionState();
}

class _NotificationsSectionState extends State<_NotificationsSection> {
  // Initial: laden wir den Status. Nach Aktion aktualisieren wir lokal.
  ph.PermissionStatus _status = ph.PermissionStatus.denied;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    // permission_handler wirft auf iOS oder Desktop eine PlatformException;
    // wir fangen das ab und zeigen im Fehlerfall "denied" an.
    try {
      final s = await ph.Permission.notification.status;
      if (mounted) {
        setState(() {
          _status = s;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _status = ph.PermissionStatus.denied;
          _loading = false;
        });
      }
    }
  }

  Future<void> _request() async {
    try {
      final result = await ph.Permission.notification.request();
      if (!mounted) return;
      setState(() => _status = result);
      if (result.isPermanentlyDenied) {
        _showOpenSettingsDialog();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Anfordern: $e')),
      );
    }
  }

  void _showOpenSettingsDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.notifStatusPermanentlyDenied),
        content: Text(l10n.openSettings),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ph.openAppSettings();
            },
            child: Text(l10n.openSettings),
          ),
        ],
      ),
    );
  }

  String _statusLabel(AppLocalizations l10n) {
    if (_status.isGranted) return l10n.notifStatusGranted;
    if (_status.isPermanentlyDenied) return l10n.notifStatusPermanentlyDenied;
    if (_status.isRestricted) return l10n.notifStatusRestricted;
    if (_status.isLimited) return l10n.notifStatusLimited;
    if (_status.isProvisional) return l10n.notifStatusProvisional;
    return l10n.notifStatusDenied;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: const Icon(Icons.notifications),
          title: Text(l10n.notificationsEnable),
          subtitle: Text(l10n.notificationsEnableHint),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _loading
                      ? '…'
                      : l10n.notificationsStatus(_statusLabel(l10n)),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: _loading || _status.isGranted ? null : _request,
                icon: const Icon(Icons.notifications_active),
                label: Text(l10n.notificationsEnable),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
