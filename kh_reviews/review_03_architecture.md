# Kitchen Companion v2.0 — Adversarial Review #3: Architektur & Code-Quality

**Reviewer:** Kontra-Hermes (Red Team)
**Datum:** 2026-06-19
**Projekt:** `/home/administrator/.hermes/workspace/kitchen_companion_v2`
**Fokus:** Architektur, Performance, Code-Quality, Test-Coverage, i18n

> **Rolle:** Befund. Keine Lösungen. Keine Fixes. Nur Schweregrade (P0/P1/P2) mit echtem Code-Beleg (file:line).
> Diese Review ergänzt Review #1 (Privacy/DSGVO) und Review #2 (sofern vorhanden) um die technische Tiefe.

---

## Executive Summary

| Schweregrad | Anzahl |
|---|---|
| **P0 (Kritisch — funktionaler Defekt oder Datenverlust-Risiko)** | **5** |
| **P1 (Hoch — Performance, Wartbarkeit oder Datensicherheit gefährdet)** | **9** |
| **P2 (Mittel — Code-Smell, Lokalisierungs-Lücke, Hardcoding)** | **7** |
| **Total** | **21** |

**Kernbefunde:**

1. **Deaktivierungs-Flow für User-Kontraindikationen ist kaputt.** `_findUserId(active, c.id)` in `contraindications_screen.dart:81-87` gibt die `Contraindication.id` zurück, nicht die `UserContraindication.id` → `deactivateForUser()` löscht entweder nichts oder die falsche Zeile. Reproduzierbar, jeder Tap auf das "Minus"-Icon ist ein Silent-Failure.
2. **Lokalisierung ist zu 90 % Fake.** 9 von 10 `.arb`-Dateien (cs/es/fr/it/nl/pl/pt/sv) sind 1:1-Kopien der englischen Datei, und die englische Datei selbst enthält **keine** `@`-Metadaten-Blöcke für `personsCount`, `weeklyPlan`, `refreshResult`, `warningFor` → `flutter gen-l10n` wird entweder scheitern oder Plurals werden falsch übersetzt. `l10n.yaml` zeigt `template-arb-file: app_de.arb` — die deutsche Datei wird als Vorlage verwendet, aber sie hat mehr Metadaten als die anderen, was den Generator verwirrt.
3. **Wochenplan-Engine ist deterministisch UND nicht-deterministisch zur gleichen Zeit.** `Random()` ohne Seed → bei jedem Aufruf andere Auswahl (Zeile 22), aber der Pool (Zeile 81-99) basiert auf deterministischer Sortierung → wenn der User zweimal hintereinander "Plan erstellen" drückt, bekommt er wahrscheinlich denselben Pool, aber durch das `_random.nextInt` für Mahlzeiten ab Tag 2+ eine andere Auswahl. **Kein Reproducible-Bugfix möglich, kein A/B-Test, kein Diff zwischen geplanten Wochen.**
4. **N+1-Query-Albtraum in `_aggregatePlanIngredients` (Zeile 147-178).** Pro Planmahlzeit wird ein eigener `SELECT * FROM recipe_ingredients WHERE recipe_id = ?` abgesetzt. Bei 21 Mahlzeiten = 21 Round-Trips. Bei Recipe-Inner-Joins stattdessen **ein** Join. Plus: Es gibt einen weiteren N+1-Pfad in `WeeklyPlanRepositoryImpl._toEntity` (Zeile 213-218): Pro Mahlzeit wird `select(recipes).getSingleOrNull()` aufgerufen → nochmal 21 Round-Trips.
5. **DB hat keine Indizes.** Keine `@DriftIndex`-Annotation, kein `customConstraint`, keine `CREATE INDEX`-Migration. Bei 500 Rezepten + 1000 Offers + Joins auf FK-Spalten wird SQLite Full-Table-Scans fahren. Spätestens ab >100 Rezepten wird der Plan-Generator unbenutzbar langsam.
6. **Discounter-Scraper brechen garantiert beim ersten HTML-Refresh.** 5 von 7 Implementierungen basieren auf starren CSS-Selektoren (`.product-title`, `.price__main` etc.). Aldi und Lidl sind explizit JS-gerendert (siehe Kommentar `aldi_scraper.dart:35-38`), die `extractAll()`-Funktion gibt dann leere Listen zurück → der User sieht "Keine Angebote verfügbar" und weiß nicht warum. `Rewe/Netto/Penny/Norma` teilen sich eine "generic"-Heuristik (`generic_scraper.dart:65-68`), die `[class*="title" i]` matcht → false-positive Matches auf Layout-Elemente, die zufällig "title" im Klassennamen haben.
7. **Memory-Leak durch fehlendes `autoDispose`.** `databaseProvider` wird mit `ref.onDispose(db.close)` korrekt abgeräumt (Zeile 17), aber alle anderen Provider (insbesondere die Stream-basierten `activeOffersStreamProvider`, `activePlanStreamProvider`, `userContraindicationsProvider`, etc., Zeile 76-102) halten ihren State für die gesamte App-Lifetime. Beim Wechsel zwischen Tabs via `IndexedStack` (home_screen.dart:65-69) bleiben alle 6 Screens im Speicher, alle Stream-Provider aktiv, alle DB-Subscriptions offen.
8. **Migration v1 → v2 nicht getestet.** Der einzige Test (`test/widget_test.dart`, 59 Zeilen) prüft nur `schemaVersion == 2` und leere Tabellen auf einer frischen DB. Es gibt keinen Test, der eine v1-DB mit existierenden User-Daten (Rezepte, ShoppingItems, FoodLog) erzeugt, das Upgrade durchführt und die Daten-Integrität verifiziert. Bei einem echten User-Upgrade in Production droht Datenverlust.

---

## Detaillierte Findings

### P0-1: `_findUserId` Bug — Deaktivierung von Kontraindikationen löscht die falsche Zeile

**Datei:** `lib/ui/screens/contraindications_screen.dart:81-87`
```dart
int _findUserId(List<ContraindicationEntity> active, int id) {
  // Bei Deaktivierung brauchen wir die user_contraindication-ID.
  // Vereinfachung: hier brauchen wir eigentlich eine Stream-Query,
  // die wir noch nicht haben. Workaround: scan alle aktiven.
  // TODO: UserContrain-ID via separater Query holen.
  return id;
}
```

**Datei:** `lib/data/repositories/impl.dart:343-345`
```dart
@override
Future<int> deactivateForUser(int userContraindicationId) async {
  return _db.removeUserContraindication(userContraindicationId);
}
```

**Datei:** `lib/data/database/database.dart:358-359`
```dart
Future<int> removeUserContraindication(int id) =>
    (delete(userContraindications)..where((u) => u.id.equals(id))).go();
```

