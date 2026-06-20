# Kitchen Companion — Play Store Assets v2.0

## App-Titel (30 Zeichen)
**Kitchen Companion – Wochenplan**

## Kurzbeschreibung (80 Zeichen)
**Wochenplan mit Discounter-Angeboten + Kontraindikationen – 100% lokal.**

## Vollständige Beschreibung (DE, 4000 Zeichen)

🥘 **Dein Küchenplan, der wirklich zu dir passt.**

Kitchen Companion generiert einen **Wochenplan basierend auf den aktuellen
Angeboten deiner lokalen Discounter** (Aldi, Lidl, Rewe, Netto, Penny,
Norma) und respektiert dabei **medizinische Kontraindikationen** (Diabetes,
Zöliakie, Laktoseintoleranz, Medikamente wie Marcumar, Metformin und mehr).

Das ist das **Alleinstellungsmerkmal**, das keine andere Rezept-App bietet.

### Was die App kann

- **📅 Wochenplan** für 1–4 Personen
- **💰 Discounter-Angebote live** (Aldi, Lidl, Rewe, Netto, Penny, Norma)
- **🚫 Kontraindikations-Filter** für 10 Krankheiten + 15 Medikamente,
  erweiterbar
- **🍳 Rezeptverwaltung** mit Nährwerten
- **📝 Einkaufsliste** automatisch aus Wochenplan
- **🥗 Ernährungstagebuch** mit Kalorien- und Makro-Tracking
- **🔄 Wöchentliche Updates** im Hintergrund (Android)
- **🌍 10 Sprachen**: DE, EN, FR, ES, IT, PL, NL, CS, PT, SV

### Deine Daten bleiben bei dir

- **100% lokal**: Keine Cloud, kein Account, keine Telemetrie
- **Keine Tracker, keine Werbung**
- **Nur die nötigsten Berechtigungen**: Internet (für Scraping) und
  Benachrichtigungen
- **Auto-Backup deaktiviert** — deine medizinischen Daten verlassen das
  Gerät nicht
- **Open Source**: github.com/volkergrabbe/kitchen-companion

### Datenschutz

Wir beziehen Angebote direkt von den öffentlichen Webseiten der Discounter,
ohne Tracking, ohne Cookies, ohne Account. Optional kannst du einen
Marktguru-API-Key eingeben (lokal verschlüsselt via Android Keystore).

Vollständige Datenschutzerklärung:
https://volkergrabbe.github.io/kitchen-companion/privacy.html

### Hinweis zum Scraping

Web-Scraping ist eine rechtliche Grauzone. Wir respektieren robots.txt,
Quellenangabe in jedem Angebot, Rate-Limit 1 Request pro 3 Sekunden. Bei
offiziellen APIs der Discounter migrieren wir.

### Systemvoraussetzungen

- Android 6.0 (API 23) oder höher
- ~30 MB Speicher
- Internet nur für Discounter-Updates erforderlich

### Kontakt

- E-Mail: volker@grabbe.info
- Repository: github.com/volkergrabbe/kitchen-companion
- Lizenz: MIT (Open Source)

---

**Hinweis:** Diese App ist KEIN medizinisches Produkt. Konsultiere bei
ernsthaften Krankheiten immer einen Arzt. Die Kontraindikations-Datenbank
basiert auf öffentlichen Quellen und ist ohne Gewähr.

---

## Vollständige Beschreibung (EN, 4000 Zeichen)

🥘 **Your meal plan that truly fits you.**

Kitchen Companion generates a **weekly plan based on current offers from
your local discounters** (Aldi, Lidl, Rewe, Netto, Penny, Norma) while
respecting **medical contraindications** (diabetes, celiac disease, lactose
intolerance, medications like warfarin, metformin and more).

This is the **unique selling point** no other recipe app offers.

### Features

- **📅 Weekly plan** for 1–4 people
- **💰 Live discounter offers**
- **🚫 Contraindication filter** for 10 diseases + 15 medications,
  extensible
- **🍳 Recipe management** with nutritional info
- **📝 Shopping list** auto-generated from weekly plan
- **🥗 Food journal** with calorie + macro tracking
- **🔄 Weekly background updates** (Android)
- **🌍 10 languages**

### Your data stays with you

- **100% local**: No cloud, no account, no telemetry
- **No trackers, no ads**
- **Only the necessary permissions**: Internet (for scraping) and
  notifications
- **Auto-backup disabled** — your medical data never leaves the device
- **Open source**: github.com/volkergrabbe/kitchen-companion

