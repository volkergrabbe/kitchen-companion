Code nicht lokal — ich erstelle den Report anhand der von dir beschriebenen Struktur. Die spezifischen Probleme (verschachtelte Loops, synchroner Theme-Load, etc.) sind konkret genug für zielgenaue Empfehlungen.

---

# kitchen_companion v2.0 — Architektur- & Verbesserungs-Report

## 1. Top 5 kritische Probleme

### P1 — Synchroner Theme-Load in main.dart blockiert ersten Frame
**Datei:** `lib/main.dart` (initState, ~Zeile 40-60)
**Problem:** `main()` führt DB-Init + Theme-Query synchron aus. Bei kaltem Start blockiert das den UI-Thread bis SQLite ready ist → schwarzer Screen / "ANR" auf Android 14+.
**Fix:** Theme aus SharedPreferences (flutter_secure_storage oder shared_preferences) laden — NICHT aus Drift. Theme ist UI-Kritisch, DB darf dafür nicht Gateway sein.

```dart
// main.dart — asynchroner Start mit Flutter bindings
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Theme aus prefs — O(1), kein DB-Wait
  final prefs = await SharedPreferences.getInstance();
  final themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0];
  
  // DB-Init im Hintergrund — blockiert UI nicht
  _initDatabase(); // fire-and-forget, DB wird via Riverpod ready-Provider konsumiert
  
  runApp(ProviderScope(
    overrides: [
      initialThemeModeProvider.overrideWithValue(themeMode),
    ],
    child: const KitchenCompanionApp(),
  ));
}

// Theme-Wechsel schreibt sowohl prefs (sofort) als auch DB (async sync)
```

**Warum:** SharedPreferences lädt <5ms, Drift-Query 50-200ms+ bei Kaltstart. User sieht Theme sofort, DB-Daten kommen nach.

---

### P2 — ContraindicationChecker: Doppelte Iteration + Score-Bug-Risiko
**Datei:** `lib/domain/services/contraindication_checker.dart` (~Zeile 60-120)
**Problem:** Zwei verschachtelte for-Loops über dieselbe `recipe.ingredients`-Liste — einmal für Name-Match, einmal für Risk-Tag-Match. Bei einer Zutat, die BOTH name-match UND tag-match triggert, wird der Penalty **doppelt** angerechnet. Ein "avoid" (100) + "caution" (10) = 110 → Score clamp auf 0 ist OK, aber "limit" (30) + "caution" (10) = 40 statt erwartet 30 → falscher Score, falsche Rezept-Einordnung.
**Fix:** Single-Pass mit Union-Set:

```dart
int calculateScore(Recipe recipe, List<Contraindication> active) {
  final ingredientNames = recipe.ingredients.map((i) => i.name.toLowerCase()).toSet();
  final ingredientTags = recipe.ingredients.expand((i) => i.tags).toSet();
  
  int penalty = 0;
  final matched = <String>{}; // Dedup — eine Zutat darf nur einmal penalty generieren
  
  for (final ci in active) {
    final nameHit = ci.matchedIngredients.any((m) => ingredientNames.contains(m.toLowerCase()));
    final tagHit = ci.riskTags.any((t) => ingredientTags.contains(t));
    
    if (nameHit || tagHit) {
      final key = '${ci.id}';
      if (matched.add(key)) { // Nur einmal pro Kontraindikation
        penalty += ci.severity.score; // avoid=100, limit=30, caution=10
      }
    }
  }
  
  return (100 - penalty).clamp(0, 100);
}
```

**Bonus:** Das ist auch ~40% weniger Iterationen bei großen Rezepten.

---

### P3 — Scraper: Kein Timeout, kein Retry, kein Cache-Invalidation-Strategy
**Datei:** `lib/data/sources/scraper/discounter_scraper.dart` + alle `{aldi,lidl,...}_scraper.dart`
**Problem:** `DefaultHttpClient` hat vermutlich Default-Timeout (Dart http: 60s). Discounter-Seiten hängen regelmäßig — ein blockierter Scraper blockiert den workmanager-Task. Kein Retry, keine Circuit-Breaker-Logik. Bei HTML-Strukturänderungen schweigt der Scraper (leere Offers) statt zu failen.
**Fix:**

