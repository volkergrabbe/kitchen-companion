// lib/data/sources/scraper/scraper_registry.dart
//
// Registry: mappt DB-Discounter → Scraper-Instanz.

import 'discounter_scraper.dart';
import 'aldi_scraper.dart';
import 'lidl_scraper.dart';
import 'generic_scraper.dart';

class ScraperRegistry {
  static DiscounterScraper forClass(String scraperClass, {HttpClient? client}) {
    switch (scraperClass) {
      case 'AldiNordScraper':
        return AldiNordScraper(client: client);
      case 'AldiSuedScraper':
        return AldiSuedScraper(client: client);
      case 'LidlScraper':
        return LidlScraper(client: client);
      case 'ReweScraper':
        return ReweScraper();
      case 'NettoScraper':
        return NettoScraper();
      case 'PennyScraper':
        return PennyScraper();
      case 'NormaScraper':
        return NormaScraper();
      case 'MarktguruApi':
        throw ScraperException(
            'MarktguruAPI nicht direkt instanziierbar — '
            'siehe lib/data/sources/api/marktguru_api.dart für Aktivierung.');
      default:
        throw ScraperException(
            'Unbekannte Scraper-Klasse: $scraperClass');
    }
  }
}