# Fehlerbehebung Küchenhelfer (Kitchen Companion)

Dieses Dokument beschreibt die Fehler, die im Quellcode analysiert und behoben wurden.

## 1. Kompilierungsfehler in den Widget-Tests
* **Datei:** `test/widget_test.dart`
* **Problem:** Der Test verwendete die nicht existierende Klasse `MyApp` (Standard-Boilerplate von Flutter). Die Hauptanwendungsklasse heißt jedoch `KitchenCompanionApp`.
* **Behebung:**
  * Der Test wurde komplett aktualisiert, um ein `HomeScreen`-Widget zu initialisieren.
  * Hierfür wurde eine In-Memory-Datenbank (`AppDatabase.forTesting`) instanziiert und an den `HomeScreen` übergeben.
  * Lokalisierungs-Delegates und die deutsche Locale wurden explizit hinzugefügt, damit das Widget mit den korrekten Übersetzungen geladen und getestet werden kann.
  * Die Test-Assertion verifiziert nun erfolgreich die Anzeige der Texte "Rezepte" und "Keine Rezepte vorhanden".

## 2. Laufzeitfehler bei Datenbank-Tests unter Linux
* **Datei:** `test/database_test.dart`
* **Problem:** Die Datenbank-Tests schlugen unter Linux fehl, da die native Bibliothek `libsqlite3.so` nicht geladen werden konnte (Fehlermeldung: `Failed to load dynamic library 'libsqlite3.so'`). Auf vielen Linux-Systemen ist standardmäßig nur die Release-Bibliothek (z.B. `libsqlite3.so.0`) installiert, während drift nach dem Entwickler-Symlink `libsqlite3.so` sucht.
* **Behebung:**
  * Imports für `dart:ffi` und `package:sqlite3/open.dart` hinzugefügt.
  * In der `main()`-Funktion wurde ein dynamischer Override registriert:
    ```dart
    open.overrideFor(OperatingSystem.linux, () {
      return DynamicLibrary.open('libsqlite3.so.0');
    });
    ```
  * Dadurch wird zur Laufzeit unter Linux gezielt nach der vorhandenen Systembibliothek `libsqlite3.so.0` gesucht.

## 3. Lint-Warnungen (Static Analysis)
* **Datei:** `lib/database/database.dart`
* **Problem:** Die statische Analyse gab die Warnung `use_super_parameters` für den Test-Konstruktor `AppDatabase.forTesting(QueryExecutor e) : super(e);` aus.
* **Behebung:**
  * Der Konstruktor wurde auf die moderne Dart-Syntax umgestellt: `AppDatabase.forTesting(super.e);`.
