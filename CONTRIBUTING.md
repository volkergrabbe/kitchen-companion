# Contributing

## Wie du beitragen kannst

### Bugs melden
- GitHub Issues aufmachen mit:
  - Android-Version
  - Flutter-Version (`flutter --version`)
  - Reproduktionsschritte
  - Erwartetes vs. tatsächliches Verhalten

### Features vorschlagen
- GitHub Discussions nutzen
- Beschreib konkret: Was willst du erreichen, nicht wie

### Code beisteuern
1. Fork machen
2. Branch erstellen (`git checkout -b feat/deine-feature`)
3. Änderungen committen
4. Pull Request aufmachen

---

## Setup für Entwicklung

```bash
# 1. Repo klonen
git clone https://github.com/volkergrabbe/kitchen-companion.git
cd kitchen-companion

# 2. Abhängigkeiten
flutter pub get

# 3. i18n generieren
flutter gen-l10n

# 4. Code generieren (Drift)
dart run build_runner build --delete-conflicting-outputs

# 5. App starten
flutter run
```

### Requirements
- Flutter 3.5+
- Dart 3.5+
- Android SDK (für APK-Build)

---

## Coding Standards

- Dart lints: `flutter analyze`
- Keine brutalen `// ignore:` — wenn was ignoriert werden muss, Dokumentation warum
- Keine hardcodierten Strings — i18n nutzen

---

## Commit-Messages

Format: `type: description`

Types:
- `feat:` Neue Feature
- `fix:` Bugfix
- `docs:` Nur Dokumentation
- `refactor:` Code-Umstrukturierung ohne Verhaltensänderung
- `chore:` Wartung, Dependencies

Beispiel: `feat: add calorie validation to recipe input`