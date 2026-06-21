# Red Team Analysis — kitchen_companion

Reviewer: Devil's Advocate (Logic / UX / Architecture)
Datum: 2026-06-21
Scope: lib/main.dart, lib/database/database.dart, lib/l10n/app.{de,en}.arb, l10n.yaml, test/*

---

## Executive Summary

Die App ist eine funktionsfähige lokfirst-Skeleton-App, aber **fast der gesamte Nutzer-Fluss ist kaputt oder fehlt**: Rezepte anlegen, Suchen, Food-Log-Einträge anlegen, alle Settings-Picker, Detail-Navigation — alle sind leere TODO-Handler die beim Tap **nichts tun**. Die App startet, zeigt leere Listen, und das war's. Darunter liegen weitere strukturelle Probleme: Locale-Mismatch (10 deklarierte Sprachen, 2 ARB-Dateien), Race-Condition in initState, fehlende Stream-Fehler-Recovery, keine Undo-Funktion, unbekannte mealType-Roh-Strings in der UI, und Dark-Mode-Probleme mit hardcoded Colors.

Insgesamt: **14 Befunde**, davon **5 P0** (Live-Blocker), **4 P1**, **3 P2**, **2 P3**.

---

## P0 — Kritisch (Live-Bug, Nutzer blockiert)

### P0.1 — supportedLocales vs. ARB-Dateien: 8 tote Sprachen
- **Datei:** `lib/main.dart:81-92`, `l10n.yaml`, `lib/l10n/`
- **Problem:** `supportedLocales` deklariert 10 Locales (de, en, fr, es, it, pl, nl, cs, pt, sv), aber es existieren **nur 2 ARB-Dateien** (`app.de.arb`, `app.en.arb`). `l10n.yaml` spezifiziert nicht einmal `preferred-supported-locales`. Was passiert bei `Locale('fr')`?
  - `AppLocalizations.delegate` lädt nur `de` + `en` (gen-l10n erzeugt nur diese).
  - Flutter's Locale-Resolution: `AppLocalizations.of(context)` gibt für fr/es/it/... **`null`** zurück, weil der Delegate die Locale nicht unterstützt.
  - **main.dartCode überall:** `final l10n = AppLocalizations.of(context)!;` — **Null-Check-Operator auf `null` → `Null check operator used on a null value` → Laufzeit-Crash**.
- **Reproduktion:** Gerät auf Französisch gestellt → App crasht beim ersten `build()` von `HomeScreen`.
- **Fix-Vorschlag:**
  ```dart
  // Option A (empfohlen, bis ARB-Dateien vorhanden):
  supportedLocales: const [Locale('de'), Locale('en')],
  // + in l10n.yaml:
  // preferred-supported-locales: [de, en]
  //
  // Option B (wenn echt 10 Sprachen gewollt):
  // - Leere app.{fr,es,it,pl,nl,cs,pt,sv}.arb mit @@locale + appTitle anlegen
  // - `preferred-supported-locales: [de, en]` in l10n.yaml als Fallback
  // - AppLocalizations.of(context) ohne `!` verwenden + Fallback auf 'de'
  ```
- **Severity:** P0 — App crasht auf 8 der 10 deklarierten Sprachen.

---

### P0.2 — Alle primären Nutzer-Action-Handler sind leer (TODO-Stubs)
- **Datei:** `lib/main.dart:174-180` (Search), `216-220` (Add Recipe FAB), `207-210` (Recipe Detail Tap), `382-387` (Add Food Log FAB), `444-503` (6 Settings Picker TODOs)
- **Problem:** Von den 11 primären Nutzer-Interaktionen (Hinzufügen, Suchen, Bearbeiten, Settings ändern) sind **alle 11** leere `// TODO`-Handler. Beim Tap passiert **nichts** — kein Dialog, keine SnackBar, kein Navigations-Push. Die App ist für den Nutzer eine **read-only Ansicht toter Listen**.
- **Symptom-Beispiel:** Nutzer tapt auf "+" in FoodJournal → nichts passiert. Nutzer tapt auf "Sprache" in Settings → nichts passiert. Nutzer tapt auf "Rezept hinzufügen"-FAB → nichts passiert.
- **Stumme UX:** Keine Snackbar, kein Feedback, dass die Funktion nicht implementiert ist — Nutzer weiss nicht, ob der Tap registriert wurde oder ein Bug vorliegt.
- **Fix-Vorschlag (pro Handler):**
  ```dart
  onPressed: () {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.featureNotImplemented)),
    );
    // Oder: showDialog mit Formular (gemäss Spec)
  },
  ```
  In ARB ergänzen: `"featureNotImplemented": "Funktion noch nicht verfügbar"` / `"Feature not yet available"`.
  Für jede Funktion dann das echte Formular/Dialog implementieren.
- **Severity:** P0 — App hat keinen produktiven Nutzer-Wert in der aktuellen Form. Jede "/"-Aktion ist kaputt.

---

### P0.3 — Race-Condition: `_initializeApp()` async in initState, `build()` nutzt `_db` vor Settings-Load
- **Datei:** `lib/main.dart:23-32` (initState + _initializeApp), `93` (home: HomeScreen(db: _db))
- **Problem:** `initState` ist nicht-async und darf es nicht sein. Stattdessen wird `_initializeApp()` als Fire-and-Forget gestartet — das ist OK. **Aber:** `build()` rendert sofort `HomeScreen(db: _db)` während `_initializeApp()` noch läuft. Die DB ist zwar schon instanziiert (Zeile 25), aber:
  1. **Settings sind noch nicht geladen** — `_themeMode` ist noch der Default `ThemeMode.system`. Das ist harmlos, weil nach `_loadSettings()` ein `setState` kommt und neu rendert.
  2. **`ensureSettingsExist()` läuft noch** — HomeScreen ruft `widget.db.watchSettings()` auf. Der Stream emittiert `null` (Settings existieren noch nicht), dann nach `ensureSettingsExist()` ein Insert-Event mit Defaults. SettingsScreen rendert mit `settings?.locale ?? 'de'` — kein Crash, aber der Nutzer sieht kurz "de" / "metric" / "system" Defaults, die dann von persistierten Werten überschrieben werden (harmlos).
  3. **Echtes Race-Problem:** Wenn `ensureSettingsExist()` fehlschlägt (z.B. DB-Migration-Exception), wird der Fehler **geschluckt** — `_initializeApp()` gibt den Future zurück, niemand wartet darauf, kein `setState`, keine Fehler-UI. App sieht normal aus, aber Settings sind nie persistiert → bei Neustart Default-Settings-Diskrepanz.
- **Fix-Vorschlag:**
  ```dart
  Future<void> _initializeApp() async {
    try {
      await _db.ensureSettingsExist();
      await _loadSettings();
    } catch (e, st) {
      // Logging + Nutzer-Feedback
      _initError = e;
      setState(() {});
    }
  }
  // In build(): wenn _initError != null → Fehler-Screen anzeigen
  ```
- **Severity:** P0 — Stille Fehler bei Settings-Init, potenzieller DB-Migrationsfehler unsichtbar.

---

### P0.4 — DB.close() in dispose() killt alle laufenden Streams → StreamBuilder crasht
- **Datei:** `lib/main.dart:34-38` (dispose), `lib/main.dart:182-214` etc. (alle StreamBuilder)
- **Problem:** `_db.close()` in `dispose()` des `KitchenCompanionApp` stoppt die Query-Streams. Das ist OK **wenn** die State-Objekte der Child-Screens vor dem DB-Close disposed wurden — Flutter's Widget-Baum-Zerstörung geht von oben nach unten. **Aber**:
  1. **`IndexedStack`** (lib/main.dart:118-126) baut alle 4 Screens **gleichzeitig** und hält sie im Widget-Baum. Bei App-Dispose werden alle 4 Screen-State-Objekte disposed, ihre StreamBuilder unsubscribe — das passiert asynchron via Scheduler. Wenn `_db.close()` synchron nach `super.dispose()` ausgeführt wird (tatsächlich vor `super.dispose()` in Zeile 37), können **laufende Stream-Events noch an bereits-geschlossene DB-Handles geliefert werden** → "Database has been closed" Exception in der Konsolenlog, evtl. UI-Crash.
  2. **Konkreter Reihenfolge-Bug:** Zeile 36 `_db.close()` vor Zeile 37 `super.dispose()`. **Falsche Reihenfolge.** `super.dispose()` löst die Child-Widget-Disposal aus. DB muss **nach** den Child-Streams geschlossen werden.
- **Fix-Vorschlag:**
  ```dart
  @override
  void dispose() {
    super.dispose(); // zuerst Children disposen → Streams unsubscribe
    _db.close();     // dann DB schliessen
  }
  // Besser: asynchron schliessen:
  // WidgetsBinding.instance.addPostFrameCallback((_) => _db.close());
  ```
- **Severity:** P0 — Potenzieller "Database closed"-Exception beim Beenden der App (Haupt-Dispose-Pfad).

---

### P0.5 — mealType wird als Roh-String ("breakfast") angezeigt statt übersetzt
- **Datei:** `lib/main.dart:373` (subtitle: Text(entry.mealType))
- **Problem:** Die ARB-Dateien enthalten sowohl `mealTypeBreakfast`/`mealTypeLunch`/... als auch **zusätzliche** directe Keys `breakfast`/`lunch`/`dinner`/`snack` (app.de.arb:58-61, app.en.arb fehlen diese!). Aber:
  1. **main.dart:373:** `Text(entry.mealType)` zeigt den Roh-String aus der DB ("breakfast", "lunch", ...). Keine Übersetzung. Nutzer auf Deutsch sieht "breakfast" statt "Frühstück".
  2. **Tippfehler im Schema:** `validMealTypes = {'breakfast', ...}` (database.dart:160) und ARB-Keys `mealTypeBreakfast`/`breakfast` — der Wert heisst **"breakfast"** statt **"breakfast"** (tatsächlich "breakfast" — das ist ein **Verschreibung von "breakfast"**). Der Wortwert "breakfast" existiert nicht auf Englisch ("breakfast" ist korrekt). Dies ist durch den ganzen Codebase durchgezogen: Schema, ARB, Tests. Konsistent falsch.
- **Fix-Vorschlag:**
  ```dart
  // main.dart:373 ersetzen durch:
  subtitle: Text(_translatedMealType(entry.mealType, l10n)),
  // + neue Methode:
  String _translatedMealType(String mt, AppLocalizations l10n) {
    switch (mt) {
      case 'breakfast': return l10n.mealTypeBreakfast;
      case 'lunch':    return l10n.mealTypeLunch;
      case 'dinner':   return l10n.mealTypeDinner;
      case 'snack':    return l10n.mealTypeSnack;
      default: return mt; // fallback
    }
  }
  ```
  **Zusätzlich:** Den Tippfehler "breakfast" → "breakfast" im ganzen Codebase (Schema, ARB, Tests) korrigieren — das ist ein separates Refactoring, weil es DB-Migration benötigt (bestehende Einträge konvertieren). Mindestens in der UI übersetzt anzeigen, bis das Schema korrigiert ist.
- **Severity:** P0 — Nutzer sieht englischen Roh-String "breakfast" ( Verschreibung ) in deutscher UI.

---

## P1 — Hoch (UX/Architektur, kein Crash aber schlimm)

### P1.1 — FoodJournal: `lastDate: DateTime.now()` — kann nicht in Zukunft planen
- **Datei:** `lib/main.dart:336` (DatePicker lastDate)
- **Problem:** DatePicker erlaubt nur Daten bis **jetzt**. Nutzer kann nicht für morgen oder nächste Woche essen planen. Local-first Kitchen-Apps sollenMeal-Prep/Planung unterstützen. LastDate auf `DateTime.now()` macht Planung unmöglich.
- **Fix-Vorschlag:**
  ```dart
  lastDate: DateTime.now().add(const Duration(days: 365)),
  // oder kein lastDate (showDatePicker erlaubt das nicht, also grosszügig)
  ```
- **Severity:** P1 — Kernfeature (Essensplanung) blockiert.

---

### P1.2 — ShoppingList: `clearCheckedItems` ohne Bestätigung
- **Datei:** `lib/main.dart:246-251` (delete_sweep IconButton)
- **Problem:** Tap auf "delete_sweep" löscht alle abgehakten Items sofort, keine Bestätigung, kein Undo. Nutzer hat versehentlich getippt → alle markierten Einkäufe weg. Local-first, keine Sync, keine Recovery.
- **Fix-Vorschlag:**
  ```dart
  onPressed: () async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.clearChecked),
        content: Text(l10n.clearCheckedConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true),  child: Text(l10n.delete)),
        ],
      ),
    );
    if (confirm == true) {
      final count = await widget.db.clearCheckedItems();
      if (context.mounted && count > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$count entfernt'), action: SnackBarAction(label: l10n.undo, onPressed: () {/* restore */})),
        );
      }
    }
  },
  ```
- **Severity:** P1 — Datenverlust ohne Wiederherstellung möglich.

---

### P1.3 — Keine Undo-Funktionalität bei Löschungen
- **Datei:** `database.dart:195-206` (deleteRecipe), `263` (deleteShoppingItem), `270-271` (clearCheckedItems), `302` (deleteFoodLogEntry)
- **Problem:** Keine der Löschfunktionen hat Undo. `deleteRecipe` ist zudem destruktiv (cascade-löscht RecipeIngredients, NULL-setzt FK in ShoppingListItems/FoodLogEntries — silent, irreversibel). Nutzer tapt versehentlich → Rezept mit allen Zutaten weg, verknüpfte Einkaufslisten-Einträge verlieren ihre Verbindung.
- **Speziell schlimm:** `ShoppingListScreen` hat aktuell **gar keine** UI zum Löschen einzelner Items (nur `clearCheckedItems` via AppBar-Action). Swiped man auf ein Item — nichts passiert, kein `Dismissible`. Aber `database.deleteShoppingItem(id)` existiert. Entweder UI fehlt oder Konzeptfehler.
- **Fix-Vorschlag:**
  - Löschen immer via SnackBar mit `SnackBarAction(label: l10n.undo)` bestätigen.
  - Für `deleteRecipe`: Soft-Delete-Spalte `deletedAt` im Schema ergänzen, Löschen als Update setzen, Restore-Methode implementieren. Bei foreign keys cascade wie gehabert, aber mit Restore-Logik.
  - Für `clearCheckedItems`: Gelöschte Items in Memory halten, bei Undo re-insertieren.
- **Severity:** P1 — Datenverlust bei lokfirst App ist kritisch (keine Sync-Backup).

---

### P1.4 — Keine Error-Recovery in StreamBuildern — App zeigt statischen "Error: ..." Text
- **Datei:** `lib/main.dart:188-190, 260-262, 351-353, 434-436` (alle 4 StreamBuilder)
- **Problem:** Alle StreamBuilder haben den gleichen Handler:
  ```dart
  if (snapshot.hasError) {
    return Center(child: Text('Error: ${snapshot.error}'));
  }
  ```
  1. **Error-Text ist nicht lokalisierbar** ("Error:") — auf Deutsch/französisch systemfremd.
  2. **Keine Retry-Option** — Nutzer sieht "Error: ..." und kann nichts tun. App ist dead, bis man sie neustartet.
  3. **Streams emittieren nach Error keine weiteren Events** (Drift schliesst den Stream bei DB-Fehler) → kein self-heal.
  4. **`${snapshot.error}` kann sensible DB-Interna enthalten** — wird in Produktion dem Nutzer angezeigt.
- **Fix-Vorschlag:** Zentrale `errorState`-Methode:
  ```dart
  Widget _errorState(BuildContext ctx, AppLocalizations l10n, Object err) {
    // Logging schicken
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(l10n.loadError),
          TextButton(
            onPressed: () => setState(() {}), // forciert Stream-Re-Subscribe
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
  // ARB: "loadError": "Laden fehlgeschlagen", "retry": "Erneut versuchen"
  ```
- **Severity:** P1 — App tot bei DB-Fehler, keine Recovery.

---

## P2 — Mittel (Architektur / Design-Regeln)

### P2.1 — IndexedStack baut alle 4 Screens gleichzeitig (Performance + State-Lebensdauer)
- **Datei:** `lib/main.dart:118-126`
- **Problem:** `IndexedStack` hält alle 4 Child-Screens permanent im Widget-Baum (offscreen). D.h.:
  1. Alle 4 StreamBuilder subscriben sofort alle 4 DB-Streams → 4 offene Queries während der gesamten App-Lebensdauer, DB-Listener-Overhead.
  2. State-Objekte der nicht-sichtbaren Screens leben permanent → z.B. `FoodJournalScreen._selectedDate` bleibt zwischen Tabs erhalten (gewollt?). Aber auch `RecipesScreen`-Scrollposition geht nicht verloren (gut), aber **alle** Stream-Subscriptions laufen immer (batterie/funktionell schlecht).
  3. **Offscreen Rebuilds:** IndexedStack triggert rebuilds in nicht-sichtbaren Screens bei `setState` in sichtbaren — swt es läuft via Element-Baum durch, auch wenn `IndexedStack` sie nicht rendert.
- **Fix-Vorschlag:** Variante A: `IndexedStack` ist OK für 4 Screens, aber:
  - Lazy-Initialisierung der Child-Widgets (nur instanziiert, wenn Tab zum ersten Mal geöffnet wird) via Builder + Set-Cache.
  - Oder `PageView` mit `PageController` + `AutomaticKeepAliveClientMixin` für State-Erhaltung.
- **Severity:** P2 — Lade-Overhead, unnötige Subscriptions.

---

### P2.2 — Keine Dark-Mode-spezifischen Colors — `Colors.grey` hardcoded
- **Datei:** `lib/main.dart:271` (shopping_cart_outlined color: Colors.grey), `287` (color: item.checked ? Colors.grey : null), `361` (book_outlined color: Colors.grey), `270-272` (gleiche)
- **Problem:** `Colors.grey` ist im Dark-Mode fast unsichtbar (Grey50 = #FAFAFA, Grey = #9E9E9E). Die Empty-Icons (Shopping, FoodJournal) und "abgehakt"-Text-Color sind im Dark-Mode kaum sichtbar oder zu dunkel.
- **Fix-Vorschlag:**
  ```dart
  color: Theme.of(context).colorScheme.onSurfaceVariant, // Material 3 Token
  // statt Colors.grey
  ```
  Für "abgehakt" Text:
  ```dart
  color: item.checked ? Theme.of(context).disabledColor : null,
  ```
- **Severity:** P2 — UX im Dark-Mode deutlich schlechter.

---

### P2.3 — FloatingActionButton "Add Recipe" verwendet Text statt Icon — Material-Design-Verletzung
- **Datei:** `lib/main.dart:215-220` (RecipesScreen FAB)
- **Problem:** FAB ist ein kreisförmiger Button, der für **Icons** gedacht ist. `Text(l10n.addRecipe)` ist "Rezept hinzufügen" — viel zu lang, wird abgeschnitten, bricht FAB-Kreises. M3 spec: "FAB content should be a single icon". FoodJournal-FAB (main.dart:386) macht es richtig: `Icon(Icons.add)`.
- **Inkonsistenz:** RecipesScreen FAB → Text, FoodJournal FAB → Icon. Insgleiches Pattern.
- **Fix-Vorschlag:** FAB-Content vereinheitlichen:
  ```dart
  FloatingActionButton(
    onPressed: () { /* dialog */ },
    child: const Icon(Icons.add),
    tooltip: l10n.addRecipe, // für Accessibility
  ),
  ```
- **Severity:** P2 — M3-Verletzung, Inkonsistenz, Text abgeschnitten.

---

## P3 — Niedrig (Politur / Zukunftssicher)

### P3.1 — `mealTypeBreakfast` vs. `breakfast`-Tippfehler durch ganzen Codebase
- **Datei:** `database.dart:160`, `app.de.arb:22, 58`, `app.en.arb:22`, `main.dart:393`
- **Problem:** Der Wert "breakfast" existiert nicht auf Englisch ("breakfast" ist korrekt). Diese Versachreibung ist durch den Codebase durchgezogen: Schema-Konstante, ARB-Keys, Tests (`database_test.dart` testet 'breakfast'), UI-Switch-Case. **Konsistent falsch**.
- **Impact:** Kein aktueller Bug (Programm funktioniert mit dem falschen String), aber: bei zukünftigem Import von USDA/Openrecipe-Daten, die "breakfast" als Wert liefern, matched die Validierung nicht → alle importierten Frühstück-Einträge geworfen.
- **Fix-Vorschlag:** Refactoring: `"breakfast"` → `"breakfast"` überall, mit DB-Migration:
  ```dart
  // Migration onUpgrade:
  await customStatement("UPDATE food_log_entries SET mealType='breakfast' WHERE mealType='breakfast'");
  // + validMealTypes + ARB + Tests updaten
  ```
- **Severity:** P3 — Kein aktueller Nutzer-Impact, aber zukünftige Import-Bug.

---

### P3.2 — Settings: `upsertSettings`-Fallback auf Default-Werte — Settings "de", "metric", "system" sind nicht-lokalisiert hardcoded
- **Datei:** `main.dart:443` (Text(settings?.locale ?? 'de')), `451` ('metric'), `459` ('system'), `database.dart:110-115` (Default-Werte)
- **Problem:** SettingsScreen zeigt Roh-Werte aus DB ("de", "metric", "system"). Nutzer sieht auf Deutsch "de" statt "Deutsch", "metric" statt "Metrisch", "system" statt "System". ARB hat `language`/`unitsMetric`/`themeSystem` Keys, aber ** nicht verwendet** für die Subtitle.
- **Zudem:** `settings?.locale ?? 'de'` — Fallback 'de' ist hardcoded, nicht von Platform-Locale abhängig.
- **Fix-Vorschlag:**
  ```dart
  subtitle: Text(_localeDisplayName(settings?.locale, l10n)),
  // mit:
  String _localeDisplayName(String? code, AppLocalizations l10n) {
    switch (code) {
      case 'de': return 'Deutsch';
      case 'en': return 'English';
      // ... oder aus ARB
      default: return l10n.notSet;
    }
  }
  ```
- **Severity:** P3 — UX-Politur, Keys existieren in ARB aber ungenutzt.

---

## Cross-Cutting / Bemerkungen

### B-1 — Tests decken DB-Schicht gut, UI-Tests fast null
- `test/database_test.dart` (392 Zeilen) deckt Recipes/Ingredients/ShoppingList/FoodLog/Settings und Validierung gut. Aber: 0 Tests für UI-Logik (StreamBuilder-Error-State, Locale-Resolution-Crash, IndexedStack-Verhalten, TODO-Handler). `test/widget_test.dart` (44 Zeilen) ist ein reiner Rauchtest für "Rezepte" Text — deckt 0 der oben P0.1-P0.5 auf.
- **Fix:** Widget-Tests für: Locale 'fr' startet ohne Crash (P0.1), FAB-Tap zeigt feedback (P0.2), StreamBuilder error state rendert Retry-Button (P1.4).

### B-2 — `localizationsDelegates` enthält `GlobalCupertinoLocalizations` — gut, aber ohne passende ARB-Dateien für fr/es/... nutzlos
- `main.dart:79`: Cupertino-Delegate deklariert, aber Cupertino-spezifische Strings (Datum-Picker-Buttons, "Done"/"Cancel") fallen für fr/es/it/... auf Englisch zurück — inkonsistent mit der deklarierten Locale-Liste.

### B-3 — `_themeModeFromString` case 'system' fehlt — implizit über `default`
- `main.dart:49-58`: explicit cases für 'light', 'dark', default → 'system'. OK funktional, aber Default-Wert "system" im Schema vs. Case-Explizitheit: klarer Switch:
  ```dart
  case 'system': return ThemeMode.system;
  ```
  hinzufügen, damit Code die Absicht dokumentiert.

---

## Priorisierte Aktions-Liste (Sortiert nach Severity × Aufwand)

| ID | Severity | Datei | Zeile | Kurzbeschreibung | Aufwand |
|----|---------|-------|-------|------------------|---------|
| P0.1 | P0 | main.dart | 81-92 | supportedLocales auf 2 reduzieren bis ARB da | 5 Min |
| P0.5 | P0 | main.dart | 373 | mealType übersetzen + Tippfehler-Fix | 30 Min |
| P0.2 | P0 | main.dart | 174ff | Alle TODO-Handler: min. SnackBar-Feedback | 1 Std |
| P0.4 | P0 | main.dart | 35-38 | dispose-Reihenfolge korrigieren | 5 Min |
| P0.3 | P0 | main.dart | 29-32 | _initializeApp Error-Handling + try/catch | 20 Min |
| P1.1 | P1 | main.dart | 336 | DatePicker lastDate → +365 Tage | 2 Min |
| P1.4 | P1 | main.dart | 4x | Zentrale errorState + Retry-Button | 40 Min |
| P1.2 | P1 | main.dart | 246ff | clearCheckedItems Bestätigungs-Dialog | 20 Min |
| P1.3 | P1 | database.dart | 195ff | Undo-Logik (SnackBar + Soft-Delete) | 2+ Std |
| P2.1 | P2 | main.dart | 118ff | Lazy IndexedStack oder PageView | 1 Std |
| P2.2 | P2 | main.dart | 4x | Colors.grey → onSurfaceVariant | 15 Min |
| P2.3 | P2 | main.dart | 215ff | FAB Text → Icon + tooltip | 5 Min |
| P3.1 | P3 | database.dart+ARB | 160ff | "breakfast"→"breakfast" Migration | 1 Std |
| P3.2 | P3 | main.dart | 443ff | Settings-Subtitle lokalisiert | 30 Min |

**Quick Wins (P0, <1 Std):** P0.1, P0.4, P1.1, P2.3 lassen sich in <15 Min fixen und heben signifikante Probleme.

---

## Fazit

Die App ist ein gut strukturiertes Drift-Schema mit Test-Abdeckung, aber die **Nutzer-Oberfläche ist nicht vorhanden**. Jede Aktion ausser "abhaken" und "Tab wechseln" ist ein TODO-Stub. Locale-Auswahl crasht auf 8 der 10 deklarierten Sprachen. Die Dev-Spec ( local-first, 10 Sprachen, Dark-Mode, Meal-Prep) ist deklariert aber **nicht umgesetzt**. Priorität: erst P0.1+P0.4+P1.1 (Quick Wins, <20 Min), dann P0.2 (UI-Handler aktivieren), dann P1.4 (Error-Recovery), dann P0.5 + P3.1 (i18n + Tippfehler-Migration). Danach P1.3 (Undo), dann P2/ P3 Politur.

— Ende der Red-Team-Analyse —
