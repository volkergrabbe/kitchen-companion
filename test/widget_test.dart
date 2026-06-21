import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:kitchen_companion/database/database.dart';
import 'package:kitchen_companion/main.dart';
import 'package:sqlite3/open.dart';

void main() {
  // SQLite-Bibliothek für Linux-Umgebung registrieren
  open.overrideFor(OperatingSystem.linux, () {
    return DynamicLibrary.open('libsqlite3.so.0');
  });

  testWidgets('HomeScreen Rauchtest', (WidgetTester tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('de'), Locale('en')],
        home: HomeScreen(db: db),
      ),
    );

    // Warten, bis alles gerendert ist
    await tester.pumpAndSettle();

    // Verifizieren, dass wir die Rezepte-Ansicht sehen (z.B. den Text "Rezepte" oder "Keine Rezepte vorhanden")
    expect(find.text('Rezepte'), findsWidgets);
    expect(find.text('Keine Rezepte vorhanden'), findsOneWidget);

    await db.close();
  });
}

