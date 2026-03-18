# OpenClaw clean install met lokale Ollama

Dit project bevat nu een één-klik script voor een schone OpenClaw-installatie die **altijd lokale Ollama** gebruikt (native API, dus **zonder** `/v1`).

## Script

```bash
./scripts/openclaw-clean-install-local-ollama.sh
```

Optioneel kun je een ander model meegeven:

```bash
./scripts/openclaw-clean-install-local-ollama.sh qwen2.5:0.5b
```

## Wat het script doet

1. Installeert/updated `openclaw` (`npm -g`)
2. Installeert/updated `ollama`
3. Start Ollama lokaal op `http://127.0.0.1:11434`
4. Backup van bestaande `~/.openclaw` state naar `~/.openclaw.backup-<timestamp>`
5. Draait non-interactive onboarding voor OpenClaw
6. Forceert provider config:
   - `models.providers.ollama.baseUrl = http://127.0.0.1:11434`
   - `models.providers.ollama.api = ollama`
   - `models.providers.ollama.apiKey = OLLAMA_API_KEY`
7. Pullt het opgegeven model en zet dit als default
8. Start de gateway
9. Draait validatie + smoke test

## Belangrijk

- OpenClaw + Ollama hoort op de **native Ollama API** te draaien (`http://127.0.0.1:11434`) voor betrouwbare tool-calling.
- Gebruik **geen** `/v1` URL als je native Ollama behavior wilt houden.
