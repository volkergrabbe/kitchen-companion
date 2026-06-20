// lib/data/sources/scraper/discounter_scraper.dart
//
// Interface + Result für Discounter-Scraper.
// Jeder Discounter hat eine eigene Implementierung.
//
// P3 (GLM-5.2 Runde 2): Timeout + Retry + Exponential-Backoff in
// [DefaultHttpClient], sowie eine [DiscounterScraper.validate]-Methode,
// die das "leise Schweigen" bei Strukturänderungen der HTML-Seiten
// verhindert.

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

class ScrapedOffer {
  final String rawName;
  final double price;
  final String? unitText;
  final String? sourceUrl;

  ScrapedOffer({
    required this.rawName,
    required this.price,
    this.unitText,
    this.sourceUrl,
  });

  @override
  String toString() =>
      'ScrapedOffer($rawName, ${price.toStringAsFixed(2)}€, $unitText)';
}

/// Basis-Interface für Discounter-Scraper.
///
/// Implementierungen sind:
/// - [AldiNordScraper]
/// - [AldiSuedScraper]
/// - [LidlScraper]
/// - [ReweScraper]
/// - [NettoScraper]
/// - [PennyScraper]
/// - [NormaScraper]
/// - [MarktguruApi] (v1.1, derzeit Hook)
abstract class DiscounterScraper {
  /// Anzeigename des Discounters (muss zum DB-Eintrag passen)
  String get displayName;

  /// Scraped aktuelle Angebote. Sollte rate-limit-respektierend sein.
  /// Throws [ScraperException] bei HTTP-/Netzwerkfehlern.
  /// Throws [ScraperParseException] bei leerem Ergebnis (Strukturänderung).
  Future<List<ScrapedOffer>> scrape();

  /// P3 (GLM-5.2 Runde 2): Validiert das Parse-Ergebnis. Default-Implementation
  /// wirft [ScraperParseException], wenn [offers] leer ist. Sub-Scraper
  /// können das überschreiben, um zusätzliche Checks zu machen
  /// (z.B. Mindest-Preis-Sanity-Check).
  void validate(List<ScrapedOffer> offers, {String? sourceUrl}) {
    if (offers.isEmpty) {
      throw ScraperParseException(
        displayName: displayName,
        sourceUrl: sourceUrl,
        reason: '0 Angebote geparst — HTML-Struktur vermutlich geändert',
      );
    }
  }
}

/// Standard-HTTP-Client für alle Scraper (kann gemockt werden).
///
/// P3 (GLM-5.2 Runde 2): Erweitert um:
/// - 15s-Timeout pro Request (statt Default 60s)
/// - Max 2 Retries (also 3 Versuche total) mit Exponential-Backoff (2s, 4s)
/// - Bei finalem Fehler: [ScraperException] (statt roher TimeoutException)
abstract class HttpClient {
  Future<http.Response> get(Uri uri, {Map<String, String>? headers});
}

class DefaultHttpClient implements HttpClient {
  /// Timeout pro Request (P3: 15s statt 60s).
  final Duration timeout;

  /// Anzahl Retries NACH dem ersten Versuch (P3: 2 → also max 3 Versuche).
  final int maxRetries;

  /// Initialer Backoff (P3: 2s). Verdoppelt sich pro Retry (2s, 4s).
  final Duration initialBackoff;

  /// Internes [http.Client] — überschreibbar für Tests.
  final http.Client _httpClient;

  DefaultHttpClient({
    this.timeout = const Duration(seconds: 15),
    this.maxRetries = 2,
    this.initialBackoff = const Duration(seconds: 2),
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  @override
  Future<http.Response> get(Uri uri, {Map<String, String>? headers}) async {
    // QW1 (Privacy Review): User-Agent enthält absichtlich KEINE
    // Maintainer-Identifikation (keine persönliche URL, keine E-Mail,
    // kein GitHub-Handle). Discounter-Server-Logs enthalten so nur
    // die App-Identität. Kontakt für Abuse-Meldungen läuft über die
    // Datenschutzerklärung (in der App unter Einstellungen), nicht
    // über den User-Agent.
    final requestHeaders = <String, String>{
      'User-Agent':
          'KitchenCompanion/2.0 (Local-First Android-App; kein Tracking)',
      'Accept': 'text/html,application/xhtml+xml',
      'Accept-Language': 'de-DE,de;q=0.9,en;q=0.8',
      ...?headers,
    };

    int? lastStatusCode;

    for (var attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final response = await _httpClient
            .get(uri, headers: requestHeaders)
            .timeout(timeout);

        // 5xx → retry-fähig
        if (response.statusCode >= 500 && attempt < maxRetries) {
          lastStatusCode = response.statusCode;
          await _sleepBackoff(attempt);
          continue;
        }

        return response;
      } on TimeoutException catch (_) {
        if (kDebugMode) {
          developer.log(
            'Timeout attempt ${attempt + 1}/${maxRetries + 1} für $uri',
            name: 'scraper.http',
          );
        }
        if (attempt >= maxRetries) rethrow;
        await _sleepBackoff(attempt);
      } on io.SocketException catch (e) {
        // Netzwerk-Down / DNS-Fehler / Verbindungsabbruch → retry-fähig.
        if (kDebugMode) {
          developer.log(
            'SocketException attempt ${attempt + 1}/${maxRetries + 1} für $uri: $e',
            name: 'scraper.http',
          );
        }
        if (attempt >= maxRetries) rethrow;
        await _sleepBackoff(attempt);
      }
    }

    // Hier kommen wir nur hin, wenn alle Retries einen 5xx-Status brachten.
    throw ScraperException(
      'HTTP ${lastStatusCode ?? "?"} nach ${maxRetries + 1} Versuchen',
      url: uri.toString(),
    );
  }

  Future<void> _sleepBackoff(int attempt) {
    // attempt=0 → initialBackoff; attempt=1 → initialBackoff*2; etc.
    final multiplier = 1 << attempt; // 1, 2, 4, …
    return Future.delayed(initialBackoff * multiplier);
  }

  /// Schließt das interne [http.Client]. Nach dem Aufruf dürfen keine
  /// weiteren Requests mehr gemacht werden.
  void close() => _httpClient.close();
}

/// Allgemeiner Scraper-Fehler (HTTP, Netzwerk, Parse).
class ScraperException implements Exception {
  final String message;
  final String? url;
  final String? scraperName;
  ScraperException(this.message, {this.url, this.scraperName});

  @override
  String toString() =>
      'ScraperException(${scraperName ?? 'scraper'}): $message';
}

/// P3 (GLM-5.2 Runde 2): Spezifischer Fehler, wenn ein Scraper
/// zwar technisch HTTP 200 bekommt, aber 0 (oder eine unplausible Anzahl)
/// Offers parsen kann. Klassischer Hinweis auf HTML-Strukturänderung
/// beim Discounter.
class ScraperParseException extends ScraperException {
  final String reason;
  ScraperParseException({
    required this.reason,
    String? sourceUrl,
    String? displayName,
  }) : super(
          'Parse-Validierung fehlgeschlagen: $reason',
          url: sourceUrl,
          scraperName: displayName,
        );
}

/// Hilfsfunktion: HTML parsen und Selector anwenden.
List<String> extractAll(String html, String selector) {
  final doc = html_parser.parse(html);
  return doc.querySelectorAll(selector).map((e) => e.text.trim()).toList();
}