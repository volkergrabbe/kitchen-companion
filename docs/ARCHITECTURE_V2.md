# Kitchen Companion v2.0 — Architektur

## USP (Alleinstellungsmerkmal)

**Wöchentlicher Küchenplan, der automatisch die aktuellen Angebote lokaler Discounter
berücksichtigt UND medizinische Kontraindikationen (Krankheiten + Medikamente) respektiert.**

Keine andere App macht beides kombiniert.

## Funktionsumfang v2.0

| Feature | Quelle v1 | v2.0 |
|---|---|---|
| Rezepte verwalten | ✅ | ✅ erweitert |
| Einkaufsliste | ✅ | ✅ aus Wochenplan auto-generiert |
| Ernährungstagebuch | ✅ | ✅ bleibt |
| Settings (Sprache, Theme, Makros) | ✅ | ✅ bleibt |
| **Wochenplan** | ❌ | ✅ **NEU – Kernfeature** |
| **Discounter-Angebote live** | ❌ | ✅ **NEU – USP** |
| **Kontraindikationen (Krankheit+Medikament)** | ❌ | ✅ **NEU – USP** |
| **Hintergrund-Job** | ❌ | ✅ **NEU** |
| **1–4 Personen skalierbar** | ❌ | ✅ **NEU** |
| Marktguru-API (Premium) | ❌ | 🟡 Hook vorbereitet, Feature-Flag off |
| iOS-Support | ❌ | ❌ (Apple Developer Account fehlt) |

