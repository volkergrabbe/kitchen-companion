// lib/data/repositories/offer_repository.dart
//
// Verwaltet Angebote + mappt Discounter-Roh-Namen auf Ingredients.

import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';

import '../database/database.dart';
import '../sources/scraper/discounter_scraper.dart';
import '../sources/scraper/scraper_registry.dart';

class OfferRepository {
  final AppDatabase _db;
  final HttpClient _http;

  OfferRepository(this._db, {HttpClient? http}) : _http = http ?? DefaultHttpClient();

  /// Scrapt alle aktivierten Discounter, mappt auf Ingredients, persistiert.
  /// Returns: Anzahl neu gespeicherter Angebote pro Discounter.
  Future<Map<String, int>> refreshAllOffers({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final discounters = await (_db.select(_db.discounters)
          ..where((d) => d.enabled.equals(true)))
        .get();

    final results = <String, int>{};

    // Sequentiell (nicht parallel) — Discounter-Websites mögen
    // kein gleichzeitiges Crawling von derselben IP.
    for (final d in discounters) {
      if (d.scraperClass == 'MarktguruApi') continue; // v1.1 Hook

      try {
        final scraper = ScraperRegistry.forClass(d.scraperClass, client: _http);
        final scraped = await scraper.scrape().timeout(timeout);

        int saved = 0;
        for (final offer in scraped) {
          final ingredient = await _matchIngredient(offer.rawName);
          await _db.addOffer(OffersCompanion.insert(
            discounterId: d.id,
            ingredientId: Value(ingredient?.id),
            rawName: offer.rawName,
            price: offer.price,
            unitText: Value(offer.unitText),
            validFrom: DateTime.now(),
            validTo: DateTime.now().add(const Duration(days: 7)),
            fetchedAt: DateTime.now(),
            sourceUrl: Value(offer.sourceUrl),
          ));
          saved++;
        }
        results[d.name] = saved;
      } catch (e) {
        results[d.name] = -1; // -1 = Fehler
      }
    }

    // Alte Angebote aufräumen
    await _db.clearOldOffers(DateTime.now());

    return results;
  }

  /// Mappt einen Roh-Namen aus dem Scraping auf eine Ingredient.
  /// Heuristik: substring-match (lowercase, ohne Sonderzeichen).
  /// Bei Match → Ingredient, sonst null (bleibt „unzugeordnet").
  Future<Ingredient?> _matchIngredient(String rawName) async {
    final normalized = _normalize(rawName);
    if (normalized.isEmpty) return null;

    final allIngredients = await _db.select(_db.ingredients).get();
    for (final ing in allIngredients) {
      if (normalized.contains(_normalize(ing.name))) {
        return ing;
      }
    }
    return null;
  }

  String _normalize(String s) =>
      s.toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9äöüß]'), '')
          .trim();

  /// Aktive Offers filtern + Score für Wochenplan-Engine.
  Future<List<Offer>> activeOffers() async {
    return (_db.select(_db.offers)
          ..where((o) => o.validTo.isBiggerThanValue(DateTime.now())))
        .get();
  }

  /// Offers als JSON-String (für Logging/Debug).
  String encodeOffers(List<Offer> offers) {
    return jsonEncode(offers
        .map((o) => {
              'id': o.id,
              'ingredient': o.ingredientId,
              'name': o.rawName,
              'price': o.price,
              'valid_to': o.validTo.toIso8601String(),
            })
        .toList());
  }
}