// lib/main.dart
//
// Entry-Point. Initialisiert DB, Seed, Background-Jobs, UI.

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'background/background_jobs.dart';
import 'data/database/database.dart';
import 'data/database/seed.dart';
import 'ui/providers.dart';
import 'ui/screens/home_screen.dart';
import 'ui/theme/app_theme.dart';

/// P1 (Theme-Load, GLM-5.2 Review): SharedPreferences muss VOR
/// `runApp` synchron verfügbar sein, damit der Theme-Provider beim
/// ersten Frame den korrekten Wert liefert. `SharedPreferencesAsync`
/// (shared_preferences >= 2.5) lädt ohne `await`.
const String themePrefsKey = 'app.theme_mode';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DB einmalig öffnen + seeden
  final db = AppDatabase();
  await db.ensureSettingsExist();
  await SeedData.ensureSeeded(db);

  // Background Jobs initialisieren
  await BackgroundJobs.initialize();
  await BackgroundJobs.scheduleWeekly();

  // P1 (Theme-Load): SharedPreferences synchron via Async-API laden —
  // kein await-Block, kein DB-Query für UI-Theme beim ersten Frame.
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const KitchenCompanionApp(),
    ),
  );
}

class KitchenCompanionApp extends ConsumerStatefulWidget {
  const KitchenCompanionApp({super.key});

  @override
  ConsumerState<KitchenCompanionApp> createState() =>
      _KitchenCompanionAppState();
}

class _KitchenCompanionAppState
    extends ConsumerState<KitchenCompanionApp> {
  // P1 (Theme-Load): Initial-Theme kommt aus dem synchron geladenen
  // SharedPreferences (override in main()). `ref.read` ist hier
  // erlaubt, weil main() die Prefs-Instanz bereits bereitgestellt hat.
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = _loadThemeFromPrefs();
  }

  ThemeMode _loadThemeFromPrefs() {
    final prefs = ref.read(sharedPreferencesProvider);
    final stored = prefs.getString(themePrefsKey);
    return _themeModeFromString(stored);
  }

  ThemeMode _themeModeFromString(String? theme) {
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
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        // P0-2 (Privacy/Architecture Review): Nur de und en —
        // 9 weitere .arb-Dateien waren 1:1 Kopien von EN und
        // wurden entfernt. Weitere Sprachen sind TODO (siehe README).
        Locale('de'),
        Locale('en'),
      ],
      home: const HomeScreen(),
    );
  }
}