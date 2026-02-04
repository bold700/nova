# Bot ↔ Kanban connectie

## Hoe draait je bot?

Op basis van je repo:

- **ClawdBot control-ui** draait lokaal op `http://127.0.0.1:18789` (zie `OPEN-CLAWDBOT-DASHBOARD.html`).
- **Nova/Cursor** draait op dezelfde Mac.
- **Kanban server** draait op dezelfde Mac op poort **5555**.

Dus: **alles lokaal op één Mac** → geen ngrok of externe webhook nodig voor de verbinding bot ↔ Kanban.

## Welke URL gebruiken?

| Waar draait de code die Kanban aanroept? | URL voor Kanban API |
|------------------------------------------|----------------------|
| Op de Mac (Cursor, script, control-ui)   | `http://localhost:5555` |
| Mobiel / ander device (alleen bord openen) | `http://<mac-ip>:5555` (zelfde wifi) |
| Externe server (bijv. Telegram webhook)  | Ngrok: `ngrok http 5555` → gebruik de `https://….ngrok.io` URL |

Voor je huidige setup: **gebruik overal `http://localhost:5555`** als de bot of een script op de Mac de Kanban API aanroept.

## Bot → Kanban: taken toevoegen / voltooien

Vanuit de Mac (Cursor, Python, cron, etc.):

```bash
# Taak toevoegen
curl -X POST http://localhost:5555/api/bot/add \
  -H "Content-Type: application/json" \
  -d '{"title": "Support mail beantwoorden", "description": "Ticket #123"}'

# Taak voltooien
curl -X POST http://localhost:5555/api/bot/complete/<task_id>
```

Python (bijv. in een agent-script):

```python
import requests
requests.post('http://localhost:5555/api/bot/add', json={
    'title': 'Inbox checken',
    'description': 'Nieuwe support mails verwerken'
})
```

## Samenvatting

- **Bot:** lokaal (Cursor + ClawdBot control-ui op 18789).
- **Kanban:** lokaal op 5555.
- **Connectie:** `http://localhost:5555` voor API-aanroepen vanaf de Mac. Ngrok alleen nodig als iets van buitenaf (niet deze Mac) de Kanban moet bereiken.
