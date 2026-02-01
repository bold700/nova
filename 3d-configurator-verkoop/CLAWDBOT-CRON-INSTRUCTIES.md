# ClawdBot cron – Verkoopplan automatisering

Om wekelijkse herinneringen te krijgen (Telegram of laatste kanaal), voer je onderstaande commando’s **eenmalig** uit in de terminal. De gateway moet draaien (`clawdbot gateway` of via de Control UI).

**Let op:** Als `clawdbot cron add` in deze omgeving een fout geeft (bijv. network/uv_interface_addresses), voer de commando’s lokaal op je Mac uit.

---

## Dagelijks 06:00 en 16:00 – Actieve check-in (3 taken voor bot, 1 voor jou)

Elke dag om **06:00** en **16:00** stuurt ClawdBot een check-in: 3 taken die hij kan doen + 1 taak voor jou. Voer beide commando’s eenmalig uit.

**06:00 – Goedemorgen check-in**

Gebruik `--session isolated` zodat je alleen `--message` nodig hebt (geen `--system-event`). Main-session jobs vereisen `--system-event`.

```bash
clawdbot cron add \
  --name "checkin-06" \
  --cron "0 6 * * *" \
  --tz Europe/Amsterdam \
  --session isolated \
  --message "Goedemorgen. Doe een actieve check-in bij de gebruiker. Verzin 3 concrete taken die jij vandaag kunt doen (relevant voor verkoopplan: cold email, BEDRIJVENLIJST, COLD-EMAILS-LOG). Verzin 1 concrete taak voor de gebruiker. Stuur dit als één kort bericht naar de gebruiker (channel last). Max 10 regels. Wees concreet." \
  --deliver \
  --channel last
```

**16:00 – Goedemiddag check-in**

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

Na het toevoegen krijg je om 06:00 en 16:00 een bericht op het laatste kanaal (bijv. Telegram) met de check-in en de 3+1 taken.

---

## Maandag 09:00 – Weekstart verkoopplan

```bash
clawdbot cron add \
  --name "verkoopplan-maandag" \
  --cron "0 9 * * 1" \
  --tz Europe/Amsterdam \
  --session isolated \
  --message "Het is maandag. Lees ACTIELIJST-VERKOOPLAN.md en 3d-configurator-verkoop/ACTIELIJST-WEEKEN.md. Geef in max 5 zinnen: welke week van het plan we zijn, wat er deze week op de actielijst staat, en één concrete aanmoediging. Wees kort." \
  --deliver \
  --channel last
```

---

## Vrijdag 17:00 – Weekafsluiting verkoopplan

```bash
clawdbot cron add \
  --name "verkoopplan-vrijdag" \
  --cron "0 17 * * 5" \
  --tz Europe/Amsterdam \
  --session isolated \
  --message "Vrijdag einde week. Lees ACTIELIJST-VERKOOPLAN.md. Wat is deze week gedaan (of wat blijft liggen)? Geef een korte weekafsluiting en één suggestie voor volgende week. Max 5 zinnen. Lever af." \
  --deliver \
  --channel last
```

---

## Cron bekijken / uitschakelen

- Lijst: `clawdbot cron list`
- Uitschakelen: `clawdbot cron disable --name checkin-06` (of `checkin-16`, `verkoopplan-maandag`, etc.)
- Weer inschakelen: `clawdbot cron enable --name checkin-06`

---

*Na het toevoegen: dagelijks om 06:00 en 16:00 een check-in (3 taken voor bot, 1 voor jou); maandag en vrijdag de weekstart/weekafsluiting.*