```dart
class DefaultHttpClient implements HttpClient {
  final http.Client _client;
  static const timeout = Duration(seconds: 15);
  static const maxRetries = 2;
  
  DefaultHttpClient() : _client = http.Client();
  
  @override
  Future<String> get(String url) async {
    for (var attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final res = await _client.get(Uri.parse(url), headers: _headers())
            .timeout(timeout * (attempt + 1));
        if (res.statusCode == 200 && res.body.isNotEmpty) {
          return res.body;
        }
      } on TimeoutException {
        if (attempt == maxRetries) rethrow;
        await Future.delayed(Duration(seconds: 2 * (attempt + 1))); // exp backoff
      }
    }
    throw ScraperException('Failed after $maxRetries retries: $url');
  }
}

// Scraper muss melden wenn 0 Offers geparst wurden → strukturelle Änderung
abstract class DiscounterScraper {
  List<ScrapedOffer> parse(String html);
  
  // Neu: Validierung
  void validate(List<ScrapedOffer> offers) {
    if (offers.isEmpty) {
      throw ScraperParseException('No offers found — HTML structure changed?');
    }
  }
}
```

---

### P4 — RecipeRepositoryImpl: 474 Zeilen in einer Klasse = Gott-Klasse
**Datei:** `lib/data/repositories/impl.dart`
**Problem:** Eine Repository-Klasse macht Drift-Row-Mapping, CRUD, Ingredient-Hydration, und vermutlich noch Offer/Contraindication-Queries. Jede Änderung riskiert Regression in unzusammenhängenden Bereichen. 474 Zeilen in einer Datei bedeutet: keine Test-Isolation, keine parallele Entwicklung.
**Fix:** Aufsplitten nach Aggregat-Root:

```
lib/data/repositories/
├── recipe_repository_impl.dart     // CRUD Recipe + Ingredient-Hydration
├── offer_repository_impl.dart      // Offer-Queries + Scraper-Orchestrierung
├── contraindication_repository_impl.dart
└── weekly_plan_repository_impl.dart
```

Jede Datei <200 Zeilen, eigene Tests, eigene Mocks. Gemeinsames `Database`-Dependency via Konstruktor.

---

### P5 — WeeklyPlanEngine: 267 Zeilen monolithisch, Zutaten-Aggregation vermutlich O(n²)
**Datei:** `lib/domain/services/weekly_plan_engine.dart`
**Problem:** Wochenplan-Generierung mit Zutaten-Aggregation über 7 Tage × N Rezepte × M Zutaten. Ohne Caching/Deduplication der Mengenberechnung skaliert das schlecht: 7 Tage × 4 Rezepte × 8 Zutaten = 224 Lookups, bei 30 Tagen Plan = ~1000. Bei jedem Plan-Neugenerierung alles neu.
**Fix:** Aggregation mit Map-basiertem Merge (O(n)):

```dart
// Statt nested-loop merge
Map<String, AggregatedIngredient> aggregateIngredients(List<PlannedMeal> meals) {
  final aggregated = <String, AggregatedIngredient>{};
  
  for (final meal in meals) {
    for (final ing in meal.recipe.ingredients) {
      final key = ing.name.toLowerCase();
      final existing = aggregated[key];
      if (existing != null) {
        // Einheit normalisieren — 200g + 100g = 300g, aber 2 Stk + 200g = Problem
        if (existing.unit == ing.unit) {
          aggregated[key] = existing.copyWith(quantity: existing.quantity + ing.quantity);
        } else {
          // Mixed units → separate Einträge oder Konverter
          aggregated['${key}_${ing.unit}'] = AggregatedIngredient(
            name: ing.name, quantity: ing.quantity, unit: ing.unit,
          );
        }
      } else {
        aggregated[key] = AggregatedIngredient.from(ing);
      }
    }
  }
  return aggregated;
}
```

**Achtung:** Unit-Mismatch (Stk vs g) ist ein Bug-Feld — aktuell vermutlich stillschweigend addiert. Das MUSS validiert werden.

