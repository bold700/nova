# Telegram + ChatGPT bot

Kleine bot: berichten van Telegram gaan naar de **OpenAI ChatGPT API** en het antwoord gaat terug naar Telegram. Geen OpenClaw.

## Setup

1. **Telegram-bottoken**  
   Zelfde token als je huidige bot mag, maar dan moet de OpenClaw-gateway **uit** staan (anders krijgt alleen één proces de updates). Of maak een tweede bot via [@BotFather](https://t.me/BotFather) en gebruik die token hier.

2. **OpenAI API-key**  
   [platform.openai.com](https://platform.openai.com) → API keys → Create new secret key.

3. **Configuratie**

   ```bash
   cd telegram-chatgpt-bot
   cp .env.example .env
   # Bewerk .env: vul TELEGRAM_BOT_TOKEN en OPENAI_API_KEY in
   npm install
   npm start
   ```

4. Stuur een bericht naar je bot in Telegram; je krijgt een antwoord van ChatGPT.

## Variabelen (.env)

| Variabele | Verplicht | Beschrijving |
|-----------|-----------|--------------|
| `TELEGRAM_BOT_TOKEN` | Ja | Token van @BotFather |
| `OPENAI_API_KEY` | Ja | OpenAI API key |
| `OPENAI_MODEL` | Nee | Model (standaard: `gpt-4o-mini`) |
| `SYSTEM_PROMPT` | Nee | System prompt voor de assistent |

## Draaien na opstart

```bash
cd telegram-chatgpt-bot && npm start
```

Of in de achtergrond (bijv. met `pm2` of een LaunchAgent).
