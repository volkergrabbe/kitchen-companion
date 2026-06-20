// lib/data/sources/scraper/aldi_scraper.dart
//
// Aldi Nord + Aldi Süd Scraper.
// Wichtig: aktuelle HTML-Struktur regelmäßig prüfen — Discounter ändern Layouts.
// Hier bewusst defensiv geschrieben: bei Fehler → leere Liste, App stürzt nicht.

import 'dart:async';

import 'discounter_scraper.dart';

class AldiNordScraper extends DiscounterScraper {
  @override
  String get displayName => 'Aldi Nord';

  final HttpClient _client;
  final Duration _rateLimit;

  AldiNordScraper({HttpClient? client, Duration? rateLimit})
      : _client = client ?? DefaultHttpClient(),
        _rateLimit = rateLimit ?? const Duration(seconds: 3);

  static const _startUrl = 'https://www.aldi-nord.de/angebote.html';

  @override
  Future<List<ScrapedOffer>> scrape() async {
    try {
      final response =
          await _client.get(Uri.parse(_startUrl));
      if (response.statusCode != 200) {
        throw ScraperException(
          'HTTP ${response.statusCode}',
          url: _startUrl,
        );
      }
      // Aldi Nord hat ein komplexes JS-Frontend — die hier gelisteten
      // Selektoren funktionieren NUR, wenn die Seite server-rendered ist
      // (also vor dem JS-Hydration). Falls nicht, gehen wir leer aus.
      // P3 (GLM-5.2 Runde 2): Leere Resultate werfen jetzt
      // ScraperParseException statt still zu schweigen.
      await Future.delayed(_rateLimit); // Rate-Limit
      final offers = _parseOffers(response.body);
      validate(offers, sourceUrl: _startUrl);
      return offers;
    } on ScraperException {
      rethrow;
    } catch (e) {
      throw ScraperException('Aldi Nord Scrape fehlgeschlagen: $e');
    }
  }

  List<ScrapedOffer> _parseOffers(String html) {
    final names = extractAll(html, '.product-title, h3.product__title');
    final prices = extractAll(html, '.product-price, .price');

    final offers = <ScrapedOffer>[];
    final count = names.length < prices.length ? names.length : prices.length;
    for (var i = 0; i < count; i++) {
      final name = names[i];
      final priceStr = prices[i]
          .replaceAll('€', '')
          .replaceAll(',', '.')
          .replaceAll(RegExp(r'[^0-9\.]'), '')
          .trim();
      final price = double.tryParse(priceStr);
      if (price == null || price <= 0) continue;
      offers.add(ScrapedOffer(
        rawName: name,
        price: price,
        unitText: null,
        sourceUrl: _startUrl,
      ));
    }
    return offers;
  }
}

class AldiSuedScraper extends DiscounterScraper {
  @override
  String get displayName => 'Aldi Süd';

  final HttpClient _client;
  final Duration _rateLimit;

  AldiSuedScraper({HttpClient? client, Duration? rateLimit})
      : _client = client ?? DefaultHttpClient(),
        _rateLimit = rateLimit ?? const Duration(seconds: 3);

  static const _startUrl = 'https://www.aldi-sued.de/angebote.html';

  @override
  Future<List<ScrapedOffer>> scrape() async {
    try {
      final response = await _client.get(Uri.parse(_startUrl));
      if (response.statusCode != 200) {
        throw ScraperException('HTTP ${response.statusCode}', url: _startUrl);
      }
      await Future.delayed(_rateLimit);
      final offers = _parseOffers(response.body);
      // P3 (GLM-5.2 Runde 2): Validierung gegen leere Resultate
      // (Strukturänderungs-Detection).
      validate(offers, sourceUrl: _startUrl);
      return offers;
    } on ScraperException {
      rethrow;
    } catch (e) {
      throw ScraperException('Aldi Süd Scrape fehlgeschlagen: $e');
    }
  }

  List<ScrapedOffer> _parseOffers(String html) {
    final names = extractAll(html, '.product-title, .product__title');
    final prices = extractAll(html, '.product-price, .price');

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