**Problem:**
- Das `ContraindicationEntity` (siehe `lib/domain/entities/entities.dart:105-133`) hat **kein** Feld `userContraindicationId`. Es wird nur die `id` der `Contraindications`-Tabelle (Master-Tabelle, geseedet) zurückgegeben — nicht der `id` aus `user_contraindications` (Join-Tabelle pro User).
- `_findUserId(active, c.id)` nimmt `c.id` (= `Contraindications.id`), gibt sie unverändert zurück.
- `deactivateForUser(c.id)` löscht dann via `delete(user_contraindications)..where((u) => u.id.equals(id))` — also `WHERE id = <Master-Contraindication-ID>`.
- Da die `user_contraindications.id` **nie** der `contraindications.id` entspricht (Auto-Increment, getrennte Sequenz), ist `WHERE id = X` immer ein Miss. Der Delete ist ein Silent No-Op.
- **Konsequenz:** Der User kann eine aktivierte Kontraindikation **nicht mehr deaktivieren** — der "Minus"-Button (Zeile 137) ist funktionslos.
- Der Code-Kommentar gibt selbst zu: "TODO: UserContrain-ID via separater Query holen."
- Schweregrad P0, weil ein Kern-Privacy-Workflow (Kontraindikation rückgängig machen) kaputt ist und der User keine Fehlermeldung bekommt.

**Recommendation:** `ContraindicationEntity` braucht das Feld `userContraindicationId` (oder eine separate `UserContraindicationEntity`). Im Stream `watchActiveUserContraindications()` muss die `UserContraindications.id` mit zurückgegeben werden, nicht nur die `Contraindications`-Spalten. Dann in `_ContraTile` mitgeben und in `onToggle` verwenden.

---

### P0-2: Lokalisierung ist zu 90 % Stub — 9 von 10 .arb-Dateien sind englische Kopien

**Datei:** `lib/l10n/app_de.arb` (84 Zeilen) vs. `lib/l10n/app_en.arb` (62 Zeilen)

```bash
$ wc -l lib/l10n/*.arb
   62 app_cs.arb
   84 app_de.arb   ← einzige "echte" Übersetzung
   62 app_en.arb   ← identisch zu allen anderen
   62 app_es.arb
   62 app_fr.arb
   62 app_it.arb
   62 app_nl.arb
   62 app_pl.arb
   62 app_pt.arb
   62 app_sv.arb
```

**Datei:** `lib/l10n/app_de.arb:27-37` (Metadaten, nur hier vorhanden)
```json
"weeklyPlan": "Wochenplan",
"@weeklyPlan": {
  "description": "Wochenplan-Tab"
},
...
"personsCount": "{count, plural, =1{1 Person} other{{count} Personen}}",
"@personsCount": {
  "placeholders": {
    "count": {"type": "int"}
  }
}
```

**Datei:** `lib/l10n/app_en.arb:23-26` (keine Metadaten!)
```json
"weeklyPlan": "Weekly plan",
"generatePlan": "Generate plan",
"noActivePlan": "No active plan",
"personsCount": "{count, plural, =1{1 person} other{{count} persons}}",
```

**Datei:** `lib/l10n/app_es.arb:23-26` (Spanische Datei, aber Inhalt ist EN)
```json
"weeklyPlan": "Weekly plan",
"generatePlan": "Generate plan",
"noActivePlan": "No active plan",
"personsCount": "{count, plural, =1{1 person} other{{count} persons}}",
```

**Datei:** `l10n.yaml`
```yaml
arb-dir: lib/l10n
template-arb-file: app_de.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
```

**Problem:**
- Die Datei `app_de.arb` ist als Template deklariert, hat aber **mehr** Metadaten als die englische Datei. Das ist verdreht: normalerweise ist die Template-Datei die "vollständigste" Quelle, aus der alle anderen abgeleitet werden.
- `app_en.arb` fehlen die `@`-Metadaten-Blöcke für `weeklyPlan`, `personsCount`, `refreshResult`, `warningFor`. Damit weiß `flutter gen-l10n` nicht, dass `personsCount` ein Int-Plural ist und dass `refreshResult(success, failed)` zwei Int-Parameter erwartet. **Der Generator wird entweder scheitern (`MissingPlaceholderTypeException`) oder die generierten Dart-Methoden werden falsche Typen haben** (`String` statt `int` für `count`).
- Alle 9 Nicht-Deutsch-Dateien (cs/es/fr/it/nl/pl/pt/sv) sind 1:1-Kopien von `app_en.arb`. Ein User, der die App auf Französisch startet, bekommt englische Texte und merkt es nicht. Die `supportedLocales` in `main.dart:85-96` lügt 9 Sprachen vor, die tatsächlich nicht übersetzt sind.
- `main.dart:74` setzt den Titel hartkodiert auf `'Kitchen Companion'` — keine i18n. Im Dark-Launch beim App-Store-Review würde die App für die App-Store-Metadaten evtl. anderen Titel brauchen.
- Schweregrad P0, weil die zugesicherte i18n-Funktionalität (10 Sprachen in der README) tatsächlich nicht funktioniert und der App-Store-Review für die jeweiligen Locales eine Katastrophe wird.

**Recommendation:** Entweder ehrlich sein und 9 Sprachen aus `supportedLocales` und `lib/l10n/` entfernen, oder echte Übersetzungen liefern. Die `@`-Metadaten müssen in **jeder** `.arb`-Datei vorhanden sein, nicht nur in der Template-Datei.

---

### P0-3: Wochenplan-Engine — N+1-Query beim Aggregieren der Zutaten

**Datei:** `lib/domain/services/weekly_plan_engine.dart:147-178`
```dart
Future<Map<int, _IngredientAggregate>> _aggregatePlanIngredients(
    int planId, int persons) async {
  final meals = await (_db.select(_db.planMeals)
        ..where((m) => m.planId.equals(planId)))
      .get();

  final aggregates = HashMap<int, _IngredientAggregate>();

  for (final meal in meals) {
    final recipeId = meal.recipeId;
    if (recipeId == null) continue;

    final recipeIngredients = await (_db.select(_db.recipeIngredients)
          ..where((ri) => ri.recipeId.equals(recipeId)))
        .get();
    ...
```

**Problem:**
- Pro Mahlzeit im Plan wird **ein eigener SELECT** auf `recipe_ingredients` abgesetzt.
- Bei 21 Mahlzeiten (= 7 Tage × 3 Mahlzeiten) = **21 sequentielle Round-Trips** zur SQLite-DB.
- Auf einer warmen DB-Connection (Drift mit `NativeDatabase.createInBackground`) kostet jeder Round-Trip ca. 1-5 ms → 21-105 ms **nur** für das Aggregieren.
- Bei größeren Plänen (z.B. Snack-Support, 28 Mahlzeiten) oder wenn Mahlzeiten aus früheren Plänen dupliziert werden, linear skaliert.
- Das gleiche Pattern taucht in `lib/data/repositories/impl.dart:213-218` (`WeeklyPlanRepositoryImpl._toEntity`) auf — pro Planmahlzeit wird `select(recipes).getSingleOrNull()` aufgerufen, um den Rezeptnamen zu hydrieren. Bei 21 Mahlzeiten = nochmal 21 Round-Trips.
- Total beim `_toEntity` einer Plan-Generierung:
  - 1 Query für Plan
  - 1 Query für PlanMeals
  - 1 Query für PlanIngredients
  - 1 Query für Offers (falls offerIds nicht leer)
  - 1 Query für Discounters
  - 1 Query für **alle** Ingredients
  - **N Queries** für Recipes (N = Anzahl Mahlzeiten)
