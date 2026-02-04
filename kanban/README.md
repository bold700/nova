# Nova Kanban

Een simpele, mobiel-vriendelijke Kanban-bord voor je bot en persoonlijke taken.

## Quick Start

```bash
# Installeer Flask (eenmalig)
pip3 install flask flask-cors

# Start de server
cd ~/Documents/GitHub/nova/kanban
python3 server.py
```

Open vervolgens:
- **Mac:** http://localhost:5555
- **Mobiel:** http://\<mac-ip\>:5555 (zelfde wifi netwerk)

## IP Adres Vinden

```bash
# Op je Mac
ipconfig getifaddr en0
```

Dit geeft iets als `192.168.1.42`. Open dan op je telefoon: `http://192.168.1.42:5555`

## Bot Integratie

Je bot kan taken toevoegen via de API:

```bash
# Nieuwe taak toevoegen
curl -X POST http://localhost:5555/api/bot/add \
  -H "Content-Type: application/json" \
  -d '{"title": "Support mail beantwoorden", "description": "Ticket #123"}'

# Taak voltooien
curl -X POST http://localhost:5555/api/bot/complete/abc123
```

### Vanuit Python

```python
import requests

# Taak toevoegen
requests.post('http://localhost:5555/api/bot/add', json={
    'title': 'Inbox checken',
    'description': 'Nieuwe support mails verwerken'
})

# Taak voltooien
requests.post('http://localhost:5555/api/bot/complete/task_id')
```

## API Endpoints

| Method | Endpoint | Beschrijving |
|--------|----------|--------------|
| GET | `/api/tasks` | Alle taken ophalen |
| POST | `/api/tasks` | Nieuwe taak aanmaken |
| PUT | `/api/tasks/<id>` | Taak bijwerken |
| DELETE | `/api/tasks/<id>` | Taak verwijderen |
| POST | `/api/bot/add` | Bot taak toevoegen |
| POST | `/api/bot/complete/<id>` | Bot taak voltooien |

## Taak Structuur

```json
{
  "id": "abc123",
  "title": "Taak titel",
  "description": "Optionele beschrijving",
  "status": "todo",
  "type": "bot",
  "created": "2026-02-04T10:30:00",
  "updated": "2026-02-04T10:30:00"
}
```

**Status:** `todo` | `doing` | `done`
**Type:** `bot` | `personal`

## Keyboard Shortcuts

- `N` - Nieuwe taak
- `Esc` - Modal sluiten

## Auto-Start (LaunchAgent)

Maak `~/Library/LaunchAgents/com.nova.kanban.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.nova.kanban</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/python3</string>
        <string>/Users/nova/Documents/GitHub/nova/kanban/server.py</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>WorkingDirectory</key>
    <string>/Users/nova/Documents/GitHub/nova/kanban</string>
</dict>
</plist>
```

Activeer:
```bash
launchctl load ~/Library/LaunchAgents/com.nova.kanban.plist
```

## Bestanden

- `server.py` - Flask backend
- `index.html` - Kanban frontend
- `tasks.json` - Taken opslag (wordt automatisch aangemaakt)