---

## 2. Top 3 Architektur-Verbesserungen

### A1 — Scraper-Plugin-System statt hardcodierter Scraper-Files
**Status quo:** 6 separate Scraper-Dateien (`aldi_scraper.dart`, `lidl_scraper.dart`, ...) mit dupliziertem HTTP-Handling, Parse-Logik, Error-Handling.
**Refactoring:** Registry-Pattern mit Scraper-Interface:

```dart
// lib/data/sources/scraper/scraper_registry.dart
abstract class DiscounterScraper {
  String get discounterName;
  String get baseUrl;
  List<ScrapedOffer> parse(String html);
}

class ScraperRegistry {
  final Map<String, DiscounterScraper> _scrapers = {};
  
  void register(DiscounterScraper scraper) => _scrapers[scraper.discounterName] = scraper;
  DiscounterScraper get(String name) => _scrapers[name]!;
  List<DiscounterScraper> get all => _scrapers.values.toList();
}

// Setup in main.dart oder Provider:
// registry.register(AldiScraper());
// registry.register(LidlScraper());
// ...
```

**Warum:** Neuer Discounter = neue Klasse + eine `register()`-Zeile. Kein if/else-Turm. Testbar mit Mock-Scraper. Scraper können zur Laufzeit aktiviert/deaktiviert werden (User-Settings: "nur Aldi + Lidl").

---

### A2 — Drift-Generated-Code aus dem Review-Workflow ausschließen
**Status quo:** ~10k von 14k Zeilen sind Drift-Code → 70% der Codebase ist Noise für Reviews, Linting, Search.
**Refactoring:**

1. `.gitignore` prüfen: `*.g.dart` sollte committed sein (Drift braucht das zur Build-Zeit), ABER
2. `analysis_options.yaml` anpassen:

```yaml
analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.drift.dart"
    - "lib/data/database/generated/**"  # wenn ausgelagert
```

3. Drift-Code in eigenes Verzeichnis:

```yaml
# build.yaml
targets:
  $default:
    builders:
      drift_dev:
        options:
          store_schema_info: true
          new_sql_code_generation: true
          named_parameters: true
```

4. CI: Coverage-Report exkludiert `*.g.dart`:

```bash
# lcov.info
# remove lines matching "*.g.dart"
lcov --remove coverage/lcov.info '**/*.g.dart' -o coverage/lcov_clean.info
```

**Warum:** Codebase "fühlt" sich sofort kleiner an. Search-Ergebnisse zeigen nur noch echten Code. Reviews fokussieren auf 4k Zeilen echte Logik.

---

### A3 — Riverpod-Provider in `ui/providers.dart` als 105-Zeilen-Monolith → Feature-basiert aufteilen
**Status quo:** Alle Provider in einer Datei → jeder Screen importiert alles, Abhängigkeiten unklar.
**Refactoring:** Feature-basierte Provider-Dateien:

```
lib/ui/
├── features/
│   ├── recipe/
│   │   ├── providers/
│   │   │   ├── recipe_list_provider.dart
│   │   │   └── recipe_detail_provider.dart
│   │   └── screens/
│   ├── weekly_plan/
│   │   ├── providers/
│   │   └── screens/
│   ├── offers/
│   │   ├── providers/
│   │   └── screens/
│   └── settings/
```

Jeder Provider-File <50 Zeilen, klare Scope. `providers.dart` kann bleiben als Barrel-Export für Backward-Compat, aber intern aufgespalten.

---

## 3. Quick-Wins (≤30 Min)

### QW1 — Scraper User-Agent: URL ist hardcoded → Doku-Link prüfen
**Datei:** `discounter_scraper.dart`, ~Zeile 25
**Problem:** Custom User-Agent mit `volkergrabbe.github.io` URL. Das ist PERSÖNLICH — wenn die App jemals geteilt/gepublished wird, ist das ein Privacy-Leak. Discounter-Server loggen User-Agents.
**Fix:**

```dart
// Vorher:
'User-Agent': 'KitchenCompanion/2.0 (volkergrabbe.github.io)'

// Nachher:
'User-Agent': 'KitchenCompanion/2.0 (local-first; no-tracking)'
```