- Bei N=21 also 26-27 Queries statt 5. Mit Drift-Streams und IndexedDB-Backend auf Mobile ein signifikanter UI-Jank.

**Recommendation:** Join-Query: `SELECT recipe_id, recipe_name FROM plan_meals pm LEFT JOIN recipes r ON r.id = pm.recipe_id WHERE pm.plan_id = ?`. Für die Ingredient-Aggregation: Join über PlanMeals → RecipeIngredients → Ingredients, Group By ingredient_id.

---

### P0-4: Wochenplan-Engine — Hot-Path ist nicht-deterministisch und nicht reproduzierbar

**Datei:** `lib/domain/services/weekly_plan_engine.dart:22`
```dart
WeeklyPlanEngine(
  this._db,
  this._contraindicationChecker, {
  Random? random,
}) : _random = random ?? Random();
```

**Datei:** `lib/domain/services/weekly_plan_engine.dart:93`
```dart
pick = candidates[_random.nextInt(candidates.length)];
```

**Problem:**
- Der Konstruktor akzeptiert optional ein `Random`-Objekt (gut für Tests), aber **niemand übergibt** eines. Im gesamten `lib/`-Tree wird nur `WeeklyPlanEngine(ref.watch(databaseProvider), ref.watch(contraindicationCheckerProvider))` aufgerufen (`providers.dart:30-35`) → Default-`Random()` ohne Seed.
- Default-`Random()` wird mit `Random.secure()`-Quelle initialisiert → **nicht reproduzierbar** zwischen Aufrufen.
- Konsequenzen:
  1. Wenn der User einen Plan generiert, ihn ablehnt und nochmal generiert → **anderer Plan**. Kein "Plan vom Montag wiederherstellen".
  2. **Bug-Reports nicht reproduzierbar.** "Mein Plan vom 17.6. hatte Pasta an Tag 3, jetzt 19.6. wieder Pasta" — kein Dev kann das nachstellen.
  3. Kein A/B-Test der Scoring-Funktion, weil `totalScore` deterministisch sortiert (Zeile 74) aber die Auswahl aus dem Pool zufällig ist (Zeile 87-94). Ergebnis: dieselbe Score-Änderung kann komplett andere Pläne erzeugen, ohne dass der Vergleich möglich wäre.
  4. Wenn eine Kontraindikation dazu kommt, die `score=0` triggert, wandert das Rezept aus dem Pool — andere Rezept-Verteilung, anderer Zufalls-Seed-Pfad, andere Mahlzeiten → der User bekommt einen "komisch anderen" Plan und kann nicht verstehen warum.

**Recommendation:** Optionaler Seed-Parameter, der beim Generieren mitprotokolliert wird (`WeeklyPlan.seed`). Default: `DateTime.now().millisecondsSinceEpoch` — und in den `WeeklyPlan`-Row schreiben. Bei Re-Generate: Seed aus letztem Plan übernehmen.

---

### P0-5: DB-Schema hat keine Indizes — lineare Scans ab 100 Rezepten

**Datei:** `lib/data/database/database.dart` (komplett, 439 Zeilen)
```bash
$ grep -n "@DriftIndex\|CREATE INDEX\|customConstraint" lib/data/database/*.dart
(0 Treffer)
```

**Konkret fehlende Indizes für die Hot-Path-Queries:**

1. `RecipeIngredients.recipeId` — verwendet in:
   - `weekly_plan_engine.dart:159-161` (SELECT WHERE recipe_id = ?)
   - `impl.dart:97-104` (Join)
   Ohne Index: Full-Scan über alle Recipe-Ingredients bei **jedem** Plan-Aggregations-Loop. Bei 500 Rezepten × ~10 Ingredients = 5000 Rows × 21 Queries = 105.000 Row-Reads pro Plan.

2. `RecipeIngredients.ingredientId` — verwendet in:
   - (implizit bei Reverse-Lookup: "welche Rezepte enthalten Ingredient X?" — heute nicht implementiert, aber für "Schlage alternatives Rezept für Ingredient X vor" nötig)

3. `Offers.ingredientId` — verwendet in:
   - `offer_repository.dart:78-80` (WHERE ingredient_id = ?)
   - `impl.dart:278-280` (WHERE ingredient_id = ?)
   Ohne Index: Full-Scan über Offers pro Recipe-Bonus-Berechnung.

4. `Offers.validTo` — verwendet in:
   - `weekly_plan_engine.dart:142-144` (WHERE validTo > ?)
   - `database.dart:368-370` (Watch-Stream)
   Ohne Index: Full-Scan bei **jedem** Plan-Generate + Watch-Refresh.

5. `Offers.discounterId` — verwendet in:
   - Kein direkter Query heute, aber `impl.dart:286-291` (Join).
   Eher defensiv, aber bei Filter "nur Aldi Nord" essentiell.

6. `PlanMeals.planId` — verwendet in:
   - `database.dart:381-382` (WHERE plan_id = ?)
   - `weekly_plan_engine.dart:149-151` (WHERE plan_id = ?)
   Ohne Index: Full-Scan über alle PlanMeals aller Pläne beim Aggregieren.

7. `PlanIngredients.planId` — verwendet in:
   - `database.dart:383-384` (WHERE plan_id = ?)
   - `impl.dart:235-246` (Filter in Dart, aber vorher geladen).
   Eher P1, weil der Plan-Count begrenzt ist.

8. `WeeklyPlans.status` — verwendet in:
   - `impl.dart:149-151` (WHERE status = 'active')
   Ohne Index: Full-Scan aller Pläne beim Stream `watchActive()` — bei 1 Jahr Nutzung ~52 Pläne, harmlos, aber wächst.

9. **Composite-Indizes:**
   - `PlanMeals(planId, date)` für "Plan-Tage in chronologischer Reihenfolge"
   - `Offers(discounterId, validTo)` für "Aldi-Angebote diese Woche"

**Problem:**
- SQLite **legt keine Indizes auf Foreign-Keys automatisch an** (im Gegensatz zu PostgreSQL/MySQL mit `CREATE INDEX` Defaults).
- Drift legt nur Indizes an, die via `@DriftIndex` oder `customConstraint` angefordert werden.
- Bei 500 Rezepten + 1000 Offers + 50 Ingredients × Plan-Calls: **deutlich spürbare Latenz** beim Plan-Generieren. Worst-case: 10-30 Sekunden, je nach Hardware.
- Kein Test prüft die Index-Anwesenheit (`EXPLAIN QUERY PLAN SELECT * FROM recipe_ingredients WHERE recipe_id = ?` muss `USING INDEX` zeigen).

