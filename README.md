# Kitchen Companion

**Lokale Koch-Assistent-App — keine Cloud, keine Auth, keine Kompromisse.**

Rezepte verwalten, Einkaufsliste führen, Ernährungstagebuch pflegen. Alles auf dem Gerät, alles privat.

---

## Was das ist

Kitchen Companion ist eine Flutter-App für Menschen, die ihre Kochdaten selbst behalten wollen.

- **Rezepte** — suchen, speichern, bewerten, mit Nährwerten
- **Einkaufsliste** — automatisch aus Rezepten generieren, abhaken
- **Ernährungstagebuch** — Mahlzeiten protokollieren, Kalorien tracken
- **Ziele** — Kalorien, Protein, Kohlenhydrate, Fett setzen und verfolgen

Kein Account. Kein Cloud-Sync. Kein "Wir haben Ihre Rezeptdaten für unsere KI verwendet."

---

## Tech Stack

```
Flutter 3.5+ / Dart 3.5+
Drift 2.18 (SQLite ORM) — lokale Datenbank
flutter_localizations — i18n (DE, EN, FR, ES, IT, PL, NL, CS, PT, SV)
Material Design 3 — UI Framework
```

---

## Privacy First

| Feature | Status |
|---------|--------|
| Keine Cloud | ✅ |
| Keine Auth | ✅ |
| Keine Internet-Verbindung nötig | ✅ |
| Daten auf dem Gerät | ✅ |
| Kein Tracking | ✅ |
| Keine Werbung | ✅ |

Diese App ist für Menschen, die wissen wollen, was mit ihren Daten passiert.

---

## Installation

### APK (Android)

```bash
# Debug APK (bereits gebaut)
build/app/outputs/flutter-apk/app-debug.apk
```

### Aus Source

```bash
flutter pub get
flutter gen-l10n
flutter build apk --debug
# oder
flutter build apk --release
```

### Von Git

```bash
# Clone
git clone https://github.com/volkergrabbe/kitchen-companion.git
cd kitchen-companion

# Abhängigkeiten
flutter pub get
flutter gen-l10n

# Build
flutter build apk --release
```

---

## Projektstruktur

```
lib/
├── main.dart                 # App-Entry, Theme, Navigation
├── database/
│   └── database.dart         # Drift-DB: Tables, DAOs, Streams
│   └── database.g.dart       # Generiert
l10n.yaml                     # i18n Konfiguration
assets/                       # Lokalisierte Strings (generiert)
```

### Datenbank (Drift)

- **recipes** — Name, Beschreibung, Zubereitungszeit, Kalorien, Makros
- **shopping_items** — Name, Menge, Einheit, Checkbox
- **food_log** — Datum, Mahlzeitstyp, Kalorien, Makros, manueller Name
- **settings** — Sprache, Einheiten, Theme, Makro-Ziele

---

## Lokalisierung

Aktuell: DE, EN, FR, ES, IT, PL, NL, CS, PT, SV

Neue Sprache hinzufügen:
1. `l10n.yaml` → `synthetic-package: false` setzen
2. `lib/l10n/` erstellen
3. `flutter gen-l10n` ausführen

---

## Motivation

Ich habe keine App gefunden, die:
- Lokal funktioniert (ohne Cloud)
- Keine Werbung hat
- Keine Permissions für Kontakte oder Standort will
- Einfach nur Rezepte und Ernährung trackt

Also habe ich eine gebaut.

---

## Lizenz

MIT — mach was du willst, solange du den Copyright-Vermerk lässt.

---

## Links

- GitHub: https://github.com/volkergrabbe/kitchen-companion
- Forgejo: https://192.168.178.51:3000/volker/kitchen-companion