# OpenClaw clean install met lokale Ollama

Deze repo bevat nu een herhaalbare setup voor een lokale OpenClaw-installatie zonder cloudmodel.

## Keuzes

- **Model:** `qwen2.5:3b`
- **Ollama endpoint:** `http://127.0.0.1:11434`
- **OpenClaw workspace:** `/workspace`
- **Gateway poort:** `18789`

## Eenmalige installatie

Voer uit:

```bash
./scripts/install-openclaw-local-ollama.sh
```

Wat dit script doet:

1. installeert `zstd` als Ollama-dependency
2. installeert de nieuwste `openclaw` CLI
3. installeert `ollama`
4. start `ollama serve` als die nog niet draait
5. downloadt `qwen2.5:3b`
6. schrijft een schone `~/.openclaw/openclaw.json`
7. valideert de OpenClaw-config

## Starten

Voer uit:

```bash
./scripts/start-openclaw-local.sh
```

Dat script:

- start Ollama indien nodig
- start daarna `openclaw gateway --force`

## Wat er bewust niet gebeurt

- geen cloud-provider
- geen fallback naar betaalde modellen
- geen zwaar standaardmodel van de onboarding wizard

## Handige checks

```bash
ollama list
openclaw models status --plain
openclaw config validate
```

De actieve OpenClaw-config staat op:

```bash
~/.openclaw/openclaw.json
```