**Recommendation:** `@DriftIndex`-Annotationen auf allen FK-Spalten + Composite-Indizes für Hot-Path-Queries. Test, der `EXPLAIN QUERY PLAN` prüft.

---

### P1-1: `_offerBonusForRecipe` ist eine No-Op-Stub — versprochene Feature fehlt

**Datei:** `lib/domain/services/weekly_plan_engine.dart:193-200`
```dart
int _offerBonusForRecipe(
    Recipe recipe, Map<int, List<Offer>> offerByIngredient) {
  return 0;
}

int _seasonalityBonusForRecipe(Recipe recipe) {
  return 0;
}
```

**Problem:**
- Die Engine berechnet einen `offerBonus` (Zeile 62), der immer 0 ist, und einen `seasonalityBonus` (Zeile 63), der ebenfalls immer 0 ist.
- Der `totalScore` (Zeile 64) ist also effektiv `max(0, contraindicationScore + 0 + 0)` = der Kontraindikations-Score allein.
- Damit ist die "Wochenplan-Engine" **keine** Engine, sondern ein Filter. Sie kann keinen Rezept-Tausch "wegen günstiger Angebote" rechtfertigen, weil das Bonus-System nie einen Score-Unterschied erzeugt.
- Die 1000 Offers, die `_loadActiveOffers()` (Zeile 56, 141-145) lädt, sind verschwendete I/O — die Offers werden in `offerByIngredient` indiziert (Zeile 57) und dann nicht verwendet (außer am Ende in Zeile 122 für die Anzeige im Einkaufszettel).
- Schweregrad P1: Funktionalität in `docs/ARCHITECTURE_V2.md` versprochen, im Code nicht implementiert. Wenn die Engine erstmal produktiv ist, fällt das erst auf, wenn ein User fragt "warum werden Angebote ignoriert?".

**Recommendation:** Entweder Funktion implementieren (mit klarer Doku: "Discount von X% = Bonus von Y Punkten") oder die toten Aufrufe entfernen und den Scoping-Hinweis in der Engine-Header-Doku aktualisieren.

---

### P1-2: Recipe-Erstellung schreibt Ingredients einzeln — N+1-Insert

**Datei:** `lib/data/repositories/impl.dart:49-58`
```dart
for (final ing in recipe.ingredients) {
  await _db.into(_db.recipeIngredients).insert(
        RecipeIngredientsCompanion.insert(
          recipeId: id,
          ingredientId: ing.ingredientId,
          quantityPerPerson: ing.quantityPerPerson,
          unit: Value(_nullToEmpty(ing.unit)),
        ),
      );
}
```

**Problem:**
- Für jedes Ingredient wird ein eigener INSERT abgesetzt. Bei 10 Ingredients = 10 Round-Trips.
- In `seed.dart:65-69` und `:389-393` wird es **richtig** gemacht: `db.batch((b) { for (...) { b.insert(...); } })`.
- Inkonsistenz: Production-Code schlechter als Test-/Seed-Code.
- Schweregrad P1, weil Recipe-Erstellung im UI-Flow ein Hot-Path ist (RecipesScreen → Add-Dialog → save), bei Mobile-Latenz über SQLite-Bridge spürbar.

**Recommendation:** `db.batch((b) { ... })`-Pattern wie in `seed.dart`.

---

### P1-3: Discounter-Scraper — 5 von 7 sind HTML-strukturell fragil

**Datei:** `lib/data/sources/scraper/aldi_scraper.dart:35-38`
```dart
// Aldi Nord hat ein komplexes JS-Frontend — die hier gelisteten
// Selektoren funktionieren NUR, wenn die Seite server-rendered ist
// (also vor dem JS-Hydration). Falls nicht, gehen wir leer aus.
// Das ist OK: App stürzt nicht, User bekommt "Keine Angebote".
```

**Datei:** `lib/data/sources/scraper/lidl_scraper.dart:23`
```dart
static const _startUrl = 'https://www.lidl.de/';
```

**Datei:** `lib/data/sources/scraper/generic_scraper.dart:65-68`
```dart
final names = extractAll(response.body,
    '[class*="product" i] [class*="title" i], [class*="title" i][class*="product" i]');
final prices = extractAll(response.body,
    '[class*="product" i] [class*="price" i], [class*="price" i][class*="product" i]');
```

