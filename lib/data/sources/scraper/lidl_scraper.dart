// lib/data/sources/scraper/lidl_scraper.dart
//
// Lidl Scraper — Lidl hat teilweise server-rendered HTML-Angebote,
// größtenteils aber client-side React.
// Diese Implementierung versucht den Standard-Wochenprospekt-PDF-Pfad.

import 'dart:async';

import 'discounter_scraper.dart';

class LidlScraper extends DiscounterScraper {
  @override
  String get displayName => 'Lidl';

  final HttpClient _client;
  final Duration _rateLimit;

  LidlScraper({HttpClient? client, Duration? rateLimit})
      : _client = client ?? DefaultHttpClient(),
        _rateLimit = rateLimit ?? const Duration(seconds: 3);

  // Lidl-Sortiment-Woche — server-rendered ist hier am stabilsten.
  static const _startUrl = 'https://www.lidl.de/';

  @override
  Future<List<ScrapedOffer>> scrape() async {
    try {
      final response = await _client.get(Uri.parse(_startUrl));
      if (response.statusCode != 200) {
        throw ScraperException('HTTP ${response.statusCode}', url: _startUrl);
      }
      await Future.delayed(_rateLimit);
      final offers = _parseOffers(response.body);
      // P3 (GLM-5.2 Runde 2): Validierung gegen leere Resultate.
      validate(offers, sourceUrl: _startUrl);
      return offers;
    } on ScraperException {
      rethrow;
    } catch (e) {
      throw ScraperException('Lidl Scrape fehlgeschlagen: $e');
    }
  }

  List<ScrapedOffer> _parseOffers(String html) {
    final names = extractAll(html, '.product-grid__item .product__title, .product-title');
    final prices = extractAll(html, '.price__main, .product-price__main');

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
        sourceUrl: _startUrl,
      ));
    }
    return offers;
  }
}