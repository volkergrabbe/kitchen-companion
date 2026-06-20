# Kitchen Companion v2.0 — Adversarial Review #1: Privacy & DSGVO

**Reviewer:** Kontra-Hermes (Red Team)
**Datum:** 2026-06-19
**Projekt:** `/home/administrator/.hermes/workspace/kitchen_companion_v2`
**Methode:** Statische Code-Analyse aller in der Aufgabe genannten Pfade + Library-Inspektion (pubspec.lock, merged Manifests).

> **Rolle:** Befund. Keine Lösungen. Keine Fixes. Nur Schweregrade (P0/P1/P2) mit echtem Code-Beleg (file:line).

---

## Executive Summary

* **P0 — Marktguru-API-Key wird im Klartext in der unverschlüsselten SQLite-DB gespeichert** (`database.dart:208` + `impl.dart:450`). Auf gerooteten Geräten oder via Auto-Backup (s.u.) frei lesbar. Verstößt gegen jede vernünftige Auslegung von Art. 32 DSGVO (Sicherheit der Verarbeitung).
* **P0 — Android-Backup ist nicht deaktiviert.** Das production-merged Manifest (`build/app/intermediates/packaged_manifests/debug/AndroidManifest.xml`) enthält **kein** `android:allowBackup="false"` und **keine** `android:dataExtractionRules` / `android:fullBackupContent`. Android-Default ist `allowBackup=true` → die SQLite-DB mit **Krankheiten, Medikamenten, API-Key und PLZ** wird in Google Drive Auto-Backup hochgeladen — und auf Geräten mit `adb` (Debug) auch via `adb backup` extrahierbar.
* **P0 — POST_NOTIFICATIONS wird vom `flutter_local_notifications`-Plugin deklariert, aber die App fragt die Runtime-Permission (Android 13+) nirgends ab.** `flutter_local_notifications` mergt die Permission ein (`build/flutter_local_notifications/intermediates/merged_manifest/debug/AndroidManifest.xml`); ohne `requestPermissions()` über `permission_handler` (welches ebenfalls deklariert aber **ungenutzt** ist) bekommt die App auf Android 13+ entweder keine Notifications oder — schlimmer — der User merkt nicht, dass die Benachrichtigung über Hintergrundjobs (Scraper-Erfolg/Fehler) stillschweigend ausfällt, was wiederum dazu führen kann, dass fehlgeschlagenes Scrapen wochenlang unentdeckt bleibt.
* **P1 — Die Architektur-Doku lügt über die Permissions.** `docs/ARCHITECTURE_V2.md:283-289` listet `ACCESS_NETWORK_STATE`, `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, `WAKE_LOCK` als „im Manifest angefragt" — das stimmt für `ACCESS_NETWORK_STATE`/`POST_NOTIFICATIONS`/`RECEIVE_BOOT_COMPLETED`/`WAKE_LOCK`/`FOREGROUND_SERVICE` zwar indirekt via `workmanager` und `flutter_local_notifications`, aber `AndroidManifest.xml` selbst (main, debug, profile) deklariert **nur INTERNET**. Die App ist also **nur scheinbar minimal-permissioned**: das merged Manifest zeigt sechs Permissions, die der Code selbst nicht bewusst anfordert. DSGVO Art. 5 (Datenminimierung) verlangt aber eine bewusste Auswahl. **Worst case**: `FOREGROUND_SERVICE` erlaubt der App, im Hintergrund Netzwerk-IO zu machen, ohne dass der User es merkt.
* **P1 — `share_plus`, `permission_handler` und `logger` sind deklarierte Dependencies, aber im gesamten `lib/`-Tree ungenutzt.** Sie mergen trotzdem Komponenten/Code ins APK (siehe `build/share_plus/intermediates/merged_manifest/debug/AndroidManifest.xml`: `ShareFileProvider` + `SharePlusPendingIntent`). Toter Ballast = unnötige Angriffsoberfläche, unnötige Bibliotheksabhängigkeiten.
* **P1 — Keine robots.txt-Prüfung.** Die Architektur-Doku behauptet `Respektiere robots.txt` (`docs/ARCHITECTURE_V2.md:177`), aber `grep -r "robots" lib/` liefert 0 Treffer. Es gibt keinerlei robots.txt-Abruf, keinerlei Caching, keinerlei Verzögerungsanpassung. Verstößt gegen die robots.txt als impliziten Vertrag und kann bei Aldi/Rewe/Lidl zu IP-Blocks führen, was wiederum die Privacy-Masche der App (kein Cloud-Account, lokale Anonymität) untergräbt, weil dann Discounter Anti-Bot-Maßnahmen mit gerätespezifischen Identifiers einsetzen.
* **P1 — Keine Datenschutzerklärung im Repo.** `docs/` enthält **nur** `ARCHITECTURE_V2.md`. Die in `ARCHITECTURE_V2.md:301` versprochene URL `https://volkergrabbe.github.io/kitchen-companion/privacy.html` ist im Projekt nicht verlinkt, nicht abrufbar geprüft (kein `assets/`-Eintrag, kein Onboarding-Screen, kein Settings-Link), und DSGVO Art. 13 verlangt eine **in der App zugängliche** Datenschutzerklärung — nicht eine GitHub-Page, von der der User nichts weiß. Außerdem fehlt jegliche Erwähnung von: Scraping als Datenverarbeitung, Drittparteien (Discounter-Server), API-Key-Speicherung, Hintergrund-Jobs.
* **P1 — `debugPrint` in `background_jobs.dart:44` und `:67` schreibt ungefiltert auf Logcat.** Auch wenn die DB unverschlüsselt ist, sind die Fehlermeldungen selbst nicht kritisch — aber sie belegen, dass die Workmanager-Background-Pfade **keine Sensible-Daten-Filterung** haben. Sobald dort je ein Stacktrace mit PLZ, Medikamentenliste oder API-Key landet, landet er in `logcat`. Auf gerooteten Geräten oder via `bugreport` auslesbar.
* **P2 — User-Agent referenziert eine GitHub-Page, die gleichzeitig als „Kontaktseite" dienen soll** (`discounter_scraper.dart:57` → `volkergrabbe.github.io/kitchen-companion/`). Personenzuordnung über die URL trivial: wer den User-Agent sieht, weiß welcher Maintainer dafür verantwortlich ist. Besser: ohne Maintainer-Identifikation.
* **P2 — Keine Retry-With-Backoff / keine User-Information bei robots.txt-Verstoß.** Selbst wenn robots.txt beachtet würde, gibt es keinen Hinweis an den User, warum bestimmte Discounter dauerhaft leer bleiben. Verstößt gegen das Prinzip der Transparenz.
* **P2 — Kein Export-Feature gefunden → dafür aber auch keine Export-Doku.** `share_plus` ist als Dependency drin, aber kein einziger Import in `lib/`. Wenn jemand v2.1 hinzufügt und die Kontraindikations-Liste exportiert (z.B. als JSON), landet diese auf `Downloads/` oder via Share-Intent bei einer anderen App — ohne Verschlüsselung, ohne User-Warnung. Vorausschauend: in der Doku dokumentieren, **warum** kein Export existieren darf.
* **P2 — PLZ wird ungefragt gespeichert, aber (noch) nicht an Server gesendet** (`settings_screen.dart:62-97`, `database.dart:200`, `impl.dart:402-410`). Aktuell harmlos — aber `MarktguruApi` hat `plz` als Konstruktor-Parameter (Zeile 32) und sobald v2.1 aktiviert wird, geht die PLZ an einen Drittanbieter. **Kein Hinweis im Settings-Screen**, dass die PLZ jemals an Marktguru gesendet werden wird. Aktuell ist die UI irreführend („Postleitzahl für Discounter-Filter" suggeriert lokale Nutzung).
* **P2 — Keine Consent-/Opt-in-Mechanik** für die Discounter-Scraper. Beim ersten App-Start läuft `BackgroundJobs.scheduleWeekly()` (`main.dart:27`) und der Scraper feuert, **ohne dass der User jemals aktiv Discounter aktiviert hat** (alle Discounter werden mit `enabled: true` geseedet, `seed.dart:23-50`). DSGVO-konforme Apps holen für „automatische Datenverarbeitung beim Start" mindestens eine Bestätigung. Hier: stilles Aktivieren beim ersten App-Start.

---

## Detaillierte Findings

### P0-1: Marktguru-API-Key unverschlüsselt in SQLite

**Datei:** `lib/data/database/database.dart:208`
```dart
TextColumn get marktguruApiKey => text().nullable()();
```

**Datei:** `lib/data/repositories/impl.dart:444-452`
```dart
@override
Future<String?> getMarktguruApiKey() async {
  final p = await _db.getUserProfile();
  return p.marktguruApiKey;
}

@override
Future<void> setMarktguruApiKey(String? key) async {
  await _db.updateUserProfile(marktguruApiKey: key);
}
```

**Datei:** `lib/ui/screens/settings_screen.dart:140-170`
```dart
content: TextField(
  controller: controller,
  obscureText: true,  // ← nur in der UI maskiert, NICHT bei der Persistenz
),
```

**Problem:**
- Der API-Key wird im Klartext in `kitchen_companion_v2.sqlite` (siehe `database.dart:430`) abgelegt.
- Die DB liegt in `getApplicationDocumentsDirectory()` — auf einem nicht-gerooteten Gerät vor anderen Apps geschützt, aber:
  1. Bei aktiviertem Auto-Backup (siehe P0-2) im Google Drive Klartext.
  2. Bei aktiviertem USB-Debugging via `adb backup` extrahierbar.
  3. Auf gerooteten Geräten trivial lesbar.
- Die UI-Maskierung (`obscureText: true`) ist Kosmetik — sie schützt nur vor Schulter-Mitlesen, nicht vor Persistenz-Leak.

**Empfehlung (für den Fix-Loop, nicht hier umgesetzt):** `flutter_secure_storage` mit `EncryptedSharedPreferences` (Android Keystore) oder Drift-Encryption-At-Rest via SQLCipher.

---

### P0-2: Android Auto-Backup nicht deaktiviert, kein Backup-Rule

**Datei:** `android/app/src/main/AndroidManifest.xml` (vollständig)
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="kitchen_companion"
        ...>
        <activity ...> ... </activity>
        <meta-data android:name="flutterEmbedding" android:value="2" />
    </application>
    <queries>...</queries>
</manifest>
```

**Beweis-Datei:** `build/app/intermediates/packaged_manifests/debug/AndroidManifest.xml` (Production-Merge)
→ Enthält **kein** Attribut `android:allowBackup=...` und **kein** `android:fullBackupContent=` / `android:dataExtractionRules=`.

**Problem:**
- Android-Default für `android:allowBackup` ist **`true`** (Platform-Verhalten, dokumentiert in https://developer.android.com/guide/topics/data/autobackup).
- Damit wird die gesamte `getApplicationDocumentsDirectory()`-DB (= die `kitchen_companion_v2.sqlite`, die u.a. `UserContraindications`, `marktguruApiKey`, `zipCode`, `food_log`, `recipes` enthält) per Auto-Backup zu Google Drive hochgeladen.
- Auto-Backup ist nach Android-Default **an**, und auf API 23+ ohne Root zugänglich (für Backup-Restore-Szenarien wie neues Gerät).
- Schutzwürdige Daten nach Art. 9 DSGVO (Gesundheitsdaten): `user_contraindications`-Tabelle enthält `contraindication_id` (FK auf vordefinierte Krankheiten/Medikamente) — auch ohne Klarnamen ist das ein Profil.
- `food_log`: Kalorien-/Makro-Tagebuch — Rückschluss auf Gesundheitszustand, Essstörungen.
- `recipes` + `plan_meals`: komplettes Ernährungs-Verhaltensprofil.

**Empfehlung:** Explizit `android:allowBackup="false"` setzen ODER `android:dataExtractionRules="@xml/data_extraction_rules"` mit Ausschluss der DB.

---

### P0-3: POST_NOTIFICATIONS Runtime-Permission nicht angefordert

**Datei:** `lib/background/background_jobs.dart:36-52`
```dart
static Future<void> initialize() async {
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    try {
      await Workmanager().initialize(...);
    } catch (e) {
      debugPrint('Workmanager init fehlgeschlagen: $e');
    }
  }

  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await _notifications.initialize(initSettings);  // ← KEIN requestPermissions()
}
```

**Datei:** `build/flutter_local_notifications/intermediates/merged_manifest/debug/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