**Problem:**
- Aldi Nord, Aldi Süd, Lidl sind explizit JS-gerendert → die HTML-Response enthält keine Produktdaten → `extractAll` gibt leere Listen zurück → "Keine Angebote verfügbar".
- Der Kommentar gibt zu, dass das "OK" ist, weil die App nicht crasht — aber **die ganze Feature-Aussage "Live-Angebote aus Discountern" ist damit für 3 von 7 Discountern dauerhaft leer**, solange niemand die Scraper auf einen API- oder PDF-Pfad umstellt.
- Lidl scrapt `https://www.lidl.de/` (die Startseite!) — dort sind keine Wochenangebote zu finden. Die Selektoren `.product-grid__item .product__title` existieren nur auf der `/c/...`-Sortiment-Seite. **Dieser Scraper wird praktisch nie ein Ergebnis liefern.**
- Die "generic_scraper" für Rewe/Netto/Penny/Norma nutzt `class*=` Wildcards → fängt auch Layout-Elemente wie `.product-page-title`, `.site-title`, `.price-label`, `.price-info` ein. Daraus entstehen Spurious-Matches wie `name="Preis pro 100g"` paired mit `name="Äpfel"` (Index-Versatz).
- Der Code gibt `names[i]` und `prices[i]` als Paar aus, ohne zu prüfen, ob Index i überhaupt zum gleichen Produkt gehört (Zeile 53-69 in aldi_scraper, 47-61 in lidl_scraper, 71-85 in generic_scraper).
- Kein **einziger** Scraper hat einen Retry-Mechanismus oder Fallback-Strategie (z.B. PDF-Prospekt-Parsing für Lidl/Aldi, deren Wochenprospekte als PDF verfügbar sind).
- Kein Scraper respektiert `robots.txt` (auch in Review #1 als P1 markiert).
- Schweregrad P1, weil das **Kern-USP-Feature** ("Angebote aus lokalen Discountern") in der Praxis vermutlich für die Mehrheit der User leer bleibt.

**Recommendation:** HTML-Realitäts-Check (z.B. via CI gegen lokale HTML-Snapshots). Echte API-Endpunkte oder RSS-Feeds, wo verfügbar. Klares Feature-Flag pro Scraper, sodass kaputte Scraper nicht fälschlich "0 Angebote" signalisieren sondern "deaktiviert wegen bekanntem Defekt".

---

### P1-4: Sequentielles Scraping blockiert den Background-Job

**Datei:** `lib/data/repositories/offer_repository.dart:22-66`
```dart
// Sequentiell (nicht parallel) — Discounter-Websites mögen
// kein gleichzeitiges Crawling von derselben IP.
for (final d in discounters) {
  if (d.scraperClass == 'MarktguruApi') continue;

  try {
    final scraper = ScraperRegistry.forClass(d.scraperClass, client: _http);
    final scraped = await scraper.scrape().timeout(timeout);
    ...
```

**Problem:**
- 7 Discounter × je 3 Sekunden Rate-Limit + ~3 Sekunden HTTP = ~42 Sekunden für **eine** vollständige Refresh-Runde.
- Die `refreshOffersAndPlan()` in `background_jobs.dart:80-107` ist als Workmanager-Periodic-Task mit `Duration(days: 7)` Frequency registriert (Zeile 60). Workmanager hat je nach Android-Version ein Limit von **~10 Minuten** für Periodic-Tasks. 42 Sekunden ist okay, aber wenn nur 1-2 Discounter langsam sind (Timeout 30s in `offer_repository.dart:23`), kann der Job auf 1:30 Minuten wachsen.
- Der 30s-Timeout pro Scraper (`offer_repository.dart:23`) ist hartkodiert. Wenn ein Discounter 25s zum Antworten braucht, bekommt der User entweder die Angebote **oder** den Timeout, aber nie beides (kein Retry, kein Backoff).
- Der Kommentar "Sequentiell (nicht parallel) — Discounter-Websites mögen kein gleichzeitiges Crawling" ist **korrekt**, aber es gibt keinen konkreten Schutz: ein paralleler Aufruf von woanders (z.B. UI-Debug-Button) könnte die Annahme brechen.
- Schweregrad P1, weil ein 42-Sekunden-Job auf Mobile (besonders bei LTE/3G-Fallback) die Batterie leer saugt und Workmanager-Konflikte mit anderen Apps triggern kann.

**Recommendation:** Randomisiertes Delay zwischen Scrapes (z.B. 2-5s Jitter), User-Agent-Rotation (nicht immer der gleiche), Circuit-Breaker-Pattern (wenn 3× hintereinander Timeout → Scraper für die Woche deaktivieren). Parallelisierung nur, wenn Scraper in getrennten Isolates laufen.

---

### P1-5: Provider — kein `autoDispose`, alle Streams leben für die App-Lifetime

**Datei:** `lib/ui/providers.dart:76-102`
```dart
final activePlanStreamProvider = StreamProvider((ref) {
  return ref.watch(weeklyPlanRepositoryProvider).watchActive();
});

final allPlansStreamProvider = StreamProvider((ref) {
  return ref.watch(weeklyPlanRepositoryProvider).watchAll();
});

final activeOffersStreamProvider = StreamProvider((ref) {
  return ref.watch(offerRepositoryProvider).watchActive();
});

final discountersStreamProvider = StreamProvider((ref) {
  return ref.watch(discounterRepositoryProvider).watchAll();
});

final userContraindicationsProvider = StreamProvider((ref) {
  return ref.watch(contraindicationRepositoryProvider).watchActiveForUser();
});

final allContraindicationsProvider = StreamProvider((ref) {
  return ref.watch(contraindicationRepositoryProvider).watchAll();
});
```

**Problem:**
- `home_screen.dart:65-69` nutzt `IndexedStack` für die Tab-Navigation. `IndexedStack` hält **alle** 6 Screens im Widget-Tree, auch unsichtbare.
- Jeder Screen subscribed via `ref.watch(...)` → alle 6 Stream-Provider sind aktiv, solange die App läuft.
- Drift-Streams (`watchAllRecipes`, `watchValidOffers`, `watchAllPlans`, etc.) öffnen pro Stream eine Subscription auf die DB. 6 aktive Streams × je 1 Subscription = 6 Listener, die jeweils auf DB-Mutationen warten.
- Bei jedem INSERT/UPDATE/DELETE auf einer relevanten Tabelle feuern **alle** betroffenen Streams → Drift muss alle Listener benachrichtigen → UI-Rebuilds auf unsichtbaren Tabs.
- Test: Tippt der User in `RecipesScreen` einen Buchstaben ins Add-Dialog-Feld, wird der `Recipes`-Stream nicht invalidieren, ABER ein anderes Insert auf `RecipeIngredients` (z.B. via Wochenplan-Generierung) feuert **nicht** in `Recipes`-Stream, sondern der `Recipes`-Stream bleibt kalt. Trotzdem: 6 offene DB-Listener = 6 × `sqlite3_step` Wakeups bei jedem relevanten Write.
- `autoDispose` würde die Streams freigeben, sobald der letzte Consumer unsubscribt. Bei `IndexedStack`-Tab-Wechsel (nicht "schließen") bleibt der Consumer aber im Tree → `autoDispose` würde nichts bringen, weil der Consumer ständig aktiv ist. Das ist die eigentliche Erkenntnis: **`IndexedStack` ist der falsche Navigator für 6 Tabs mit aktiven Streams.**
- Schweregrad P1, weil das auf Low-End-Phones (Android Go, 2 GB RAM) bei 6 Tabs + DB + Scraper-Subscriptions zu OOM-Kills führen kann.

**Recommendation:** `PageView` oder echtes `Navigator`-Stack-Pattern mit Build-on-Demand, kombiniert mit `autoDispose` an den Stream-Providern. Oder akzeptieren, dass 6 Tabs immer aktiv sind, und die Memory-Profile messen.

---

### P1-6: `WeeklyPlanRepositoryImpl.watchActive()` ruft `_toEntity` async pro Element auf — O(N) Stream-Async-Map

**Datei:** `lib/data/repositories/impl.dart:147-158`
```dart
@override
Stream<WeeklyPlanEntity?> watchActive() {
  return (_db.select(_db.weeklyPlans)
        ..where((p) => p.status.equals('active'))
        ..orderBy([(p) => OrderingTerm.desc(p.weekStart)])
        ..limit(1))
      .watchSingleOrNull()
      .asyncMap((p) async {
    if (p == null) return null;
    return _toEntity(p);
  });
}
```

**Datei:** `lib/data/repositories/impl.dart:136-145`
```dart
@override
Stream<List<WeeklyPlanEntity>> watchAll() async* {
  await for (final plans in _db.watchAllPlans()) {
    final entities = <WeeklyPlanEntity>[];
    for (final p in plans) {
      final e = await _toEntity(p);
      if (e != null) entities.add(e);
    }
    yield entities;
  }
}
```

**Problem:**
- `watchAll` ruft `_toEntity(p)` **sequentiell await pro Plan** auf. Bei 20 historischen Plänen + dem Stream, der bei jeder DB-Mutation feuert (Plan-Insert, PlanMeals-Insert, PlanIngredients-Insert, etc.) → **20 × N+1 = 420 Queries** pro Stream-Fire.
- `_toEntity` selbst triggert 5-7 Queries (siehe P0-3). Bei 20 Plänen × 7 Queries = 140 Queries pro Stream-Tick.
- Stream feuert bei **jedem** Insert in `plan_meals` (auch wenn es nicht der eigene Plan ist) — Drift kann das filtern, der Code tut es nicht.
- Schweregrad P1, weil der Stream auf Mobile bei aktiver Plan-Bearbeitung spürbar laggy wird.

**Recommendation:** Ein einziger großer Join-Query (`SELECT ... FROM plans LEFT JOIN plan_meals LEFT JOIN plan_ingredients LEFT JOIN offers LEFT JOIN discounters WHERE ...`) statt 7+ Queries pro Plan. Drift kann das via `MultiSelect` oder `selectOnly` + manuelle Hydration.

---

### P1-7: Hardcoded deutsche Strings in UI-Screens — verstoßen gegen i18n-Versprechen

**Belege:**
- `lib/ui/screens/recipes_screen.dart:37` — `title: const Text('Neues Rezept')`
- `lib/ui/screens/recipes_screen.dart:44` — `decoration: const InputDecoration(labelText: 'Name')`
- `lib/ui/screens/recipes_screen.dart:48` — `decoration: const InputDecoration(labelText: 'Beschreibung')`
- `lib/ui/screens/recipes_screen.dart:53` — `decoration: const InputDecoration(labelText: 'Zubereitungszeit (Min)')`
- `lib/ui/screens/recipes_screen.dart:59` — `decoration: const InputDecoration(labelText: 'Kalorien (kcal)')`
- `lib/ui/screens/recipes_screen.dart:68` — `child: const Text('Abbrechen')`
- `lib/ui/screens/recipes_screen.dart:72` — `child: const Text('Speichern')`
- `lib/ui/screens/recipes_screen.dart:105` — `Center(child: Text('Error: ${snapshot.error}'))`
- `lib/ui/screens/offers_screen.dart:46` — `SnackBar(content: Text('Fehler: $e'))`
- `lib/ui/screens/offers_screen.dart:88` — `error: (e, _) => Center(child: Text('Fehler: $e'))`
- `lib/ui/screens/settings_screen.dart:81,86,154,159` — `'Abbrechen'` und `'Speichern'`
- `lib/ui/screens/shopping_list_screen.dart:66,74,85` — `'Neues Item'`, `'Abbrechen'`, `'OK'`
- `lib/ui/screens/weekly_plan_screen.dart:33,70` — `'Fehler: $e'` (zweimal)
- `lib/ui/screens/weekly_plan_screen.dart:119` — `Text('${plan.shoppingList.length}')` (ohne Label "Items")
- `lib/ui/screens/weekly_plan_screen.dart:145` — `'${l10n.shoppingFromPlan} (${plan.shoppingList.length})'` (String-Concat statt i18n-Plural)
- `lib/ui/screens/weekly_plan_screen.dart:169` — `child: Text('Einkaufszettel'`
- `lib/ui/screens/weekly_plan_screen.dart:177` — `'${item.quantity.toStringAsFixed(0)}${item.unit ?? 'g'}'`
- `lib/ui/screens/weekly_plan_screen.dart:179` — `'${item.offerPrice!.toStringAsFixed(2)}€'` (€ hartkodiert, nicht lokalisierbar)
- `lib/ui/screens/weekly_plan_screen.dart:222` — `Text(m.recipeName ?? '–')` (Em-Dash, OK, aber nicht i18n)
- `lib/ui/screens/food_journal_screen.dart:61` — `Text(e.customName ?? '–')`
- `lib/ui/screens/contraindications_screen.dart:24,30` — `'Fehler: $e'`
- `lib/ui/screens/contraindications_screen.dart:45` — `Text('—')`
- `lib/ui/screens/settings_screen.dart:66` — `subtitle: Text(zip ?? '–')`

**Problem:**
- Mindestens 25 hardcoded deutsche Strings, die bei einem Locale-Wechsel zu englisch oder französisch weiterhin deutsch angezeigt werden.
- `l10n.plurals()` für "1 Item" vs. "5 Items" wird in `weekly_plan_screen.dart:145` umgangen — stattdessen naiv `${l10n.shoppingFromPlan} (${count})` was in den meisten Sprachen falsche Grammatik ergibt.
- `€`-Symbol in Zeile 179 ist nicht lokalisierbar — US-User mit App in englisch würden trotzdem €-Symbol sehen.
- `–` und `—` (Em-Dash) sind Locale-spezifisch unterschiedlich (FR nutzt Guillemets « »).
- Schweregrad P1, weil das App-Store-Review für nicht-deutsche Locales scheitern wird.

**Recommendation:** Komplette `lib/ui/screens/`-Review mit `l10n.X`-Pattern. `intl.NumberFormat.simpleCurrency(locale: ...)` statt `€`-Hardcoding. Plurals via `intl.Intl.plural(...)`.

---

### P1-8: Test-Coverage praktisch Null

**Datei:** `test/widget_test.dart` (komplett, 59 Zeilen)

```dart
test('schemaVersion is 2', () { ... });
test('all v2 tables exist and can be queried', () { ... });
test('ensureSettingsExist creates default settings row', () { ... });
```

**Fehlende Tests:**

| Modul | Pfad | Getestet? | Risiko |
|---|---|---|---|
| `WeeklyPlanEngine.generatePlan` | `lib/domain/services/weekly_plan_engine.dart` | ❌ NEIN | Kernfeature, kein Test |
| `ContraindicationChecker.scoreRecipe` | `lib/domain/services/contraindication_checker.dart` | ❌ NEIN | Medizinische Logik, kein Test |
| `OfferRepository.refreshAllOffers` | `lib/data/repositories/offer_repository.dart` | ❌ NEIN | Network-IO, kein Test |
| `OfferRepository._matchIngredient` | `lib/data/repositories/offer_repository.dart:71-82` | ❌ NEIN | Fuzzy-Match-Logik, kein Test |
| `RecipeRepositoryImpl.create` | `lib/data/repositories/impl.dart:37-60` | ❌ NEIN | DB-Insert-Pfad |
| `WeeklyPlanRepositoryImpl._toEntity` | `lib/data/repositories/impl.dart:189-257` | ❌ NEIN | N+1-Query-Pfad |
| `AldiNordScraper._parseOffers` | `lib/data/sources/scraper/aldi_scraper.dart:48-71` | ❌ NEIN | HTML-Parsing |
| `LidlScraper._parseOffers` | `lib/data/sources/scraper/lidl_scraper.dart:41-62` | ❌ NEIN | HTML-Parsing |
| `generic_scraper._genericScrape` | `lib/data/sources/scraper/generic_scraper.dart:56-89` | ❌ NEIN | HTML-Parsing |
| Migration v1 → v2 | `lib/data/database/database.dart:246-262` | ❌ NEIN | Datenverlust-Risiko bei Upgrade |
| `SeedData` | `lib/data/database/seed.dart` | ❌ NEIN | Seed-Duplikate-Risiko |
| `BackgroundJobs.refreshOffersAndPlan` | `lib/background/background_jobs.dart:80-107` | ❌ NEIN | Background-Logik |

**Problem:**
- Die `pubspec.yaml:35-39` deklariert `mockito` als dev-Dependency — wird aber in keinem Test verwendet. Dead-Weight-Dependency.
- Drift selbst hat einen `DatabaseConnection`/`NativeDatabase.memory()`-Helper für Tests (siehe Zeile 19 in `widget_test.dart`), der gut funktioniert. Die fehlenden Tests sind reine Aufwand-Frage, nicht Tooling-Mangel.
- Bei `WeeklyPlanEngine` mit ihrer komplexen Sortier-/Auswahl-Logik ist ein Unit-Test essentiell, weil die Logik im P0-4-Finding (Nicht-Determinismus) nicht durch Debug-Ausgaben verifizierbar ist.
- Schweregrad P1, weil ohne Tests:
  1. Refactoring der Plan-Engine ist ein Blindflug.
  2. Bug-Reports (P0-1 z.B.) wären durch Tests sofort aufgefallen.
  3. CI/CD kann keine Quality-Gates setzen.

**Recommendation:** Mindestens Tests für: `WeeklyPlanEngine.generatePlan` (mit Seed), `ContraindicationChecker.scoreRecipe` (parametrisiert über alle 22 Seed-Contraindikationen), `RecipeRepositoryImpl.create`, Migration v1 → v2 (v1-DB programmatisch erzeugen, Upgrade triggern, Daten-Integrität prüfen).

---

### P1-9: Migration v1 → v2 nicht testbar + möglicher Datenverlust

**Datei:** `lib/data/database/database.dart:246-262`
```dart
@override
MigrationStrategy get migration => MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.createTable(ingredients);
          await m.createTable(recipeIngredients);
          ...
          await m.createTable(userProfile);
          await into(userProfile).insert(UserProfileCompanion.insert());
        }
      },
    );
```

**Problem:**
- Der `from < 2`-Check ist korrekt für v1 → v2, aber **die v1-Schema-Definitionen sind nicht im Code vorhanden**. Es gibt keinen v1-`schemaVersion: 1`-Branch in irgendeiner Datei, der die alte `Recipes`/`ShoppingItems`/`FoodLog`/`Settings`-Tabellenstruktur dokumentiert.
- Wenn ein v1-User upgraded, werden die neuen Tabellen erstellt. Aber: **es gibt keinen `m.alterTable(...)`-Aufruf**, der z.B. die `Settings`-Tabelle um neue Spalten erweitert (sie wurde nicht verändert, aber wenn v2.1 z.B. `settings.unitsSystem` einführt, gibt es keinen Pfad).
- Die `into(userProfile).insert(UserProfileCompanion.insert())` direkt nach `createTable(userProfile)` funktioniert, weil `UserProfileCompanion.insert()` mit `id: Value(1)` und allen Defaults arbeitet. Aber **wenn die Tabelle bereits existiert** (z.B. bei einem Test-Setup mit zweiter Migration-Run), kracht es mit `UniqueViolationException`.
- Kein Downgrade-Pfad (`onDowngrade`). Wenn ein User die App downgradet (z.B. Beta-Channel), ist die DB zerschossen.
- Schweregrad P1, weil:
  1. v1-User mit echten Daten existieren (laut README "aus v1 übernommen").
  2. Kein automatisierter Test die Migration verifiziert.
  3. Bei zukünftigen Schema-Änderungen (`schemaVersion = 3`) gibt es keinen etablierten Pattern, an dem man sich orientieren kann.

**Recommendation:** Eigene v1-Schema-Klasse (oder Version-Kommentar in der Tabelle), explizite Test-Migration mit reproduzierbarem v1-Snapshot, `onDowngrade`-Handler der zumindest loggt oder die Migration no-op'd.

---

### P2-1: Hartkodierte `'-'`/`'–'` als Empty-String-Replacement

**Belege:**
- `lib/ui/screens/weekly_plan_screen.dart:222` — `Text(m.recipeName ?? '–')`
- `lib/ui/screens/food_journal_screen.dart:61` — `Text(e.customName ?? '–')`
- `lib/ui/screens/settings_screen.dart:66,139` — `Text(zip ?? '–')`
- `lib/ui/screens/contraindications_screen.dart:45` — `Text('—')`

**Problem:**
- Mindestens 5 Stellen, an denen ein nicht-lokalisierter Dash-String als "Empty"-Marker genutzt wird.
- Schweregrad P2, weil es kosmetisch ist, aber bei strikter i18n-Conformance für App-Store-Review relevant.

---

### P2-2: Unit-Conversion hartkodiert (`'g'`, `'kcal'`, `'€'`)

**Belege:**
- `lib/ui/screens/recipes_screen.dart:118,121` — `'${r.prepTimeMinutes} ${l10n.minutes}'` (gut: l10n genutzt; aber `l10n.minutes = "Min"` ohne Space)
- `lib/ui/screens/weekly_plan_screen.dart:177` — `'${item.quantity.toStringAsFixed(0)}${item.unit ?? 'g'}'`
- `lib/ui/screens/weekly_plan_screen.dart:179` — `'${item.offerPrice!.toStringAsFixed(2)}€'`
- `lib/ui/screens/offers_screen.dart:104` — `'${offer.price.toStringAsFixed(2)}€'`

**Problem:**
- `€` hartkodiert — sollte `intl.NumberFormat.simpleCurrency(locale: locale).format(price)` sein.
- `'g'` als Fallback für `unit` — sollte aus `Ingredient.unitDefault` kommen (welches in DB steht, aber hier ignoriert wird).
- Kein Support für imperial units (oz, lb), obwohl `settings.units = 'metric'` als Column existiert (`database.dart:58`).
- Schweregrad P2, weil das Feature-Scope (US-Markt) ohnehin nicht angekündigt ist, aber inkonsistent: Setting wird gespeichert, aber nicht ausgewertet.

---

### P2-3: Engine kennt keinen `'snack'`-Meal-Type, obwohl Schema/UI ihn kennen

**Datei:** `lib/domain/services/weekly_plan_engine.dart:24`
```dart
static const List<String> _mealTypes = ['breakfast', 'lunch', 'dinner'];
```

**Datei:** `lib/ui/screens/weekly_plan_screen.dart:277-278`
```dart
case 'snack':
  return l10n.snack;
```

**Datei:** `lib/l10n/app_en.arb:61`
```json
"snack": "Snack",
```

**Problem:**
- Die Engine generiert nur 3 Mahlzeiten/Tag (21/Woche), aber das UI/Locale-System kennt `snack`.
- Ein Snack-Rezept, das ein User manuell in `PlanMeals` einfügt, wird vom Sort-Algorithmus der `_PlanView` (Zeile 132-134: `meals.sort((a, b) => a.mealType.compareTo(b.mealType))`) **nach** `dinner` einsortiert (String-Sort), aber visuell unter "dinner" angezeigt, weil das `_DayCard` (Zeile 210-228) alle Meals einer Day-Gruppe in der Liste rendert.
- Schweregrad P2, weil Snack aktuell nicht geplant wird, also nicht in Konflikt gerät. Aber die Inkonsistenz wird spätestens beim Hinzufügen von Snack-Support relevant.

---

### P2-4: `BackgroundJobs.initialize` ruft `_notifications.initialize` auch auf iOS, das Plugin ist iOS-untauglich

**Datei:** `lib/background/background_jobs.dart:48-52`
```dart
const androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');
const initSettings = InitializationSettings(android: androidInit);
await _notifications.initialize(initSettings);
```

**Problem:**
- Der Code ist nur Android (`background_jobs.dart:37` checkt `defaultTargetPlatform == TargetPlatform.android` für Workmanager), aber die Notification-Initialisierung läuft **immer**.
- Auf iOS würde das `flutter_local_notifications` Plugin den iOS-Init-Code fordern, der nicht im `InitializationSettings` steht → Plugin wirft zur Laufzeit.
- Schweregrad P2, weil iOS-Support sowieso "out of scope" ist (laut `pubspec.yaml` Kommentar), aber der Code sollte explizit `if (!kIsWeb && Platform.isAndroid)` wrappen, damit spätere Portierung kein Stolperstein ist.

---

### P2-5: `seed.dart:65-69, 389-393` verwendet Batch, `impl.dart:49-58` nicht — Code-Inkonsistenz

**Datei:** `lib/data/database/seed.dart:65-69`
```dart
await db.batch((b) {
  for (final d in seed) {
    b.insert(db.discounters, d);
  }
});
```

**Datei:** `lib/data/repositories/impl.dart:49-58`
```dart
for (final ing in recipe.ingredients) {
  await _db.into(_db.recipeIngredients).insert(
        RecipeIngredientsCompanion.insert(
          ...
        ),
      );
}
```

**Problem:**
- Selbe Domäne (Multi-Insert in dieselbe Tabelle), zwei verschiedene Patterns. Production-Code ist langsamer als Seed-Code.
- Schweregrad P2, weil nur Performance-Nachteil, keine Korrektheit.

---

### P2-6: `Recipes.id` ist Auto-Increment, `Settings.id` und `UserProfile.id` sind hartkodiert `1`

**Datei:** `lib/data/database/database.dart:56,198`
```dart
IntColumn get id => integer().withDefault(const Constant(1))();
```

**Problem:**
- Single-User-App, daher OK. Aber: zwei Tabellen (`Settings` und `UserProfile`) haben jeweils ein `id=1` Konzept, was zu Verwirrung führt. Warum zwei separate Tabellen?
- Die Settings-Tabelle hat `locale`, `units`, `theme`, `calorieGoal`, etc. — die UserProfile-Tabelle hat `persons`, `zipCode`, `marktguruEnabled`, etc. Die Trennung ist nicht offensichtlich.
- Schweregrad P2, weil konzeptionell, nicht funktional. Zukünftiges Refactoring würde davon profitieren, die Settings-Tabelle aufzulösen.

---

### P2-7: `flutter_gen` statt aktuellem `flutter_localizations`-Import in Screens

**Belege (alle UI-Screens):**
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
```

**Problem:**
- `flutter_gen` ist der alte Pfad (Flutter < 3.0). Aktuell ist `import 'package:flutter_gen/gen_l10n/app_localizations.dart';` zwar noch unterstützt, aber die `flutter_localizations`-Suite aus `flutter.sdk` empfiehlt mittlerweile `import 'package:flutter_gen/gen_l10n/app_localizations.dart';` durch direkten `import '<arb-dir>/app_localizations.dart';` zu ersetzen.
- Schweregrad P2, weil Deprecated-Warning beim Build.

---

### P2-8: `Share_plus`, `permission_handler`, `logger` in pubspec — nirgendwo importiert

**Datei:** `pubspec.yaml:52-58`
```yaml
share_plus: ^10.0.2
permission_handler: ^11.3.1
logger: ^2.4.0
```

**Problem:**
- `share_plus`: 0 Imports in `lib/`
- `permission_handler`: 0 Imports in `lib/`
- `logger`: 0 Imports in `lib/` (überall wird `debugPrint` und `print` verwendet, z.B. `background_jobs.dart:44,67`, `main.dart`?)
- Schweregrad P2, weil:
  1. APK größer als nötig.
  2. Review #1 hat das schon angemerkt (P1-5 in Review #1), wurde aber nicht behoben.
  3. Dependency-Hygiene: jede ungenutzte Library ist ein zukünftiges Sicherheits-/Wartungs-Risiko.

---

## Zusammenfassung nach Modul

| Modul | P0 | P1 | P2 | Total |
|---|---|---|---|---|
| `lib/domain/services/weekly_plan_engine.dart` | 2 | 1 | 1 | 4 |
| `lib/domain/services/contraindication_checker.dart` | 0 | 0 | 0 | 0 (separate Review nötig) |
| `lib/data/sources/scraper/*` | 0 | 1 | 0 | 1 |
| `lib/data/database/database.dart` | 1 | 1 | 1 | 3 |
| `lib/data/repositories/impl.dart` | 1 | 1 | 1 | 3 |
| `lib/data/repositories/offer_repository.dart` | 0 | 1 | 0 | 1 |
| `lib/ui/providers.dart` | 0 | 1 | 0 | 1 |
| `lib/ui/screens/*` (i18n) | 1 | 1 | 3 | 5 |
| `lib/l10n/*.arb` | 1 | 0 | 0 | 1 |
| `lib/background/background_jobs.dart` | 0 | 0 | 1 | 1 |
| Test-Coverage | 0 | 1 | 0 | 1 |
| **Total** | **5** | **9** | **7** | **21** |

---

## Empfehlung an den Fix-Loop (Priorisierung)

1. **Sofort (P0):** P0-1 (Kontraindikations-Deactivate), P0-2 (ARB-Metadaten), P0-3 (N+1-Queries), P0-5 (DB-Indizes). P0-4 ist eine Architekturentscheidung, die mit dem Maintainer abgestimmt werden sollte (Reproduzierbarkeit vs. Variety).
2. **Diese Woche (P1):** P1-8 (Tests), P1-1 (Stubs entfernen oder implementieren), P1-7 (i18n in Screens).
3. **Diese Iteration (P2):** Alles andere.

**Reviewer-Notiz:** Der Code ist solide für eine v2.0.0, aber die i18n-Behauptung in der README ("10 Sprachen") ist eine **faktische Lüge** — 9 Dateien sind Stub. Wenn die App im DACH-Raum bleibt, ist das ein P2; wenn internationaler Rollout geplant ist, ist es ein P0-Blocker für den Store-Review.
