// Database tests for Kitchen Companion v2.0.
//
// Uses AppDatabase.forTesting with in-memory NativeDatabase to exercise
// the schema, migrations, and core CRUD operations without touching the
// real filesystem. This is the test pattern used in v1.
//
// libsqlite3.so is provided via the local symlink in ~/.local/lib — see
// .local/lib/libsqlite3.so → /usr/lib/x86_64-linux-gnu/libsqlite3.so.0
// and LD_LIBRARY_PATH at test-run time.

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitchen_companion/data/database/database.dart';

void main() {
  group('Database v2.0 schema', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    test('schemaVersion is 3 (v2+v3 migration)', () {
      expect(db.schemaVersion, 3);
    });

    test('all v2 tables exist and can be queried', () async {
      // Tables introduced in v2.0 — must all be queryable.
      final tables = <String, dynamic>{
        'ingredients': db.select(db.ingredients),
        'recipeIngredients': db.select(db.recipeIngredients),
        'contraindications': db.select(db.contraindications),
        'userContraindications': db.select(db.userContraindications),
        'discounters': db.select(db.discounters),
        'offers': db.select(db.offers),
        'weeklyPlans': db.select(db.weeklyPlans),
        'planMeals': db.select(db.planMeals),
        'planIngredients': db.select(db.planIngredients),
        'userProfile': db.select(db.userProfile),
      };

      for (final entry in tables.entries) {
        // Each query should succeed and return an empty list on fresh DB.
        final rows = await entry.value.get();
        expect(rows, isEmpty, reason: 'Table ${entry.key} should be empty');
      }
    });

    test('ensureSettingsExist creates default settings row', () async {
      await db.ensureSettingsExist();
      final settings = await db.getSettings();
      expect(settings, isNotNull);
      expect(settings!.locale, isNotEmpty);
    });
  });
}