### Privacy

We fetch offers directly from public discounter websites, no tracking, no
cookies, no account. Optionally you can enter a Marktguru API key (locally
encrypted via Android Keystore).

Full privacy policy:
https://volkergrabbe.github.io/kitchen-companion/privacy.html

### Disclaimer

Web scraping is a legal gray area. We respect robots.txt, cite every
offer's source, rate-limit 1 request per 3 seconds. If discounters release
official APIs, we migrate.

### System requirements

- Android 6.0 (API 23) or higher
- ~30 MB storage
- Internet only required for discounter updates

### Contact

- Email: volker@grabbe.info
- Repository: github.com/volkergrabbe/kitchen-companion
- License: MIT (Open Source)

---

**Note:** This app is NOT a medical device. For serious medical conditions,
always consult a doctor. The contraindication database is based on public
sources and comes without warranty.

---

## Screenshots (8x, Mockup-Beschreibung)

Da ich keine echten Screenshots generieren kann (müsste die App auf einem
Android-Gerät öffnen), hier die Beschreibungen für die Screenshots, die
du/ich vor dem Upload brauchen:

| # | Titel | Was zu sehen ist |
|---|---|---|
| 1 | **Wochenplan** | 7-Tage-Grid mit Frühstück/Mittag/Abend, Rezeptbilder, Preis-Indikator "💰 Lidl €1,99" |
| 2 | **Rezepte** | Liste mit Bildern, Nährwerte-Badge (kcal/P/K/F), Suchfeld oben |
| 3 | **Einkaufszettel** | Auto-generiert aus Wochenplan, abhakbar, gruppiert nach Discounter |
| 4 | **Discounter-Angebote** | Liste aktiver Angebote, Filter nach Discounter, gültig-bis-Datum |
| 5 | **Kontraindikationen** | Aktive Liste (Marcumar, Zöliakie), Severity-Badges (avoid/limit/caution) |
| 6 | **Ernährungstagebuch** | Tagesansicht mit Balkendiagramm (Makros), Mahlzeiten-Liste |
| 7 | **Einstellungen** | Personen-Anzahl, PLZ, Discounter-Auswahl, Marktguru-API-Key |
| 8 | **Benachrichtigungen** | Wochenplan-Update-Notification |

**Erstellung:** Installiere die APK (`flutter build apk --release`) auf
einem Android-Gerät, mache 8 Screenshots, lade sie hier hoch.

---

## Feature Graphic (1024×500)

Empfehlung:
- Hintergrund: Warme Farbe (#FF6F61 Korall)
- Vorne: Foto einer Gemüsepfanne + Text "Wochenplan · Discounter · Kontraindikationen"
- Branding: "Kitchen Companion" Logo oben links

**Tooling:** Canva, GIMP, oder Image-Generate-MCP

---

## App Icon (512×512)

Empfehlung:
- Hintergrund: Warmes Orange (#FF6F61)
- Vorne: Weißer Löffel mit grünem Check ✓
- Stil: Material Design 3, abgerundete Ecken

**Tooling:** Image-Generate-MCP (Prompt: "App icon, kitchen utensil with
green check, warm orange background, material design 3, flat")

---

## Content Rating (Google Play Console)

- **IARC:** Everyone (keine Gewalt, keine Adult-Content, keine Drogen)
- **Category:** Health & Fitness (NICHT Medical — keine FDA-Zulassung nötig)
- **COVID-19:** Nein
- **User-generated content:** Nein
- **Personal data collection:** Ja (lokal — auf Gerät) — korrekt deklarieren
- **Location:** Nein
- **Financial:** Nein

---

## Preisgestaltung

- **Modell:** Kostenlos + Open Source (kein Play-Billing)
- **Spenden:** Optional via GitHub Sponsors (Link in App-Beschreibung)

---

## Pre-Launch Checkliste

- [ ] Privacy Policy auf github.io URL veröffentlicht
- [ ] App-Beschreibung finalisiert
- [ ] 8 Screenshots erstellt
- [ ] Feature Graphic erstellt
- [ ] App Icon (512×512) erstellt
- [ ] Content-Rating ausgefüllt
- [ ] APK signing config in `android/app/build.gradle` auf Release-Key umgestellt
- [ ] AAB (nicht APK) gebaut: `flutter build appbundle --release`
- [ ] Google Play Developer Account vorhanden (25 USD einmalig)
- [ ] AAB in Play Console hochgeladen
- [ ] Internal Testing Track erstellt