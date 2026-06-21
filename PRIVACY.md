# Datenschutzerklärung — Kitchen Companion v2.0

**Letzte Aktualisierung:** 19. Juni 2026
**Verantwortlich:** Volker Grabbe
**Kontakt:** volker@grabbe.info

## 1. Übersicht

Kitchen Companion ist eine **rein lokale App** für Rezepte, Einkaufslisten,
Wochenplanung mit Discounter-Angeboten und medizinische Kontraindikationen.
Die App speichert **alle Daten ausschließlich auf deinem Gerät** und überträgt
sie an **keinen Server des Anbieters**.

Die einzige ausgehende Verbindung besteht darin, dass die App öffentliche
Webseiten deutscher Discounter (Aldi, Lidl, Rewe, Netto, Penny, Norma) nach
Angeboten durchsucht, vergleichbar mit deinem Browser. Es werden keine
personenbezogenen Daten an Discounter übermittelt.

## 2. Verarbeitete Daten

| Daten | Zweck | Speicherort |
|---|---|---|
| Rezeptdaten (Name, Zutaten, Mengen, Nährwerte) | Funktion der App | Lokal (SQLite) |
| Einkaufsliste | Funktion der App | Lokal |
| Ernährungstagebuch (Mahlzeiten, Kalorien) | Funktion der App | Lokal |
| Wochenpläne | Funktion der App | Lokal |
| Kontraindikationen (Krankheiten, Medikamente) | Wochenplan-Filter | Lokal, verschlüsselt (Android Keystore) |
| Postleitzahl | Discounter-Auswahl | Lokal |
| **Optional:** Marktguru-API-Key | Anbindung an Marktguru-API | **flutter_secure_storage** (verschlüsselt via Android Keystore) |

## 3. Berechtigungen

| Android-Permission | Zweck |
|---|---|
| `INTERNET` | Web-Scraping der Discounter-Webseiten, Marktguru-API |
| `ACCESS_NETWORK_STATE` | Erkennung ob Internet verfügbar ist |
| `POST_NOTIFICATIONS` | Benachrichtigung bei Wochenplan-Update |
| `RECEIVE_BOOT_COMPLETED` | Hintergrund-Job für wöchentliche Plan-Aktualisierung |
| `WAKE_LOCK` | Hintergrund-Job stabil abschließen |

**Keine** Kamera, Mikrofon, Standort, Kontakte, Speicher.

## 4. Web-Scraping (Discounter)

Die App ruft öffentliche Webseiten folgender Discounter ab:
- Aldi Nord / Aldi Süd
- Lidl
- Rewe
- Netto
- Penny
- Norma

**Was wir senden:**
- Standard HTTP-Request mit User-Agent: `KitchenCompanion/2.0 (Local-First Android-App; kein Tracking)`
- KEINE Cookies
- KEINE Location
- KEINE Auth-Daten
- Rate-Limit: 1 Request pro 3 Sekunden pro Discounter

**Was wir speichern:**
- Angebotsname, Preis, Gültigkeitszeitraum, Quell-URL
- KEINE IP-Adresse
- KEINE Browser-Fingerprint-Daten

## 5. Marktguru-API (optional)

Wenn du einen Marktguru-API-Key eingibst, wird dieser lokal in
**flutter_secure_storage** gespeichert, das den Android Keystore nutzt
(hardware-verschlüsselt). Der Key wird niemals an Dritte gesendet und
niemals in Logs geschrieben.

Du kannst den Key jederzeit in den Einstellungen löschen. Die App
funktioniert vollständig ohne Marktguru-API — sie nutzt dann nur
Web-Scraping.

## 6. Automatische Backups

**Android Auto-Backup und Cloud-Backup sind deaktiviert.** Krankheiten,
Medikamente und andere sensible Daten verbleiben auf deinem Gerät.

## 7. Kinder

Kitchen Companion richtet sich an Erwachsene. Personen unter 16 Jahren
sollten die Erlaubnis ihrer Eltern einholen.

## 8. Deine Rechte (DSGVO)

Du hast jederzeit das Recht auf:
- **Auskunft:** Du siehst alle Daten in der App
- **Löschung:** App deinstallieren löscht alle Daten
- **Datenübertragbarkeit:** Datenbank ist SQLite, lesbar mit jedem DB-Viewer
- **Widerspruch:** Du kannst jeden Discounter einzeln deaktivieren

## 9. Hosting

Diese App wird **nicht auf einem Server gehostet**. Sie läuft vollständig
auf deinem Android-Gerät. Es gibt kein Backend, keine User-Accounts, keine
Telemetrie.

## 10. Kontakt

Fragen zum Datenschutz: volker@grabbe.info

## 11. Änderungen

Änderungen an dieser Erklärung werden im GitHub-Repository dokumentiert:
https://github.com/volkergrabbe/kitchen-companion/commits/main/PRIVACY.md