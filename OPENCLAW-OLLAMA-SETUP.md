# OpenClaw + lokale Ollama – setup

Clean install voltooid. OpenClaw gebruikt nu **lokale Ollama** met `llama3.2:3b`.

## Wat is geïnstalleerd

- **Ollama** – draait op `http://127.0.0.1:11434`
- **OpenClaw** – v2026.3.13, geconfigureerd voor Ollama
- **Model** – `llama3.2:3b` (2 GB)

## Configuratie

- **Workspace:** `/workspace` (dit project)
- **Model:** `ollama/llama3.2:3b`
- **Config:** `~/.openclaw/openclaw.json`

## Starten

### 1. Ollama (als die nog niet draait)

```bash
ollama serve &
ollama pull llama3.2:3b   # alleen nodig bij eerste keer
```

### 2. OpenClaw Gateway

```bash
openclaw gateway run
```

Of in de achtergrond:

```bash
openclaw gateway run &
```

### 3. Optioneel: OLLAMA_API_KEY

Als je `OLLAMA_API_KEY` wilt zetten (voor auto-discovery):

```bash
export OLLAMA_API_KEY="ollama-local"
```

## Testen

```bash
# Modellen bekijken
openclaw models list

# Agent een bericht sturen (gateway moet draaien)
openclaw agent --to +31612345678 --message "Hoi" --deliver
```

## Andere modellen

```bash
ollama pull qwen2.5:7b
openclaw models set ollama/qwen2.5:7b
```

## Troubleshooting

- **Gateway niet bereikbaar:** Start `openclaw gateway run`
- **Ollama niet bereikbaar:** Start `ollama serve`
- **Geen modellen:** Run `ollama list` en `ollama pull <model>`
