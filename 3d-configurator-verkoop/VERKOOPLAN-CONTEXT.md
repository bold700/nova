# 3D Configurator Verkoop – Context voor ClawdBot

**Context besparen (voorkom "prompt too large"):** Volg **`TAKEN-REEKS.md`** – **één stap per beurt**, **één bestand per stap**. Simpele vraag → 1 bestand, antwoord, klaar. Mail opstellen → eerst BEDRIJVENLIJST (stap 1), dan TEMPLATES (stap 2), dan versturen (stap 3). Nooit alle bestanden in één beurt laden.

---

## Wat is dit project?

De gebruiker verkoopt een **white-label 3D-configurator** (dakkapellen, opbouw, aanbouw, kozijnen) als B2B SaaS aan bedrijven in de bouwsector. Het volledige plan staat in `3D-Configurator-Verkoopplan.md` (origineel in Downloads).

## Doel

- **Kort:** Eerste betalende klanten binnenhalen (pilot), daarna schalen.
- **Actielijst:** Week 1–4 uit het plan (landingspagina, demo’s, LinkedIn, outreach, demo calls).

## Waar staat wat?

**Let op:** `CONTACTEN-VERKOOP.md` bestaat **niet meer**. Alle contactgegevens staan in **`BEDRIJVENLIJST.md`** (kolommen Contactpersoon, Email, Bron, Laatst gecontroleerd). Gebruik nooit CONTACTEN-VERKOOP – alleen BEDRIJVENLIJST.

| Bestand | Inhoud |
|--------|--------|
| **`TAKEN-REEKS.md`** | **Eerst lezen:** één stap per beurt, één bestand per stap. Voorkomt "prompt too large". |
| `VERKOOPLAN-CONTEXT.md` | Dit bestand – korte context |
| `BEDRIJVENLIJST.md` | Bedrijven + contactgegevens in één (prioriteit, website, Contactpersoon, Email, Bron, Laatst gecontroleerd) |
| `COLD-EMAILS-LOG.md` | Log: verstuurde cold emails + reacties |
| `TEMPLATES-OUTREACH.md` | LinkedIn, cold email, follow-up templates |
| `ACTIE-COLD-EMAIL.md` | **Workflow voor ClawdBot: cold email actie** (e-mails verzamelen → opstellen → versturen → bevestigen → reacties melden) |
| `ACTIELIJST-WEEKEN.md` | Week 1–4 acties uit het plan |
| `../ACTIELIJST-VERKOOPLAN.md` | Huidige checklist (in clawd root) |
| **`CURSOR-AGENT-VANAF-TELEFOON.md`** | **Verkoopplan aansturen vanaf je telefoon** (Cursor web/mobile agent of Cursor Mobile app). **Ontwikkeling onderweg:** cursor.com/agents (repo bold700/nova) = cloud, Mac uit; jij (ClawdBot/Telegram) = op deze Mac, Mac aan. |
| `CURSOR-REPO-SETUP.md` | Repo op GitHub zetten voor cursor.com/agents |

## Hoe jij helpt

- **Herinneringen:** Verwijs naar actielijst en huidige week; geef korte, concrete volgende stappen.
- **Templates:** Als de gebruiker vraagt om een template (LinkedIn, email, follow-up), haal de tekst uit `TEMPLATES-OUTREACH.md` of het originele plan.
- **Status:** Bij “waar sta ik?” of “weekafsluiting”: lees `ACTIELIJST-VERKOOPLAN.md` en eventueel `memory/`, geef een korte stand van zaken.
- **Demo-prep:** Bij “demo met [bedrijf]”: geef pitch-bullets en bezwaren-antwoorden uit het plan (Deel 6).
- **Cold email actie:** Volg **`ACTIE-COLD-EMAIL.md`**. **Contact:** Aanbevolen: gebruiker zoekt zelf, zegt *"Voeg e-mail toe: [bedrijf], [email]"* – ClawdBot vult in en doet opstellen, versturen, loggen. **"Stuur test mail naar [emailadres]"** = e-mail **via Himalaya** naar dat adres sturen (cold-emailtekst + evt. bijlage), niet via Telegram; ontvanger is het e-mailadres.

Wees kort en actiegericht. Geen lange samenvattingen tenzij de gebruiker erom vraagt.

---

## Toegang tot deze Mac en Chrome

