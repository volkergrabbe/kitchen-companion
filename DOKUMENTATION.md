# DOKUMENTATION — Kitchen Companion

## Architektur

Local-first Flutter App für Rezepte, Einkaufsliste und Ernährungstagebuch.
Keine Cloud, keine Auth, keine Telemetrie.

### Tech Stack
- Flutter 3.24.5 (Dart 3.5.4)
- Drift ORM (v2.18) + SQLite (sqlite3_flutter_libs)
- Material 3 Design
- l10n: Deutsch + Englisch (ARB-Dateien)

### Schema (7 Tabellen)
| Tabelle | Zweck | Indices |
|---------|-------|---------|
| Ingredients | Zutaten (sprachunabhängig) | idx_ingredients_name |
| IngredientTranslations | i18n Namen | idx_translations_ingredient + UNIQUE(ingredientId, locale) |
| RecipeIngredients | Rezept-Zutaten Verknüpfung | idx_recipe_ingredients_recipe, idx_recipe_ingredients_ingredient |
| Recipes | Rezepte | — |
| ShoppingListItems | Einkaufsliste | idx_shopping_checked |
| FoodLogEntries | Ernährungstagebuch | idx_foodlog_date |
| AppSettings | Singleton-Einstellungen (id=1) | — |

### Foreign Keys
- **PRAGMA foreign_keys = ON** aktiviert in `beforeOpen` Callback
- RecipeIngredients: CASCADE on delete
- ShoppingListItems, FoodLogEntries: SET NULL on delete
- IngredientTranslations: references Ingredients (FK aktiv, onDelete Default)

## Red Team Audit (2026-06-21)

Zwei parallele adversarielle Agenten analysierten den Code. 29 Issues gefunden (7 P0, 8 P1, 6 P2, 8 P3).

### Behobene P0 (Critical)
1. **FK-Engine nicht aktiviert** — `PRAGMA foreign_keys = ON` in `beforeOpen` hinzugefügt. Alle REFERENCES/CASCADE/SET NULL waren vorher toter Code.
2. **upsertSettings Race Condition** — `insertOnConflictUpdate` statt Read-then-Write. Verhindert UNIQUE PK violation Crash.
3. **supportedLocales-Crash** — Reduziert von 10 auf 2 Locales (de, en), da nur 2 ARB-Dateien existieren. Bei fr/es/it/etc. wäre `AppLocalizations.of(context)!` null gewesen → Crash.
4. **Leere TODO-Handler** — CRUD-Dialoge für Add Recipe, Add Shopping Item, Add Food Log, Settings Picker (Language, Units, Theme, Calorie/Protein/Carbs/Fat Goals) implementiert.
5. **_initializeApp Error-Swallowing** — try/catch mit `debugPrint` statt silent fail.
6. **dispose-Reihenfolge** — Korrekt: `_db.close()` vor `super.dispose()` (Flutter-Standard).
7. **mealType Roh-String** — Übersetzung via `_mealTypeLabel()` → `l10n.mealTypeBreakfast` etc.

### Behobene P1 (High)
1. **mounted-Checks** — `if (!mounted) return;` nach jedem `await` in `_initializeApp()`.
2. **updateRecipe ohne source-Validierung** — Identischer Check wie `insertRecipe`.
3. **Keine try/catch in UI-Callbacks** — `_runDbOp()` Wrapper mit SnackBar-Fehlerfeedback.
4. **DatePicker lastDate** — +365 Tage Zukunft erlaubt (Meal-Prep/Planung).
5. **clearCheckedItems ohne Bestätigung** — Bestätigungsdialog hinzugefügt.
6. **StreamBuilder Error-UI** — Lokalisierte Fehlermeldung statt `Error: ${snapshot.error}`.

### Behobene P2 (Medium)
1. **onUpgrade leer** — Kommentar für zukünftige Migrationen (stepByStep bei schemaVersion > 1).
2. **Keine Indices** — 7 `@TableIndex` Annotations auf allen häufig gefilterten Spalten.
3. **date ohne Format-Validierung** — RegExp `^\d{4}-\d{2}-\d{2}$` in insert/update.
4. **AppSettings.id** — `insertOnConflictUpdate` forciert `id: Value(1)`.

### Behobene P3 (Low)
1. **sqlite3 dep** — `sqlite3: ^2.4.0` zu pubspec.yaml hinzugefügt.
2. **Test await** — `await` vor async Inserts in Stream-Tests + `predicate` statt `anything`.
3. **const constructors** — `const RecipesCompanion(...)`, `const FoodLogEntriesCompanion(...)`, `const AppSettingsCompanion(...)`.
4. **_now() static** — `static int _now()`.
5. **Settings Roh-Werte** — Lokalisierte Anzeige (Deutsch/English, Metrisch/Imperial, System/Hell/Dunkel).
6. **FAB Text→Icon** — `Icon(Icons.add)` statt `Text(l10n.addRecipe)`.
7. **Colors.grey→Theme** — `Theme.of(context).colorScheme.outline` für Dark-Mode-Kompatibilität.

## Entscheidungen
- **FKs manuell + PRAGMA**: Defense-in-Depth. Manuelle Cascade in `deleteRecipe` bleibt als Safety-Net.
- **2 Locales statt 10**: Nur ARB-Dateien = nur Locales. Andere Sprachen bei Bedarf ARB hinzufügen + supportedLocales erweitern.
- **insertOnConflictUpdate**: Atomarer Upsert ohne Race Condition, Drift native.

## Changelog
- 2026-06-21: Red Team Audit + alle Fixes. Analyzer: 0 Issues. Tests: 28/28 bestanden.