**Datei:** `pubspec.yaml:41`
```yaml
permission_handler: ^11.3.1   # ← deklariert, aber NICHT importiert
```

**Problem:**
- `POST_NOTIFICATIONS` ist ab Android 13 (API 33) eine Runtime-Permission, die explizit vom User bestätigt werden muss.
- `flutter_local_notifications` mergt die Permission automatisch ins Manifest, fordert sie aber nicht an.
- Der Code nutzt `permission_handler` als Dependency, importiert es aber **nirgendwo** (`grep -r "package:permission_handler" lib/` = 0 Treffer).
- Auf Android 13+: Notifications werden entweder stillschweigend verworfen (UX-Problem) oder — falls die App ohnehin schon ein Notification-Channel eingerichtet hat und User ablehnt — die App kommuniziert dem User nicht, **dass** die wöchentliche Aktualisierung fehlgeschlagen ist.

**Schweregrad P0, weil:**
- Bei einer Gesundheits-/Kontraindikations-App ist eine verpasste Benachrichtigung über eine fehlgeschlagene Aktualisierung sicherheitsrelevant (Rezepte könnten veraltete Offers nutzen).
- Außerdem ist „Permission im Manifest, aber nicht im UX erklärt" ein klassischer Privacy-Antipattern (User kann nicht ablehnen, was er nicht sieht).

