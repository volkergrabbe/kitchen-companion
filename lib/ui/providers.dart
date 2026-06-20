// lib/ui/providers.dart
//
// Riverpod-Provider für alle Repositories + State.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/database/database.dart';
import '../../data/repositories/impl.dart';
import '../../data/repositories/offer_repository.dart' as data_repo;
import '../../data/sources/scraper/discounter_scraper.dart';
import '../../domain/repositories/repositories.dart' as repo;
import '../../domain/services/contraindication_checker.dart';
import '../../domain/services/weekly_plan_engine.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// P1 (Theme-Load, GLM-5.2 Review): SharedPreferences wird in `main()`
/// synchron geladen und über `overrideWithValue` injiziert. Provider
/// hat keinen Default, weil er App-weit zwingend vorhanden sein muss.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider muss in main() via overrideWithValue '
    'bereitgestellt werden.',
  );
});

final httpClientProvider = Provider<HttpClient>((ref) {
  return DefaultHttpClient();
});

final contraindicationCheckerProvider =
    Provider<ContraindicationChecker>((ref) {
  return ContraindicationChecker(ref.watch(databaseProvider));
});

final weeklyPlanEngineProvider = Provider<WeeklyPlanEngine>((ref) {
  return WeeklyPlanEngine(
    ref.watch(databaseProvider),
    ref.watch(contraindicationCheckerProvider),
  );
});

final offerDataRepositoryProvider = Provider<data_repo.OfferRepository>((ref) {
  return data_repo.OfferRepository(
    ref.watch(databaseProvider),
    http: ref.watch(httpClientProvider),
  );
});

final recipeRepositoryProvider = Provider<repo.RecipeRepository>((ref) {
  return RecipeRepositoryImpl(ref.watch(databaseProvider));
});

final weeklyPlanRepositoryProvider = Provider<repo.WeeklyPlanRepository>((ref) {
  return WeeklyPlanRepositoryImpl(
    ref.watch(databaseProvider),
    ref.watch(weeklyPlanEngineProvider),
  );
});

final offerRepositoryProvider = Provider<repo.OfferRepository>((ref) {
  return OfferRepositoryImpl(
    ref.watch(databaseProvider),
    ref.watch(offerDataRepositoryProvider),
  );
});

final contraindicationRepositoryProvider =
    Provider<repo.ContraindicationRepository>((ref) {
  return ContraindicationRepositoryImpl(ref.watch(databaseProvider));
});

final discounterRepositoryProvider = Provider<repo.DiscounterRepository>((ref) {
  return DiscounterRepositoryImpl(ref.watch(databaseProvider));
});

final profileRepositoryProvider = Provider<repo.ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(databaseProvider));
});

/// Stream-Provider für aktive Wochenpläne.
final activePlanStreamProvider = StreamProvider((ref) {
  return ref.watch(weeklyPlanRepositoryProvider).watchActive();
});

/// Stream-Provider für alle Wochenpläne (Historie).
final allPlansStreamProvider = StreamProvider((ref) {
  return ref.watch(weeklyPlanRepositoryProvider).watchAll();
});

/// Stream-Provider für aktive Angebote.
final activeOffersStreamProvider = StreamProvider((ref) {
  return ref.watch(offerRepositoryProvider).watchActive();
});

/// Stream-Provider für alle Discounter.
final discountersStreamProvider = StreamProvider((ref) {
  return ref.watch(discounterRepositoryProvider).watchAll();
});

/// P0-1 (Architecture Review): Stream-Provider für aktive
/// User-Kontraindikationen. Liefert [ActiveContraindication]-Entities mit
/// `userContraindicationId`, damit der "Minus"-Button die korrekte
/// Join-Tabellen-ID zum Deaktivieren bekommt.
final userContraindicationsProvider = StreamProvider((ref) {
  return ref.watch(contraindicationRepositoryProvider).watchActiveForUser();
});

/// Stream-Provider für alle verfügbaren Kontraindikationen.
final allContraindicationsProvider = StreamProvider((ref) {
  return ref.watch(contraindicationRepositoryProvider).watchAll();
});

// ────────────────────────────────────────────────────────────
// P1 (Theme-Load, GLM-5.2 Review): Theme-Service.
// Hält SharedPreferences (schnell, UI) und Drift-DB (Sync,
// Cross-Device) konsistent. SharedPreferences ist die Source-of-
// Truth beim App-Start; DB ist nachrangig und nur für Sync.
class ThemeService {
  final SharedPreferences _prefs;
  final AppDatabase _db;

  ThemeService(this._prefs, this._db);

  /// Liest das aktuelle Theme aus SharedPreferences.
  /// Fallback: ThemeMode.system.
  ThemeMode loadThemeMode() {
    final stored = _prefs.getString('app.theme_mode');
    switch (stored) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// Speichert das Theme: SharedPreferences synchron (sofort für die
  /// nächste Frame), DB-Update im Hintergrund (für Sync / Cross-Device).
  /// Bewusst fire-and-forget — die DB ist nachrangig.
  Future<void> setThemeMode(ThemeMode mode) async {
    final value = _serializeThemeMode(mode);
    // 1) SharedPreferences: synchron, schnell, UI-relevant
    await _prefs.setString('app.theme_mode', value);

    // 2) DB: asynchron, für zukünftige Sync. Fehler hier NICHT
    //    propagieren — die UI hat bereits den korrekten Wert.
    try {
      await _db.updateSettings(theme: value);
    } catch (_) {
      // Bewusst geschluckt: SP ist Source-of-Truth, DB ist optional.
    }
  }

  String _serializeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}

final themeServiceProvider = Provider<ThemeService>((ref) {
  return ThemeService(
    ref.watch(sharedPreferencesProvider),
    ref.watch(databaseProvider),
  );
});

/// P1: Stellt den aktuellen ThemeMode als State bereit.
/// Bei Änderungen über [ThemeService.setThemeMode] wird der State
/// nicht automatisch aktualisiert — der aufrufende Widget-Code muss
/// `ref.read(themeServiceProvider).setThemeMode(...)` aufrufen und
/// anschließend ein `setState` oder `ref.invalidate` durchführen.
/// (Der Settings-Screen kann das hier nutzen, sobald er das
/// Theme-UI nachgerüstet bekommt — siehe TODO.)
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ref.watch(themeServiceProvider).loadThemeMode();
});