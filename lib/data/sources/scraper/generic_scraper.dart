// lib/data/sources/scraper/generic_scraper.dart
//
// Generische Implementierung für Rewe/Netto/Penny/Norma.
// Diese vier Discounter haben unterschiedliche Seitenstrukturen —
// hier eine generische Heuristik, die in der Praxis wahrscheinlich
// nicht jede Seite trifft. Wird im KH-Review auf Robustheit geprüft.

import 'dart:async';

import 'discounter_scraper.dart';

class ReweScraper extends DiscounterScraper {
  @override
  String get displayName => 'Rewe';
  static const _url = 'https://www.rewe.de/angebote/';

  @override
  Future<List<ScrapedOffer>> scrape() {
    return _genericScrape(_url);
  }
}

class NettoScraper extends DiscounterScraper {
  @override
  String get displayName => 'Netto';
  static const _url = 'https://www.netto-online.de/angebote/';

  @override
  Future<List<ScrapedOffer>> scrape() {
    return _genericScrape(_url);
  }
}

class PennyScraper extends DiscounterScraper {
  @override
  String get displayName => 'Penny';
  static const _url = 'https://www.penny.de/angebote/';

  @override
  Future<List<ScrapedOffer>> scrape() {
    return _genericScrape(_url);
  }
}

class NormaScraper extends DiscounterScraper {
  @override
  String get displayName => 'Norma';
  static const _url = 'https://www.norma-online.de/angebote/';

  @override
  Future<List<ScrapedOffer>> scrape() {
    return _genericScrape(_url);
  }
}

Future<List<ScrapedOffer>> _genericScrape(String url) async {
  final c = DefaultHttpClient();
  try {
    final response = await c.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw ScraperException('HTTP ${response.statusCode}', url: url);
    }
    await Future.delayed(const Duration(seconds: 3));

    final names = extractAll(response.body,
        '[class*="product" i] [class*="title" i], [class*="title" i][class*="product" i]');
    final prices = extractAll(response.body,
        '[class*="product" i] [class*="price" i], [class*="price" i][class*="product" i]');

    final offers = <ScrapedOffer>[];
    final count = names.length < prices.length ? names.length : prices.length;
    for (var i = 0; i < count; i++) {
      final priceStr = prices[i]
          .replaceAll('€', '')
          .replaceAll(',', '.')
          .replaceAll(RegExp(r'[^0-9\.]'), '')
          .trim();
      final price = double.tryParse(priceStr);
      if (price == null || price <= 0) continue;
      offers.add(ScrapedOffer(
        rawName: names[i],
        price: price,
        sourceUrl: url,
      ));
    }
    // P3 (GLM-5.2 Runde 2): Validierung gegen leere Resultate
    // (Strukturänderungs-Detection). Hier ad-hoc, da die generic-
    // Scraper kein einheitliches DiscounterScraper-Interface teilen.
    if (offers.isEmpty) {
      throw ScraperParseException(
        displayName: 'GenericScraper',
        sourceUrl: url,
        reason: '0 Angebote geparst — HTML-Struktur vermutlich geändert',
      );
    }
    return offers;
  } on ScraperException {
    rethrow;
  } catch (e) {
    throw ScraperException('Generic scrape $url fehlgeschlagen: $e');
  }
}