---

### P1-1: Doku lügt über Permissions

**Datei:** `docs/ARCHITECTURE_V2.md:281-289`
```
## Permissions (Android Manifest)
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
```

**Realität in** `android/app/src/main/AndroidManifest.xml`: **nur INTERNET**.

**Realität im merged production manifest** (`build/app/intermediates/packaged_manifests/debug/AndroidManifest.xml`):
- INTERNET (von main)
- VIBRATE (flutter_local_notifications)
- POST_NOTIFICATIONS (flutter_local_notifications)
- WAKE_LOCK (workmanager)
- ACCESS_NETWORK_STATE (workmanager)
- RECEIVE_BOOT_COMPLETED (workmanager)
- **FOREGROUND_SERVICE (workmanager — neu!)**
- **DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION** (signature-protected, workmanager)

**Problem:**
- Architektur-Doku und Quell-Manifest widersprechen sich.
- `FOREGROUND_SERVICE` ist **nicht** in der Doku erwähnt, aber im Build vorhanden. Mit dieser Permission kann die App im Hintergrund Netzwerk-IO machen — Scraper im Hintergrund-Job sind dadurch ohne sichtbare User-Notification möglich.
- DSGVO Art. 5 (Datenminimierung) verlangt eine bewusste, dokumentierte Auswahl. Hier liegt weder ein bewusster Code (manifest ist leer) noch eine korrekte Doku vor.