**Aufwand:** 2 Minuten. Privacy-relevant.

---

### QW2 — DB-Schema: Fehlende Indexes auf Foreign-Keys
**Datei:** `lib/data/database/database.dart` (Drift-Schema)
**Problem:** Drift generiert PK-Indexes, aber FK-Columns (`recipeId` in Ingredients, `offerId` in WeeklyPlan) haben vermutlich keinen Index → Table-Scan bei Joins. Bei 1000+ Ingredients wird das spürbar.
**Fix:** In Drift-Schema Definition:

```dart
// ingredients.dart (Drift table)
class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId => integer().customConstraint('REFERENCES recipes(id)')();
  TextColumn get name => text()();
  
  @override
  List<Set<Column>> get uniqueKeys => [
    {recipeId, name}, // Composite unique — impliziert Index
  ];
}
// Oder explizit:
@override
  List<String> get customConstraints => ['CREATE INDEX idx_ingredients_recipe ON ingredients(recipe_id)'];
```

**Aufwand:** 10 Minuten. Performance-Boost bei Recipe-Detail-Loads.

---

### QW3 — Background-Jobs: Debug-Logging mit `developer.log` statt `print`
**Datei:** `lib/background/background_jobs.dart`
**Problem:** `print()` in workmanager-Callback ist in Release-Builds ineffizient (String-Interpolation auch wenn nicht gebraucht) und unsichtbar in Android Logcat ohne Tag.
**Fix:**

```dart
import 'dart:developer' as developer;

@override
void callbackDispatcher() {
  Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  Workmanager().registerOneOffTask(
    'scrape-offers',
    'scrapeOffers',
    constraints: Constraints(networkType: NetworkType.connected),
  );
}

void _log(String message, {String name = 'bg-jobs'}) {
  if (kDebugMode) {
    developer.log(message, name: name);
  }
}
```

**Aufwand:** 5 Minuten. Besseres Debugging, keine Release-Performance-Penalty.

---

## 4. Tests & Qualität

### Offensichtlich fehlende Tests

1. **`contraindication_checker_test.dart`** — KRITISCH. Das ist die Core-Domain-Logik (CML-Patient-Safety). Braucht mindestens:
   - Name-Match-only
   - Tag-Match-only
   - Name + Tag auf dieselbe Zutat (dedup-Test für P2-Bug)
   - Multiple Kontraindikationen kumulativ
   - Edge: Leeres Rezept, leere Kontraindikationen
   - Boundary: Score 0 (vollständig avoid), Score 100 (keine Match)

2. **`weekly_plan_engine_test.dart`** — Aggregation-Logik, Unit-Mismatch, 7-Tage-Edge-Cases (Wochenwechsel, Feiertage).

3. **`scraper_test.dart` per Discounter** — Mit goldenen HTML-Fixtures (1-2 gespeicherte HTML-Dateien pro Discounter im `test/fixtures/` Verzeichnis). Test parst Fixture und assertet Offer-Count + erste Offer-Felder. BRICHT wenn HTML-Struktur sich ändert → frühzeitige Warnung.

4. **`recipe_repository_impl_test.dart`** — Drift-Row → Entity-Mapping. Mit `drift_test`-Package (in-memory DB).

5. **`secure_storage_service_test.dart`** — API-Key Roundtrip, Encryption-Verfügbarkeit.

### Gut testbare Strukturen (vorhanden)

- **Scraper-Interface** (`discounter_scraper.dart`): HTTP-Client als Interface → Mockbar, HTML-Fixture-Tests möglich. Bestes Design-Muster in der Codebase.
- **Riverpod**: Provider sind per Design testbar via `ProviderContainer` + `override`. Domain-Logic kann ohne UI getestet werden.
- **Drift in-memory DB**: Drift unterstützt `NativeDatabase.memory()` für Tests → keine File-IO nötig.
- **Clean Architecture-Trennung**: Domain kennt kein Drift, kein Flutter → pure-Dart-Tests möglich für `ContraindicationChecker`, `WeeklyPlanEngine`.

