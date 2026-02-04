# Kanban Integratie

**Base URL:** https://nova-ajyh.onrender.com

## API Endpoints

### Taken toevoegen
```bash
POST https://nova-ajyh.onrender.com/api/bot/add
Content-Type: application/json

{"title": "Taak titel", "description": "Optioneel"}
```

### Taken ophalen
```bash
GET https://nova-ajyh.onrender.com/api/tasks
```

### Taak voltooien
```bash
POST https://nova-ajyh.onrender.com/api/bot/complete/<task_id>
```

### Taak verwijderen
```bash
DELETE https://nova-ajyh.onrender.com/api/tasks/<task_id>
```

## Wanneer gebruiken

**1. Kenny vraagt iets te onthouden**
→ Voeg direct toe aan Kanban als taak

**2. Taak is voltooid**
→ Markeer als done via complete endpoint

**3. Begin van de dag**
→ Check open taken (GET /api/tasks) en meld relevante taken

## Voorbeelden

**Toevoegen:**
```bash
curl -X POST https://nova-ajyh.onrender.com/api/bot/add \
  -H "Content-Type: application/json" \
  -d '{"title":"Cold emails versturen","description":"Batch 1 - 10 bedrijven"}'
```

**Ophalen:**
```bash
curl https://nova-ajyh.onrender.com/api/tasks
```

**Voltooien:**
```bash
curl -X POST https://nova-ajyh.onrender.com/api/bot/complete/abc123
```

**Verwijderen:**
```bash
curl -X DELETE https://nova-ajyh.onrender.com/api/tasks/abc123
```