---

### P1-2: Tote Dependencies mergen Komponenten ins APK

**Datei:** `pubspec.yaml`
```yaml
share_plus: ^10.0.2      # Zeile 42
permission_handler: ^11.3.1  # Zeile 41
logger: ^2.4.0           # Zeile 45
```

**Beweis:** `grep -r "package:share_plus" lib/` → 0 Treffer
**Beweis:** `grep -r "package:permission_handler" lib/` → 0 Treffer
**Beweis:** `grep -r "package:logger" lib/` → 0 Treffer

**Build-Effekt:** `build/share_plus/intermediates/merged_manifest/debug/AndroidManifest.xml` mergt:
```xml
<provider android:name="dev.fluttercommunity.plus.share.ShareFileProvider" .../>
<receiver android:name="dev.fluttercommunity.plus.share.SharePlusPendingIntent" .../>
```

**Problem:**
- Ungenutzte Dependencies erhöhen APK-Größe, Angriffsoberfläche (jede Lib ist eine potenzielle CVE-Quelle) und Audit-Komplexität.
- Für DSGVO-Compliance-Argumentation („unsere App hat keine externen Komponenten, keine Tracker, alles lokal") ist es **kontraproduktiv**, Share-Provider und PendingIntent-Receiver im APK zu haben, wenn der Code sie gar nicht aufruft.

---

### P1-3: robots.txt wird nicht beachtet

**Datei:** `docs/ARCHITECTURE_V2.md:177`
```
- **Respektiere `robots.txt`**: User-Agent setzen, Rate-Limit 1 Request / 3s
```

**Beweis:** `grep -rn "robots" lib/` → 0 Treffer.

**Dateien mit Rate-Limit aber ohne robots.txt-Check:**
- `aldi_scraper.dart:39, 94`: `await Future.delayed(_rateLimit);` (3 Sekunden, aber konstant pro Discounter)
- `lidl_scraper.dart:32`: dito
- `generic_scraper.dart:63`: `await Future.delayed(const Duration(seconds: 3));`

**Problem:**
- Die robots.txt-Behauptung ist Doku-Theater.
- 3 Sekunden pro Discounter ist nicht „konservativ" — Aldi/Rewe haben historisch schon bei 1 Request/Sekunde geblockt.
- Ohne robots.txt-Check kann die App gegen den ausdrücklichen Willen eines Discounters scrapen, was:
  1. rechtliche Konsequenzen hat (UWG, teilweise DSGVO via Personenbezug der Request-Header).
  2. zu IP-Blocks führt, was die User-Privacy untergräbt (Anti-Bot-Maßnahmen tracken oft gerätespezifische Identifier).

---

### P1-4: Keine Datenschutzerklärung im Projekt

**Datei:** `docs/` — enthält nur `ARCHITECTURE_V2.md`.

**Datei:** `lib/main.dart:1-99` — kein Onboarding-Screen, kein Privacy-Linked-Screen.

**Datei:** `pubspec.yaml:55-60` — `assets:` enthält nur Seed-PNGs, keine HTML/Privacy.

**Datei:** `docs/ARCHITECTURE_V2.md:301`
```
- Privacy Policy URL: `https://volkergrabbe.github.io/kitchen-companion/privacy.html`
```

**Problem:**
- DSGVO Art. 13 verlangt eine **leicht zugängliche** Datenschutzerklärung — nicht eine URL in einer Markdown-Datei, die der Enduser nie sieht.
- Die versprochene GitHub-Page ist im Projekt nicht referenziert (kein Deep-Link aus der App).
- Eine Privacy Policy müsste mindestens erwähnen:
  - **Scraping**: Welche Daten werden von Discounter-Servern abgerufen (Angebotsdaten, öffentlich — aber auch implizit: IP, User-Agent, Accept-Language, Zeitstempel werden an Discounter-Server gesendet).
  - **API-Key-Speicherung** (P0-1).
  - **Hintergrund-Jobs** (wann, wie oft, welche Bedingungen).
  - **Auto-Backup-Verhalten** (siehe P0-2).
  - **Drittparteien**: Aldi, Lidl, Rewe, Netto, Penny, Norma, Marktguru.
  - **Verantwortlicher**, Beschwerderecht bei Aufsichtsbehörde, Rechtsgrundlage (Art. 6 Abs. 1 lit. f DSGVO — berechtigtes Interesse).
  - **Speicherdauer** der einzelnen Daten.
  - **Keine Weitergabe an Dritte** außer den Scraping-Zielen.

---

### P1-5: `debugPrint` im Background-Worker

**Datei:** `lib/background/background_jobs.dart:44`
```dart
debugPrint('Workmanager init fehlgeschlagen: $e');
```

**Datei:** `lib/background/background_jobs.dart:67`
```dart
debugPrint('Plan-Schedule fehlgeschlagen: $e');
```

**Problem:**
- `debugPrint` schreibt auf Android-Logcat.
- Logcat ist auf modernen Android-Versionen zwar sandboxed, aber:
  - Auf gerooteten Geräten universal lesbar.
  - Via `adb bugreport` (USB-Debugging) extrahierbar.
  - Wenn die Fehlermeldung `e` jemals einen PLZ-String, API-Key-Fragment oder Contrain-Code enthält → Leak.
- Außerdem: Stacktraces in Logcat können Library-Pfade verraten (Versions-Disclosure → bekannte CVEs).

---

### P2-1: User-Agent enthält Maintainer-Identifikation

**Datei:** `lib/data/sources/scraper/discounter_scraper.dart:55-61`
```dart
return http.get(uri, headers: {
  'User-Agent':
      'KitchenCompanion/2.0 (Local-First App; +https://volkergrabbe.github.io/kitchen-companion/)',
  'Accept': 'text/html,application/xhtml+xml',
  'Accept-Language': 'de-DE,de;q=0.9,en;q=0.8',
  ...?headers,
});
```

**Problem:**
- Die URL identifiziert den Maintainer (volkergrabbe.github.io).
- Discounter-Server können darüber einen App-Vendor profilieren.
- Eine reine `KitchenCompanion/2.0 (contact@example.com)` URL oder gar keine URL wäre neutraler.

---

### P2-2: Keine Consent-Mechanik für Discounter-Aktivierung

**Datei:** `lib/data/database/seed.dart:23-50` — alle 7 Discounter werden mit `enabled: true` geseedet.

**Datei:** `lib/main.dart:25-27`
```dart
await BackgroundJobs.initialize();
await BackgroundJobs.scheduleWeekly();  // ← feuert sofort
```

**Datei:** `lib/data/repositories/offer_repository.dart:25-33`
```dart
final discounters = await (_db.select(_db.discounters)
      ..where((d) => d.enabled.equals(true)))
    .get();
...
for (final d in discounters) { ... scrape ... }
```

**Problem:**
- Beim ersten App-Start sind alle Discounter aktiviert, und der Background-Job feuert ohne expliziten User-Consent.
- DSGVO-konforme Apps holen für „automatische Verarbeitung beim Start" mindestens eine Bestätigung im Onboarding.
- Mindestens sollte der erste Scrape manuell ausgelöst werden.

---

### P2-3: PLZ bereits persistiert, ohne UI-Hinweis auf zukünftige Drittparteien-Nutzung

**Datei:** `lib/ui/screens/settings_screen.dart:62-97`
```dart
// ─── PLZ ───
ListTile(
  leading: const Icon(Icons.location_on),
  title: Text(l10n.settingsZipCode),
  subtitle: Text(zip ?? '–'),
  ...
),
```

**Datei:** `lib/data/sources/api/marktguru_api.dart:32`
```dart
final String? plz;  // ← Konstruktor-Parameter für Marktguru
```

**Problem:**
- PLZ wird aktuell nur lokal gespeichert (siehe P0-2 wegen Backup).
- Sobald `MarktguruApi` aktiviert wird (v2.1), geht die PLZ an einen Drittanbieter — aber im Settings-Screen fehlt jeder Hinweis darauf.
- Die UI-Struktur suggeriert lokale Nutzung („Discounter-Filter"), was die tatsächliche Verwendung verschleiert.

---

### P2-4: Kein Export-Feature → aber auch keine Doku, warum nicht

**Datei:** `pubspec.yaml:42` — `share_plus: ^10.0.2` ist drin, aber unused.

**Datei:** `grep -rn "package:share_plus" lib/` → 0.

**Problem:**
- `share_plus` ist Dependency — entweder toter Ballast (siehe P1-2) oder jemand hat vergessen, den Export zu implementieren.
- Wenn ein Export hinzukommt: Kontraindikations-Liste (Krankheiten/Medikamente) wäre hochsensibel. JSON nach `Downloads/` oder via Share-Intent an WhatsApp wäre ein **DSGVO-Schwerverstoß** (Art. 9 + Art. 32).

---

### P2-5: Kein Retry-With-Backoff / kein User-Feedback bei robots.txt-Konflikt

(Vorausschauend zu P1-3): Selbst wenn robots.txt-Check hinzukommt, muss die UI kommunizieren, **warum** ein bestimmter Discounter dauerhaft keine Angebote zeigt. Sonst tappt der User im Dunkeln.

---

### P2-6: Discounter-Robots-Annahme nicht überprüfbar

(Vorausschauend zu P1-3): Die Doku behauptet „1 Request / 3s" ist „konservativ". Aber:
- Aldi Nord hat historisch schon bei <1 req/s blockiert.
- Rewe hat Anti-Bot-Maßnahmen (Cloudflare) — die App wird dort **immer** geblockt werden ohne offiziellen API-Zugang.
- Die App hat keine Strategie für „dieser Discounter blockiert uns dauerhaft → deaktiviere und informiere User".

---

### P2-7: Kein HTTP-TLS-Pinning / keine Certificate-Validation-Customization

**Datei:** `lib/data/sources/scraper/discounter_scraper.dart:53-62`
```dart
class DefaultHttpClient implements HttpClient {
  @override
  Future<http.Response> get(Uri uri, {Map<String, String>? headers}) {
    return http.get(uri, headers: {...});
  }
}
```

**Problem:**
- Kein Pinning, keine Custom-CA-Blockliste.
- Für eine App, die Nutzerdaten (PLZ, Krankheiten) sendet, ist das Standardverhalten (System Trust Store) okay — aber: auf gerooteten Geräten oder in MITM-Szenarien sind die Scraping-Responses manipulationsanfällig.
- Nicht kritisch, weil Discounter-Pages öffentlich sind — aber „Angebotspreis wird im Wochenplan angezeigt, weil Discounter-Page manipuliert" = finanzieller Schaden für User.

---

## Übersicht — Anzahl Findings

| Schweregrad | Anzahl |
|-------------|--------|
| **P0 (Blocker)** | **3** |
| **P1 (Critical)** | **5** |
| **P2 (Nice-to-fix)** | **7** |
| **Gesamt** | **15** |

---

## Report-Pfad

`/home/administrator/.hermes/workspace/kitchen_companion_v2/kh_reviews/review_01_privacy.md`

---

## Hinweis für Haupt-Hermes

Drei P0-Findings müssen vor Veröffentlichung der App behoben werden:
1. API-Key in `flutter_secure_storage` auslagern.
2. `android:allowBackup="false"` + `dataExtractionRules` setzen.
3. POST_NOTIFICATIONS Runtime-Permission via `permission_handler` anfordern.

Die P1-Findings (Doku-Konsistenz, tote Dependencies, robots.txt, Datenschutzerklärung, Log-Hygiene) sind „uncomfortable truths" für das Marketing-Versprechen „100% lokal, keine Tracker" — müssen vor jedem Play-Store-Submit gelöst werden, sonst hagelt es 1-Sterne-Reviews von datenschutz-affinen Usern und Abmahnungen von Wettbewerbsrechtlern.

Die P2-Findings sind polizeilich-politisch — alles „nice to fix", aber mehrere davon (Export-Doku, Consent-Mechanik, Discounter-Robots-Strategie) sind Vorboten zukünftiger P0s, wenn die App wächst.