# Forgejo Sync — KitchenCompanion

## Status: ✅ Code bereit, Sync ausstehend

## Was getan wurde

- APK erfolgreich gebaut: `build/app/outputs/flutter-apk/app-debug.apk` (88MB)
- Git-Repo initialisiert mit Commit `4156af9`
- Branch: `main`

## Forgejo-Zugang

```
URL:      https://192.168.178.51:3000/volker/kitchen-companion
SSH:      git@192.168.178.51:222/volker/kitchen-companion.git
HTTP:     https://192.168.178.51:3000/volker/kitchen-companion.git
Token:    [REDACTED]
```

## Sync-Befehle (auf ThinkStation ausführen)

```bash
# 1. Repo auf Forgejo erstellen falls nicht vorhanden
# Über Web-UI: https://192.168.178.51:3000 → New Repository → "kitchen-companion"

# 2. Clone/Add remote
cd kitchen_companion
git remote add origin https://volker:[TOKEN]@192.168.178.51:3000/volker/kitchen-companion.git

# 3. Push
git branch -M main
git push -u origin main --force  # --force wegen erstem Push
```

## Problem: TLS/SSH

Von diesem System (192.168.178.3) ist der direkte Zugang zu Forgejo (192.168.178.51) nicht möglich:
- HTTPS: `gnutls_handshake() failed: An unexpected TLS packet was received`
- SSH Port 222: `Connection refused`

**Lösung:** Auf ThinkStation pushen, da dort die Netzwerk-Route funktioniert.

## Alternativ: GitHub MCP Sync

LXC 124 (git-tools) hat Zugang zu GitHub. Alternativ könnte das Projekt über GitHub synchronisiert werden.