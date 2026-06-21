# ANWEISUNGEN — Kitchen Companion

## Briefing
Local-first Flutter Kitchen App. Rezepte, Einkaufsliste, Ernährungstagebuch.
Drift ORM + SQLite. Material 3. Lokalisiert (DE/EN).

## Datei-Rollen
| Datei | Rolle |
|-------|-------|
| lib/main.dart | UI: 4 Screens (Recipes, Shopping, FoodJournal, Settings) + CRUD-Dialoge + App-Root |
| lib/database/database.dart | Drift Schema (7 Tabellen) + Queries + Migration + FK-Pragma |
| lib/database/database.g.dart | GENERIERT — nicht manuell editieren. `dart run build_runner build --delete-conflicting-outputs` |
| lib/l10n/app.de.arb | Deutsche Übersetzungen |
| lib/l10n/app.en.arb | Englische Übersetzungen |
| l10n.yaml | l10n-Konfiguration (arb-dir, template, output-class) |
| pubspec.yaml | Dependencies + Flutter-Konfiguration |
| test/database_test.dart | DB-Unit-Tests (28 Tests) |
| test/widget_test.dart | Widget-Rauchtest (HomeScreen) |
| DOKUMENTATION.md | Architektur, Red Team Audit, Entscheidungen |
| RED_TEAM_ANALYSIS.md | Vollständiger Red Team Report (vom Audit-Agent erstellt) |

## Wartungs-Checklisten

### Code ändern
1. `lib/database/database.dart` editieren
2. `dart run build_runner build --delete-conflicting-outputs` ausführen
3. `flutter analyze` — muss "No issues found!" zeigen
4. `flutter test` — muss "All tests passed!" zeigen

### Neue Sprache hinzufügen
1. `lib/l10n/app.<locale>.arb` erstellen (von app.en.arb kopieren)
2. `supportedLocales` in `lib/main.dart` erweitern
3. `flutter gen-l10n` oder `flutter pub get` ausführen

### DB-Schema ändern (Migration)
1. `schemaVersion` in `database.dart` erhöhen
2. `onUpgrade` mit `stepByStep` oder manuellen Migrationen füllen
3. Test schreiben, der alte Schema-Version lädt + migriert
4. build_runner + analyze + test

### Neue Indices
1. `@TableIndex(name: 'idx_', columns: {#col})` auf Table-Klasse
2. `dart run build_runner build --delete-conflicting-outputs`
3. Migration bei bestehenden DBs: `m.customStatement('CREATE INDEX ...')` in `onUpgrade`

## 5-Minuten-Onboarding
1. `flutter pub get`
2. `dart run build_runner build --delete-conflicting-outputs` (falls .g.dart fehlt/veraltet)
3. `flutter analyze` → 0 Issues
4. `flutter test` → 28/28 passed
5. `flutter run` → App startet auf Device/Emulator

## Bekannte TODOs (Feature, nicht Bug)
- Recipe Detail Screen (Tap auf Rezept → Detailansicht)
- Recipe Search (Filter/Sort)
- Ingredient Management UI (nur DB-API vorhanden)
- Recipe-Ingredient Verknüpfung UI
- Export/Import (Backup/Restore)
- Monsieur Cuisine / USDA / OpenRecipe Integration