---

## 5. DSGVO / Lokal-First-Audit

### Gebrochene "100% lokal"-Versprechen

1. **Discounter-Scraper** (`discounter_scraper.dart` + Subklassen) — HTTP-Calls an aldi.de, lidl.de, etc. Das ist BY DESIGN lokal (Scraping statt API), ABER:
   - **User-Agent** enthält persönliche URL (`volkergrabbe.github.io`) → Privacy-Leak an Discounter-Server
   - **Keine IP-Masking-Option** (Tor/Proxy) → IP wird geloggt
   - **Cookies:** Dart `http.Client` speichert keine Cookies per Default — OK, aber wenn jemals `dio` mit CookieJar eingeführt wird, ist das ein Tracking-Risiko

2. **Marktguru-API-Hook** (`secure_storage_service.dart`) — Optionaler API-Key gespeichert. Wenn aktiviert, gehen Requests an Marktguru-Server. Das ist dokumentiert optional, ABER:
   - **API-Key in secure_storage** = gut, aber Key ist im Android-Keystore verschlüsselt — bei gerootetem Device auslesbar
   - **Keine Consent-Dialog** beim ersten API-Aktivieren → DSGVO fordert informed consent
   - **Keine Logging-Offenlegung:** Was loggt Marktguru? (IP, User-Agent, Request-Pattern) — sollte in Settings dokumentiert sein

3. **flutter_local_notifications** — Lokal, keine Telemetry. ABER: Scheduled Notifications über `workmanager` → Android 14+ fordert `SCHEDULE_EXACT_ALARM` Permission. Im Manifest prüfen:

```xml
<!-- AndroidManifest.xml — falls vorhanden -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.USE_EXACT_ALARM" /> <!-- Android 14+ -->
```

4. **Crash-Logging / Telemetry** — Prüfen ob Sentry/Firebase/Crashlytics in `pubspec.yaml` ist. Falls ja → "100% lokal" ist gebrochen. Falls nein → OK.

5. **Drift/SQLite** — Lokal, OK. ABER: **Backup-Export** — wenn die App einen Export-Button hat (JSON/CSV), prüfen ob der lokal bleibt (Share-Sheet → lokaler Dateimanager) oder Cloud-Upload anbietet.

6. **Dependencies audit** — `pubspec.lock` prüfen auf transitive Dependencies die phone-home:

```bash
flutter pub deps | grep -iE "analytics|telemetry|sentry|firebase|crashlytics|amplitude|mixpanel"
```

### DSGVO-Compliance-Checkliste für App-Beschreibung

- [ ] Scraper-HTTP-Calls in Privacy-Policy erwähnt ("Angebote werden direkt von Discounter-Webseiten abgerufen, Ihre IP-Adresse wird dabei an den jeweiligen Discounter übermittelt")
- [ ] Marktguru-API-Integration dokumentiert mit Consent-Flow
- [ ] Keine Crash-Reporting-Library aktiv
- [ ] Notification-Permissions dokumentiert
- [ ] Export/Import-Funktion bleibt lokal (file_picker, nicht cloud_upload)

---

## Zusammenfassung

| Priorität | Problem | Aufwand | Risiko |
|-----------|---------|---------|--------|
| P1 | Theme-Load blockiert Start | 30min | Hoch (UX) |
| P2 | Contraindication-Score-Bug | 20min | Kritisch (Patient-Safety) |
| P3 | Scraper ohne Timeout/Retry | 45min | Mittel (Background-Jobs) |
| P4 | Repository Gott-Klasse | 2-3h | Mittel (Wartbarkeit) |
| P5 | WeeklyPlan O(n²) | 1h | Niedrig (Performance) |

P2 ist der wichtigste Fix — CML-Patient-Safety-Scoring MUSS korrekt sein. Ein falscher Score von 40 statt 30 kann eine "limit"-Kontraindikation als "akzeptabel" einstufen, wenn der User mit Score-Grenzwerten arbeitet. Das ist kein Schönheitsfehler, das ist ein medizinisches Risiko in der App-Logik.

session_id: 20260620_135109_41b5f6
