// lib/data/secure_storage_service.dart
//
// P0-1 (Privacy Review): Sicherer Storage für Secrets.
//
// Speichert den Marktguru-API-Key in flutter_secure_storage.
// Auf Android wird EncryptedSharedPreferences genutzt (AES-GCM,
// Schlüssel im Android Keystore). Damit liegt der Key NICHT in der
// unverschlüsselten SQLite-DB, NICHT in Auto-Backup, NICHT in
// getApplicationDocumentsDirectory().
//
// Andere Apps (auch mit Root) kommen nicht ohne Weiteres an die Daten,
// weil der Keystore-Zugriff an die App-Signatur gebunden ist.
//
// P0-2 (Privacy Review): Auch wenn die DB lokal gestohlen würde,
// findet sich dort kein Marktguru-Key mehr.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Singleton — eine Instanz pro App-Lifetime, damit der
  // Plattform-Channel nur einmal initialisiert wird.
  static final SecureStorageService _instance = SecureStorageService._();
  factory SecureStorageService() => _instance;
  SecureStorageService._();

  static const _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
    // resetOnError: Wenn der Keystore beschädigt wird (z.B. nach
    // einem App-Reinstall auf Custom-ROM), wirft der Lese-Versuch
    // eine Exception. Mit resetOnError=true wird der Eintrag
    // gelöscht, damit die App nicht in einer Crash-Loop landet.
    resetOnError: true,
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: _androidOptions,
  );

  // ─────────────────────────────────────────────
  // Marktguru API-Key
  // ─────────────────────────────────────────────

  static const _kMarktguruApiKey = 'marktguru_api_key';

  Future<String?> getMarktguruApiKey() {
    return _storage.read(key: _kMarktguruApiKey);
  }

  Future<void> setMarktguruApiKey(String? key) async {
    if (key == null || key.isEmpty) {
      await _storage.delete(key: _kMarktguruApiKey);
    } else {
      await _storage.write(key: _kMarktguruApiKey, value: key);
    }
  }
}
