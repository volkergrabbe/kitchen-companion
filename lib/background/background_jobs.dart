// lib/background/background_jobs.dart
//
// Periodische Hintergrund-Jobs via workmanager (Android).
// iOS-Hook: BGTaskScheduler (auskommentiert, v2.0.0 ohne Apple Account).

import 'dart:developer' as developer;
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';

import '../data/database/database.dart';
import '../data/repositories/offer_repository.dart' as data_repo;
import '../data/sources/scraper/discounter_scraper.dart';

const String weeklyRefreshTask = 'kitchen_companion.weekly_refresh';

/// QW3 (GLM-5.2 Runde 2): Debug-Logger statt `print()`/`debugPrint()`.
/// - Nutzt `dart:developer.log` → taucht in Android Logcat mit Tag auf.
/// - In Release-Builds komplett no-op (kDebugMode ist false) → keine
///   unnötige String-Interpolation in der Hot-Path.
/// - Throttled intern durch `developer.log` (vs. `print()`/`debugPrint()`,
///   die bei hoher Frequenz Logcat vollspammen).
void _log(String message, {String name = 'background_jobs'}) {
  if (kDebugMode) {
    developer.log(message, name: name);
  }
}

@pragma('vm:entry-point')
void backgroundDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == weeklyRefreshTask) {
      await BackgroundJobs.refreshOffersAndPlan();
      return true;
    }
    return false;
  });
}

class BackgroundJobs {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        await Workmanager().initialize(
          backgroundDispatcher,
          isInDebugMode: false,
        );
      } catch (e) {
        _log('Workmanager init fehlgeschlagen: $e');
      }
    }

    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _notifications.initialize(initSettings);
  }

  static Future<void> scheduleWeekly() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      try {
        await Workmanager().registerPeriodicTask(
          'weekly_offer_refresh',
          weeklyRefreshTask,
          frequency: const Duration(days: 7),
          constraints: Constraints(
            networkType: NetworkType.connected,
            requiresBatteryNotLow: true,
          ),
        );
      } catch (e) {
        _log('Plan-Schedule fehlgeschlagen: $e');
      }
    }
  }

  static Future<void> runOnce() async {
    await Workmanager().registerOneOffTask(
      'manual_refresh',
      weeklyRefreshTask,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> refreshOffersAndPlan() async {
    AppDatabase? db;
    try {
      db = await _openIsolatedDb();

      final http = DefaultHttpClient();
      final offerRepo = data_repo.OfferRepository(db, http: http);
      final results = await offerRepo.refreshAllOffers();

      final successCount =
          results.values.where((v) => v >= 0).length;
      final failCount = results.values.where((v) => v < 0).length;

      await _showNotification(
        'Kitchen Companion',
        failCount == 0
            ? '$successCount Discounter aktualisiert'
            : '$successCount OK, $failCount fehlgeschlagen',
      );
    } catch (e) {
      await _showNotification(
        'Kitchen Companion – Fehler',
        'Aktualisierung fehlgeschlagen: $e',
      );
    } finally {
      await db?.close();
    }
  }

  static Future<AppDatabase> _openIsolatedDb() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'kitchen_companion_v2.sqlite'));
    final db = AppDatabase.forTesting(NativeDatabase.createInBackground(file));
    return db;
  }

  static Future<void> _showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'kitchen_companion_updates',
      'Wochenplan-Updates',
      channelDescription: 'Benachrichtigungen zu Wochenplan und Angeboten',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const details = NotificationDetails(android: androidDetails);

    try {
      await _notifications.show(0, title, body, details);
    } catch (_) {}
  }
}