## Schichten-Architektur

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter App                          │
├─────────────────────────────────────────────────────────┤
│  UI Layer (lib/ui/)                                     │
│  ├─ screens/         (Rezepte, Wochenplan, Journal, …)  │
│  ├─ widgets/         (Reusable Components)              │
│  └─ theme/           (M3 Theming, Dark/Light)          │
│                                                         │
│  Business Layer (lib/domain/)                           │
│  ├─ entities/        (Recipe, WeeklyPlan, Contraind…)   │
│  ├─ usecases/        (GeneratePlan, FilterRecipes)      │
│  ├─ repositories/    (Interface-Defs)                   │
│  └─ services/        (PlanEngine, ContraindicationChk)  │
│                                                         │
│  Data Layer (lib/data/)                                 │
│  ├─ database/        (Drift, Migrations, DAOs)          │
│  ├─ repositories/    (Impl)                             │
│  └─ sources/                                            │
│      ├─ local/       (Drift)                            │
│      ├─ scraper/     (Discounter Web-Scraping)          │
│      └─ api/         (Marktguru – Hook, aus)            │
│                                                         │
│  Background Layer (lib/background/)                     │
│  ├─ workmanager.dart (Android periodic jobs)            │
│  └─ bg_task.dart     (iOS Hook – no-op für v1)          │
└─────────────────────────────────────────────────────────┘
```

## Datenbank-Schema v2.0

### Bestehend (aus v1)
- `recipes` — id, name, description, prep_time, calories, protein, carbs, fat, created_at
- `shopping_items` — id, item, quantity, unit, checked
- `food_log` — id, date, meal_type, calories, protein, carbs, fat, custom_name
- `settings` — id, locale, units, theme, calorie_goal, protein_goal, carbs_goal, fat_goal

### NEU in v2.0

#### `ingredients`
Master-Tabelle aller bekannten Lebensmittel.
| Col | Typ | Notes |
|---|---|---|
| id | INTEGER PK | |
| name | TEXT NOT NULL UNIQUE | |
| category | TEXT | gemüse, obst, fleisch, fisch, milchprodukt, getreide, gewürz, … |
| unit_default | TEXT | g, ml, stück |
| season_start | INTEGER | Monat (1-12) |
| season_end | INTEGER | Monat |
| allergens | TEXT (JSON) | ["gluten","lactose","nuts"] |
| notes | TEXT | |

#### `recipe_ingredients`
| Col | Typ | Notes |
|---|---|---|
| recipe_id | INTEGER FK | |
| ingredient_id | INTEGER FK | |
| quantity_per_person | REAL | Menge für 1 Person |
| unit | TEXT | |

#### `contraindications` (vordefinierte Liste, geseedet)
| Col | Typ | Notes |
|---|---|---|
| id | INTEGER PK | |
| type | TEXT | "disease" / "medication" |
| code | TEXT UNIQUE | "diabetes_type2", "celiac", "warfarin", … |
| display_name_de | TEXT | |
| display_name_en | TEXT | |
| excluded_ingredients | TEXT (JSON) | ["sugar","wheat_flour"] |
| warning_text | TEXT | "Vorsicht bei Vitamin-K-reichem Gemüse" |
| severity | TEXT | "avoid" / "limit" / "caution" |

#### `user_contraindications`
| Col | Typ | Notes |
|---|---|---|
| id | INTEGER PK | |
| contraindication_id | INTEGER FK | |
| severity_override | TEXT NULL | optional |
| added_at | TEXT | |

#### `discounters`
| Col | Typ | Notes |
|---|---|---|
| id | INTEGER PK | |
| name | TEXT UNIQUE | "Aldi Nord", "Lidl", … |
| scraper_class | TEXT | "AldiScraper" |
| enabled | INTEGER | 0/1 |
| logo_path | TEXT NULL | |
| api_type | TEXT NULL | "marktguru" (für v1.1) |
| api_base_url | TEXT NULL | |
| api_key_env | TEXT NULL | |

#### `offers`
| Col | Typ | Notes |
|---|---|---|
| id | INTEGER PK | |
| discounter_id | INTEGER FK | |
| ingredient_id | INTEGER FK NULL | Match auf ingredient, falls erkannt |
| raw_name | TEXT | Original-Name aus Scrap |
| price | REAL | EUR |
| unit_text | TEXT | "1 kg", "500 g Packung" |
| valid_from | TEXT | YYYY-MM-DD |
| valid_to | TEXT | YYYY-MM-DD |
| fetched_at | TEXT | |
| source_url | TEXT | Provenienz |

#### `weekly_plans`
| Col | Typ | Notes |
|---|---|---|
| id | INTEGER PK | |
| week_start | TEXT | YYYY-MM-DD (Montag) |
| persons | INTEGER | 1-4 |
| status | TEXT | "draft","active","completed" |
| created_at | TEXT | |

#### `plan_meals`
| Col | Typ | Notes |
|---|---|---|
| id | INTEGER PK | |
| plan_id | INTEGER FK | |
| date | TEXT | YYYY-MM-DD |
| meal_type | TEXT | breakfast/lunch/dinner/snack |
| recipe_id | INTEGER FK NULL | |
| custom_name | TEXT NULL | Falls kein Rezept |
| serves | INTEGER | portions (für Personen-Skalierung) |

#### `plan_ingredients`
| Col | Typ | Notes |
|---|---|---|
| plan_id | INTEGER FK | |
| ingredient_id | INTEGER FK | |
| total_quantity | REAL | |
| unit | TEXT | |
| offer_id | INTEGER FK NULL | Wenn auf Discounter-Offer gemappt |

#### `user_profile` (NEU, ersetzt/erweitert settings)
| Col | Typ | Notes |
|---|---|---|
| id | INTEGER PK (immer 1) | |
| persons | INTEGER | 1-4 |
| zip_code | TEXT | Postleitzahl für Discounter-Filter |
| selected_discounters | TEXT (JSON) | [1,2,3] |
| weekly_plan_auto | INTEGER | 0/1 – Hintergrund-Plan aktiviert |
| plan_dow | INTEGER | Wochentag für Plan-Generierung (1=Mo) |

## Discounter-Scraper (Scraping-Layer)

### Prinzip
- **Modular** pro Discounter: `lib/data/sources/scraper/<discounter>_scraper.dart`
- **Respektiere `robots.txt`**: User-Agent setzen, Rate-Limit 1 Request / 3s
- **Caching** in Drift-Tabelle `offers`, gültig `valid_to` bis
- **Fehlertolerant**: Fehler beim Scrap = bestehende Offers bleiben, Notification „Aktualisierung fehlgeschlagen"
- **Quellenangabe**: Jeder Offer hat `source_url`
- **Lokal & offline-fähig**: Scrap nur wenn App offen ist oder via Hintergrund-Job mit INTERNET-Permission

### Discounter-Liste v2.0 (DE)
| Discounter | Scrap-Quelle | Status |
|---|---|---|
| Aldi Nord | aldipro.de | zu implementieren |
| Aldi Süd | aldi-sued.de | zu implementieren |
| Lidl | lidl.de | zu implementieren |
| Rewe | rewe.de | zu implementieren |
| Netto | netto-online.de | zu implementieren |
| Penny | penny.de | zu implementieren |
| Norma | norma-online.de | zu implementieren |

### Marktguru-API-Hook (v1.1, auskommentiert)
```dart
// lib/data/sources/api/marktguru_api.dart
class MarktguruApi {
  // AUSKOMMENTIERT in v2.0.0 – aktivieren in v2.1 mit API-Key
  // final String apiKey;
  // Future<List<Offer>> fetchOffers({required String zip, …});
}
```
Feature-Flag in `settings`: `marktguru_enabled = false` (default).
Sobald du Marktguru-Account + API-Key hast → ein Kommentar entfernen, Setting umlegen, fertig.

## Kontraindikations-Modul

### Geseedete Liste (v2.0)
**Krankheiten** (10):
- Diabetes Typ 1 / Typ 2
- Zöliakie (Gluten)
- Laktoseintoleranz
- Fructosemalabsorption
- Histaminintoleranz
- Gicht
- Niereninsuffizienz
- Hypertonie (Bluthochdruck)
- Fettleber / NAFLD
- Phenylketonurie (PKU)

**Medikamente** (15):
- Vitamin-K-Antagonisten (Marcumar/Warfarin)
- Statine (Simvastatin, Atorvastatin)
- Metformin
- ACE-Hemmer
- Betablocker
- Schilddrüsenhormone (L-Thyroxin)
- MAO-Hemmer
- Kortikosteroide (Prednisolon)
- Antibiotika (Gyrasehemmer)
- Immunsuppressiva
- Orale Kontrazeptiva
- PPI (Omeprazol)
- Diuretika
- Lithium
- Digoxin

### Erweiterbar
User kann eigene hinzufügen via Settings → Kontraindikationen → „Eigene hinzufügen".

### Filter-Logik
```
Input: Rezept-Liste, User-Contraindikationen
Output: Score pro Rezept (0-100)
Berechnung:
  - severity "avoid"  → Rezept raus, score = 0
  - severity "limit"  → score -= 30, Tagesmenge wird gekappt
  - severity "caution" → score -= 10, Warnung im Rezept
  - Bonus: viele Discounter-Angebote für enthaltene Zutaten → score += 5