**ClawdBot draait op deze Mac** en heeft toegang tot deze machine. Gebruik **Chrome op deze Mac** voor webzoeken en het openen van pagina’s wanneer de gebruiker dat vraagt (bijv. “zoek via Google”, “zoek contactgegevens voor [bedrijf]”, “open deze site”). Je hoeft niet te vragen of je toegang hebt – je hebt het. Gebruik je **browser**- en **web_search**-tools op deze Mac; de standaardbrowser is Chrome.

---

## Bot via Telegram – wat moet kloppen?

| Check | Wat |
|-------|-----|
| **Gateway draaien** | Voor antwoorden en cron (06:00, 16:00) moet de gateway aan staan: `clawdbot gateway` of via Control UI. |
| **Telegram = last channel** | Telegram moet gekoppeld zijn als kanaal (eenmalig pairing). Dan gaan cron en antwoorden naar Telegram. |
| **Instructies** | ACTIE-COLD-EMAIL, BEDRIJVENLIJST, TEMPLATES – de bot leest die; geen extra stap. |
| **Test mail versturen** | Als je via Telegram zegt "stuur test mail naar kcatimmer@gmail.com": de bot moet **Himalaya** gebruiken (niet Telegram voor dat adres). Lukt dat alleen als de **agent op je Mac draait met exec**. Draait de bot elders zonder exec → hij geeft de fallback: jij voert lokaal `./send-test-mail-hartog.sh kcatimmer@gmail.com` uit. Dat is dan de bedoelde flow. |

**Samenvatting:** Zorg dat de gateway draait en Telegram gekoppeld is. Verder is niets extra nodig; de documentatie staat klaar. Wil je dat de bot zélf testmails verstuurt zodra je het vraagt, dan moet de gateway/agent op je Mac draaien met exec-tool (Clawd-configuratie); anders gebruik je de fallback (script lokaal draaien).

**Bestanden gewijzigd (bijv. CONTACTEN weg, alleen BEDRIJVENLIJST)?** De Telegram-chat gebruikt de context van toen het gesprek begon. De bot ziet wijzigingen pas als hij opnieuw inleest. **Doe dit:** start een **nieuwe chat** met de bot – dan laadt hij de actuele bestanden. Of zeg: *"Lees VERKOOPLAN-CONTEXT en ACTIE-COLD-EMAIL opnieuw. CONTACTEN-VERKOOP bestaat niet meer, alleen BEDRIJVENLIJST."*

**"Context overflow: prompt too large"?** Niet de vraag is te zwaar, maar de **totale context** (systeem + identiteit + memory + alle bestanden + hele gespreksgeschiedenis) is te groot. **Oplossing:** start een **nieuwe chat** in Telegram en stel daar alleen je vraag – bijv. *"Hoeveel potentielen met e-mail hebben we nu?"* of *"Welke bedrijven uit BEDRIJVENLIJST hebben een e-mail?"*. In een nieuwe chat is er geen lange geschiedenis, dan past het wel. Voor simpele vragen (aantallen, status): liefst nieuwe chat, één vraag.

**"Zoek contactgegevens via Google" – hoe doet ClawdBot dat?** ClawdBot draait op **deze Mac** en heeft toegang tot **Chrome op deze Mac**. Gebruik je **web_search**- en **browser**-tools (Chrome op deze Mac) wanneer de gebruiker vraagt om iets te googlen of een site te openen. Bij **context overflow** faalt het vóórdat je een tool kunt aanroepen – **workaround:** start een **nieuwe Telegram-chat** met alleen de vraag (bijv. *"Zoek contactgegevens voor Reno Totaalbouw"*), dan is de context klein en kun je web_search/browser wél gebruiken.

**Welk model draait er?** Standaard staat **Claude 3 Haiku** (`anthropic/claude-3-haiku-20240307`) in de config – goedkoper, kleinere context. Wijzigen: `clawdbot models set anthropic/claude-3-haiku-20240307` (Haiku) of `anthropic/claude-sonnet-4-5` (Sonnet, duurder, grotere context). Daarna gateway herstarten.

**"Agent failed: All models failed"?** Meestal: (1) **Anthropic in cooldown** (rate_limit) – even wachten of cooldown resetten in `~/.clawdbot/agents/main/agent/auth-profiles.json` (zet `cooldownUntil` en `errorCount`/`failureCounts` op null/0). (2) **Bedrock zonder API key** – als je Bedrock niet gebruikt, haal die fallback uit de config (`clawdbot.json` → `agents.defaults.model.fallbacks`). (3) **Geen API key** – run `clawdbot configure` of zet `ANTHROPIC_API_KEY` in je omgeving; of maak `~/.pi/agent/auth.json` (als je pi-agent gebruikt). Logs: `clawdbot logs --follow`.
