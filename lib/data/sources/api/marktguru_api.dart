// lib/data/sources/api/marktguru_api.dart
//
// ─────────────────────────────────────────────────────────────────────
// MARK TGURU API — v1.1 / v2.1 Hook
// ─────────────────────────────────────────────────────────────────────
//
// v2.0.0 AUSKOMMENTIERT.
//
// Aktivierung:
//   1. Account auf marktguru.de anlegen (Affiliate-Partnerprogramm
//      oder B2B-API-Zugang).
//   2. API-Key in den Settings eingeben (lokal in DB gespeichert,
//      kein Cloud-Storage).
//   3. Feature-Flag `marktguru_enabled` in DB auf true setzen.
//   4. Diese Klasse aktivieren (Kommentare entfernen) + implementieren.
//
// Lizenz-Hinweis: Marktguru erlaubt API-Nutzung nur unter Einhaltung
// der AGB. Web-Scraping ist NICHT erlaubt — nur offizieller API-Endpunkt.
//
// Kontakt: https://www.marktguru.de/

import '../scraper/discounter_scraper.dart';

class MarktguruApi extends DiscounterScraper {
  @override
  String get displayName => 'Marktguru (API)';

  // Suppress unused_field — wird bei Aktivierung benötigt
  // ignore: unused_field
  final String? apiKey;
  // ignore: unused_field
  final String? plz;

  MarktguruApi({this.apiKey, this.plz});

  // Suppress unused_field — wird bei Aktivierung benötigt
  // ignore: unused_field
  static const _baseUrl = 'https://api.marktguru.de/v1';

  @override
  Future<List<ScrapedOffer>> scrape() async {
    // TODO(v2.1): echte API-Anbindung implementieren — siehe Kommentare oben.
    throw UnimplementedError(
        'Marktguru-API noch nicht implementiert. '
        'Siehe Kommentare in marktguru_api.dart für Aktivierung.');
  }
}

/// Feature-Flag-Check: ist Marktguru verfügbar?
bool marktguruConfigured({required bool enabled, required String? apiKey}) {
  return enabled && (apiKey?.isNotEmpty ?? false);
}

/// Hilfsfunktion für die UI: zeigt den Hinweistext im Settings-Screen.
String marktguruSetupHint() {
  return 'Marktguru-API (v1.1): Account auf marktguru.de erforderlich. '
      'API-Key wird NUR lokal auf deinem Gerät gespeichert. '
      'Diese Funktion ist optional und ersetzt den Web-Scraper nicht.';
}