Sortierung nach score DESC, Top-N in Wochenplan übernehmen
```

## Wochenplan-Engine

### Algorithmus
```
1. Hole aktive Offers (gültig in Planwoche)
2. Hole Rezepte (lokal)
3. Filter Rezepte via Kontraindikations-Modul
4. Score Rezepte (Kontraindikation + Offer-Match + Saisonalität)
5. Wähle 21 Mahlzeiten (3/Tag × 7 Tage) aus Top-Score-Pool
   - Variance: nicht 3× das gleiche Rezept an einem Tag
   - nicht >2× das gleiche Rezept pro Woche
6. Skaliere Mengen auf persons (1-4)
7. Aggregiere Zutaten über alle Mahlzeiten → Einkaufszettel
8. Mappe Zutaten auf Offers (bester Preis) → Einkaufszettel mit Preisen
9. Schreibe Plan in DB
```

### Hintergrund-Job (Android)
- `workmanager` Package
- Periodic: alle 7 Tage, am Sonntag 22:00
- Bedingungen: INTERNET verfügbar, Batterie > 30%
- Output: Notification „Wochenplan aktualisiert"

### iOS
- `BGTaskScheduler` Hook vorhanden
- Funktioniert in v2.0 nur, wenn User die App mind. 1×/Woche öffnet (Apple-Restriktion)
- Effektiv für v2.0: Plan-Generierung nur bei App-Open

## Permissions (Android Manifest)

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
```

**Keine** Kontakte, Kamera, Standort, Mikrofon, Speicher.

## i18n
- 10 Sprachen wie v1
- Neue Strings: Wochenplan, Kontraindikationen, Discounter, Hintergrund-Job

## Privacy / DSGVO
- Keine Cloud. Alles lokal.
- Discounter-Scraping: nur öffentliche Webseiten, kein Account nötig
- Optional Marktguru-API: User gibt selbst API-Key ein (lokal gespeichert)
- Privacy Policy URL: `https://volkergrabbe.github.io/kitchen-companion/privacy.html`

## Versionierung
- v2.0.0 (initial)
- pubspec.yaml version: 2.0.0+20 (20 = interne Build-Nummer)

## Status
- [x] Architektur dokumentiert
- [ ] Schema-Migration geschrieben
- [ ] Seed-Data (500 Zutaten + 50 Rezepte + 25 Kontraindikationen) geladen
- [ ] Scraper implementiert (mind. 3 Discounter)
- [ ] Plan-Engine funktioniert
- [ ] UI alle Screens
- [ ] Hintergrund-Job läuft
- [ ] Tests grün
- [ ] AAB signiert
- [ ] Play-Store-Assets fertig