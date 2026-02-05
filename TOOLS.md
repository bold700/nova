# TOOLS.md - Local Notes

Skills define *how* tools work. This file is for *your* specifics — the stuff that's unique to your setup.

## Verkoopplan (3D Configurator B2B)

- **Toegang tot deze Mac en Chrome:** Je draait op deze Mac en hebt toegang tot deze machine. Gebruik **Chrome op deze Mac** voor web_search en browser (googlen, pagina’s openen) wanneer de gebruiker dat vraagt.
- **Bij /start of "hi":** Negeer alle eerdere berichten in de chat. Pak geen oude taak op (geen Reno Totaalbouw, geen browser, geen web search). Alleen antwoorden: "Hoi, waar kan ik je mee helpen?" en wachten op een concrete vraag.
- **Ontwikkeling onderweg aansturen:** Zie `3d-configurator-verkoop/CURSOR-AGENT-VANAF-TELEFOON.md`. Kort: cursor.com/agents (repo bold700/nova) = onderweg zonder Mac; jij (ClawdBot/Telegram) = op deze Mac, Mac moet aan. Geef die info door als de gebruiker vraagt hoe hij onderweg kan aansturen.
- **Takenreeks (verkoop):** Volg `3d-configurator-verkoop/TAKEN-REEKS.md` – **één stap per beurt**, **één bestand per stap**. Simpele vraag = 1 bestand, antwoord. Mail opstellen = stap 1 BEDRIJVENLIJST, stap 2 TEMPLATES, stap 3 versturen. Voorkomt "prompt too large".
- **Actielijst:** `ACTIELIJST-VERKOOPLAN.md` (root)
- **Context, bedrijven, templates:** `3d-configurator-verkoop/` (VERKOOPLAN-CONTEXT.md, BEDRIJVENLIJST.md, TEMPLATES-OUTREACH.md, ACTIELIJST-WEEKEN.md)
- **Cold email actie:** `3d-configurator-verkoop/ACTIE-COLD-EMAIL.md` – workflow: e-mails verzamelen (BEDRIJVENLIJST.md), mail opstellen (template), versturen (gog/himalaya), log (COLD-EMAILS-LOG.md), bevestiging naar gebruiker, reacties (Gmail pubsub of handmatig).
- **Bedrijven + contacten + log:** `3d-configurator-verkoop/BEDRIJVENLIJST.md`, `3d-configurator-verkoop/COLD-EMAILS-LOG.md`
- **Persoonlijke afbeelding:** `3d-configurator-verkoop/demos/` – sla per bedrijf een screenshot/mockup op als `[bedrijf-slug].png` (bijv. hartog-dakkapellen.png); ClawdBot voegt die als bijlage toe bij cold email. Zie `demos/README.md`.
- **Himalaya (cold email):** Account **bold700** = kenny.timmer@bold700.com. Config: `~/.config/himalaya/config.toml`. Setup: `3d-configurator-verkoop/HIMALAYA-SETUP-BOLD700.md`.
- **Cron instructies:** `3d-configurator-verkoop/CLAWDBOT-CRON-INSTRUCTIES.md`

---

## Boekhouding (Visma eAccounting)

**Dagelijkse workflow (1x per dag):**
1. Check Kas- en banktransacties: https://eaccounting.vismaonline.com/#/reconciliation
2. Voor elke uitgave: zoek bonnetje/factuur in inbox
   - `himalaya envelope list -a support` (support@bold700.com)
   - `himalaya envelope list -a bold700` (kenny.timmer@bold700.com)
3. Niet gevonden? → vraag Kenny, hij stuurt door
4. Upload naar Geüploade foto's: https://eaccounting.vismaonline.com/#/common/photos
   - Klik "Upload bestand" (browser act click)
   - `browser upload` action + PDF/afbeelding path
   - **Let op bestandsnaam:** alleen letters, cijfers, spaties, ( ) - _ .
5. Check gegevens (Visma haalt vaak automatisch uit PDF):
   - Datum, Crediteur, Bedrag, Type, Vervaldatum
   - Edit icon (potlood) → aanpassen → Done/check icon
6. Klaar voor verwerking (Kenny doet koppeling zelf)

**Himalaya accounts:**
- `support` = support@bold700.com
- `bold700` = kenny.timmer@bold700.com (default)

**Visma URLs:**
- Dashboard: https://eaccounting.vismaonline.com/#/dashboard
- Kas/bank: https://eaccounting.vismaonline.com/#/reconciliation
- Foto's: https://eaccounting.vismaonline.com/#/common/photos

---

## What Goes Here

Things like:
- Camera names and locations
- SSH hosts and aliases  
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras
- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH
- home-server → 192.168.1.100, user: admin

### TTS
- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.
