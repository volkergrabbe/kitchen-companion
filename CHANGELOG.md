# Changelog

Alle signifikanten Änderungen an Kitchen Companion werden hier dokumentiert.

## [1.0.0] — 2026-06-08

### Added
- **Rezepte-Verwaltung** — Rezepte erstellen, anzeigen, Nährwerte tracken
- **Einkaufsliste** — Items abhaken, gesamte Liste leeren
- **Ernährungstagebuch** — Mahlzeiten nach Datum protokollieren, Kalorien/Makros tracken
- **Einstellungen** — Sprache (10 Sprachen), Theme (Light/Dark/System), Makro-Ziele
- **Drift SQLite-DB** — Lokale Datenbank mit reactive Streams
- **i18n** — Deutsch, Englisch, Französisch, Spanisch, Italienisch, Polnisch, Niederländisch, Tschechisch, Portugiesisch, Schwedisch
- **Material Design 3** — Modernes UI mit dynamischem Color Scheme

### Known Issues
- Kalorien-Validierung: Akzeptiert aktuell alle positiven Integer (auch 0 und negative Werte) — Fix geplant
- Rezept-Detailansicht noch nicht implementiert
- Suchfunktion für Rezepte noch nicht implementiert
- Mahlzeiten-Erfassung noch nicht implementiert

---

## [0.1.0] — 2026-05-27

### Added
- Flutter-Projekt initialisiert mit `flutter create`
- Drift-Datenbank mit Schema für Recipes, ShoppingItems, FoodLog, Settings
- Basis-UI mit 4 Tabs: Rezepte, Einkaufsliste, Ernährungstagebuch, Einstellungen
- Build erfolgreich: `build/app/outputs/flutter-apk/app-debug.apk` (88MB)