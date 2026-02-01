# Terminal – wat moet je (nog) doen?

## Eenmalig (als je het nog niet deed)

**1. Check-in 16:00 toevoegen**  
Je hebt checkin-06 al toegevoegd. Voor de middag-check-in voer je **eenmalig** uit:

```bash
clawdbot cron add \
  --name "checkin-16" \
  --cron "0 16 * * *" \
  --tz Europe/Amsterdam \
  --session isolated \
  --message "Goedemiddag. Doe een actieve check-in bij de gebruiker. Verzin 3 concrete taken die jij nog vandaag kunt doen (verkoopplan / cold email / contacten). Verzin 1 concrete taak voor de gebruiker. Stuur dit als één kort bericht. Max 10 regels. Wees concreet." \
  --deliver \
  --channel last
```

**2. Optioneel – weekstart (maandag 09:00) en weekafsluiting (vrijdag 17:00)**  
Zie `CLAWDBOT-CRON-INSTRUCTIES.md` voor de exacte commando’s `verkoopplan-maandag` en `verkoopplan-vrijdag`.

**3. Cron controleren**  
```bash
clawdbot cron list
```

---

## Elke keer dat je de bot / cron wilt gebruiken

**Gateway starten**  
Zonder gateway reageert de bot niet en draaien de cron-jobs niet. Start de gateway wanneer je de bot of de geplande berichten wilt:

```bash
clawdbot gateway
```

Of start via de Control UI. Laat de gateway draaien (of zet hem zo in dat hij bij opstarten van je Mac start).

---

## Geen terminal nodig voor

- Himalaya (staat al in Keychain)
- `send-test-mail-hartog.sh` (is uitvoerbaar; gebruik wanneer de bot de fallback geeft)
- Bestanden (BEDRIJVENLIJST, ACTIE-COLD-EMAIL, etc.) – die leest de bot zelf
