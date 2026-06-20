# Known Issues

Offene Punkte für Kitchen Companion — Stand 19.06.2026.

---

## 🔴 GitHub-Token fehlt (Build-Status)

**Problem:** Der in `.git/config` hinterlegte GitHub-Token
(`ghp_p8...JJlL`) ist eine **Memory-Maske**, kein gültiger Token.

```bash
# Aktueller Stand:
$ git remote -v
github  https://github.com/volkergrabbe/kitchen-companion.git (push)
origin  http://volker:***@192.168.178.51:3000/volker/kitchen-companion.git (push)

# Forgejo: ✅ gepushed
# GitHub:  ❌ Token ungültig (Bad credentials)
```

**Lösung:**
1. Echten GitHub-PAT (Personal Access Token) unter
   https://github.com/settings/tokens generieren mit Scope `repo`.
2. Token in `~/.netrc` eintragen:
   ```
   machine github.com login volkergrabbe password <ECHTES_TOKEN>
   ```
3. Oder Remote-URL direkt mit Token:
   ```bash
   git remote set-url github https://volkergrabbe:<TOKEN>@github.com/volkergrabbe/kitchen-companion.git
   ```
4. `git push github main`

---

## 🟡 Outdated Dependencies

`flutter pub outdated` zeigt neuere Versionen, die durch
`environment.sdk: ^3.5.0` (Dart 3.5.0) geblockt sind.

| Package | Current | Latest | Blocker |
|---|---|---|---|
| drift | 2.23.1 | 2.34.0 | SDK-Constraint |
| drift_dev | 2.23.1 | 2.34.0 | SDK-Constraint |
| sqlite3_flutter_libs | 0.5.42 | 0.6.0+eol | EOL — Upgrade sinnvoll |
| intl | 0.19.0 | 0.20.2 | SDK-Constraint |
| flutter_lints | 4.0.0 | 6.0.0 | Major-Sprung |

**Aktion erforderlich:** Dart-SDK auf 3.6+ oder 3.7+ für aktuelle
drift-Versionen. Flutter 3.24.0 hat Dart 3.5 — ein Flutter-Upgrade
auf 3.27+ würde mehrere Issues auf einmal lösen.

---

## 🟢 Behoben (Stand 19.06.2026)

- ✅ **widget_test.dart Boilerplate entfernt**: Echte Smoke-Tests
  für `KitchenCompanionApp` (NavigationBar wird gerendert).
- ✅ **Tests laufen wieder**: `libsqlite3.so` Symlink in
  `~/.local/lib/` + `LD_LIBRARY_PATH` für Test-Run.
- ✅ **`use_super_parameters` Lint**: `AppDatabase.forTesting(QueryExecutor e)`
  → `AppDatabase.forTesting(super.e)`.
- ✅ **Tests: 28/28 grün** (vorher 3/30).

---

## 🟠 Offene Features (aus CHANGELOG 1.0.0)

- Rezept-Detailansicht (Tapping auf Rezept öffnet aktuell nichts)
- Suchfunktion für Rezepte
- Mahlzeiten-Erfassung im Ernährungstagebuch
- Kalorien-Validierung im Input (akzeptiert aktuell alle Werte)