# Kitchen Companion — Architektur

## Überblick

```
┌─────────────────────────────────────────┐
│              Flutter App                │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────┐  ┌──────────────────┐  │
│  │   UI Layer  │  │  Business Logic  │  │
│  │  (Widgets)  │──│   (StateManagement│  │
│  └─────────────┘  └────────┬─────────┘  │
│                            │            │
│                 ┌──────────▼─────────┐  │
│                 │    Data Layer      │  │
│                 │   (Drift / SQLite) │  │
│                 └────────────────────┘  │
└─────────────────────────────────────────┘
         Kein Backend. Keine Cloud.
```

## Schichten

### UI Layer (`lib/`)
Widgets, Screens, Navigation. Keine Business Logic hier — nur Darstellung.

- `main.dart` — App-Entry, MaterialApp, Theme, BottomNavigation
- Screens: `RecipesScreen`, `ShoppingListScreen`, `FoodJournalScreen`, `SettingsScreen`

### Data Layer (`lib/database/`)
Drift-Datenbank. Alle Daten lokal, alle Operationen synchron oder asynchron via Streams.

- `database.dart` — Table-Definitions, DAOs, Stream-Getter
- `database.g.dart` — generiert via `dart run build_runner build`

## Datenbank-Schema

### recipes
| Column | Type | Notes |
|--------|------|-------|
| id | INTEGER | Primary Key, Auto-Inkrement |
| name | TEXT | Rezeptname |
| description | TEXT | Optional |
| prep_time | INTEGER | Minuten |
| calories | INTEGER | kcal |
| protein | REAL | Gramm |
| carbs | REAL | Gramm |
| fat | REAL | Gramm |
| created_at | TEXT | ISO 8601 |

### shopping_items
| Column | Type | Notes |
|--------|------|-------|
| id | INTEGER | Primary Key |
| item | TEXT | Name |
| quantity | REAL | Menge |
| unit | TEXT | kg, Stück, etc. |
| checked | INTEGER | 0/1 Boolean |

### food_log
| Column | Type | Notes |
|--------|------|-------|
| id | INTEGER | Primary Key |
| date | TEXT | YYYY-MM-DD |
| meal_type | TEXT | breakfast/lunch/dinner/snack |
| calories | INTEGER | kcal |
| protein | REAL | Gramm |
| carbs | REAL | Gramm |
| fat | REAL | Gramm |
| custom_name | TEXT | Optional |

### settings
| Column | Type | Notes |
|--------|------|-------|
| id | INTEGER | Primary Key (immer 1) |
| locale | TEXT | de, en, fr... |
| units | TEXT | metric/imperial |
| theme | TEXT | light/dark/system |
| calorie_goal | INTEGER | |
| protein_goal | REAL | |
| carbs_goal | REAL | |
| fat_goal | REAL | |

## i18n

Flutter's built-in `flutter_localizations` + `intl`.

Konfiguration in `l10n.yaml`:
```yaml
arb-dir: lib/l10n
template-arb-file: app_de.arb
output-localization-file: app_localizations.dart
```

Strings in `lib/l10n/app_XX.arb` (XX = Sprachcode).

## State Management

Kein externes State-Management-Framework. Flutter's eingebautes `setState()` + `StreamBuilder` für reaktive Updates.

Pattern:
1. Widget bekommt `AppDatabase`-Instanz im Constructor
2. `StreamBuilder` subscribed auf Drift-Streams
3. UI rebuilt automatisch bei DB-Änderungen

## Permissions (Android)

```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET"/>  <!-- Optional, für Updates -->
```

**Keine Kontakte, kein Standort, keine Kamera.**

## Build

```bash
# Debug
flutter build apk --debug

# Release
flutter build apk --release

# Output
# build/app/outputs/flutter-apk/app-release.apk
```