# 3D Configurator Verkoop – Context voor ClawdBot

**Context besparen (voorkom "prompt too large"):** Volg **`TAKEN-REEKS.md`** – **één stap per beurt**, **één bestand per stap**. Simpele vraag → 1 bestand, antwoord, klaar. Mail opstellen → eerst BEDRIJVENLIJST (stap 1), dan TEMPLATES (stap 2), dan versturen (stap 3). Nooit alle bestanden in één beurt laden. **Regel:** Laad per bericht **hooguit één** bestand tenzij de gebruiker expliciet meer vraagt; beantwoord kort en ga door.

**Bij /start of alleen "hi":** **Geen oude taak oppakken.** Ook als er in de chatgeschiedenis een eerdere taak staat (bijv. "zoek contact Reno Totaalbouw"): **negeer die.** Reageer **alleen** met: *"Hoi, waar kan ik je mee helpen?"* en wacht op een concrete vraag. Geen browser, geen web search, geen bestanden laden – tot de gebruiker iets concreets vraagt.

**Terminal herstarten helpt niet:** De geschiedenis zit in het **sessiebestand** op de Mac (niet alleen in Telegram). ClawdBot laadt bij elke chat het sessiebestand van jouw Telegram-account; daarin staat de hele conversatie. **Oplossing 1:** **Sessie resetten** – in `~/.clawdbot/agents/main/sessions/` staat per chat een `.jsonl`-bestand; als je dat opent en alles behalve de eerste regel (de regel met `"type":"session"`) verwijdert, is de geschiedenis leeg. Daarna /start → alleen groet. **Oplossing 2:** Nieuwe Telegram-chat kan helpen als dat een nieuw sessiebestand maakt; anders moet de sessie op de Mac gereset worden (zoals hierboven).

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
| **`WEBCHAT-LIGHT.md`** | Minimaal context voor webchat – gebruik als **enige** bestand bij rate limit/overflow. |
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

**"Context overflow: prompt too large"?** Niet de vraag is te zwaar, maar de **totale context** (systeem + identiteit + memory + alle bestanden + hele gespreksgeschiedenis) is te groot. **Oplossing:** start een **nieuwe chat** (Telegram of webchat) en stel daar alleen je vraag – bijv. *"Hoeveel potentielen met e-mail hebben we nu?"* of *"Welke bedrijven uit BEDRIJVENLIJST hebben een e-mail?"*. In een nieuwe chat is er geen lange geschiedenis, dan past het wel. Voor simpele vragen (aantallen, status): liefst nieuwe chat, één vraag. **Webchat:** Volg dezelfde licht-loading regel als Telegram – max 1 bestand per bericht (zie AGENTS.md).

**"Zoek contactgegevens via Google" – hoe doet ClawdBot dat?** ClawdBot draait op **deze Mac** en heeft toegang tot **Chrome op deze Mac**. Gebruik je **web_search**- en **browser**-tools (Chrome op deze Mac) wanneer de gebruiker vraagt om iets te googlen of een site te openen. Bij **context overflow** faalt het vóórdat je een tool kunt aanroepen – **workaround:** start een **nieuwe Telegram-chat** met alleen de vraag (bijv. *"Zoek contactgegevens voor Reno Totaalbouw"*), dan is de context klein en kun je web_search/browser wél gebruiken.

**Welk model draait er?** Standaard staat nu **Claude Sonnet 4.5** (primair) – grotere context, zodat lange chats niet snel "prompt too large" geven. Fallback: Haiku. Terug naar Haiku (goedkoper, kleinere context): `clawdbot models set anthropic/claude-3-haiku-20240307`; daarna gateway herstarten.

**"Agent failed: All models failed" / "moet wachten"?** Meestal: (1) **Anthropic in cooldown** (rate_limit) – na een mislukte request gaat het profiel in cooldown, dan faalt het volgende bericht ook ("No available auth profile... all in cooldown"). **Webchat "Reset" doet hier niks** – die reset alleen de chat, niet de API-cooldown. **Wat te doen:** 1–2 minuten wachten, of cooldown resetten: `./scripts/reset-clawdbot-cooldown.sh` (of handmatig in `~/.clawdbot/agents/main/agent/auth-profiles.json`: `cooldownUntil` null, `errorCount` 0, `failureCounts` {}). (2) **Bedrock zonder API key** – als je Bedrock niet gebruikt, haal die fallback uit de config (`clawdbot.json` → `agents.defaults.model.fallbacks`). (3) **Geen API key** – run `clawdbot configure` of zet `ANTHROPIC_API_KEY` in je omgeving; of maak `~/.pi/agent/auth.json` (als je pi-agent gebruikt). Logs: `clawdbot logs --follow`.

**"HTTP 429 rate_limit_error" (50.000 of 30.000 input tokens per minute)?** De **prompt is te groot** – per verzoek gaan er te veel tokens mee. Oplossing: (1) **Nieuwe chat** (Telegram of webchat) met alleen je vraag (geen lange geschiedenis). (2) **Één bestand per beurt** (TAKEN-REEKS) – niet alles tegelijk laden. (3) Even **1–2 minuten wachten** en opnieuw proberen; daarna cooldown resetten als nodig (`~/.clawdbot/agents/main/agent/auth-profiles.json`). (4) Bij Anthropic een hoger rate limit aanvragen als je vaak tegen de limiet aanloopt. **Webchat/Telegram:** AGENTS.md zegt: laad SOUL, USER, memory niet – alleen het bestand voor dit bericht (max 1). Dat voorkomt zowel overflow als rate limit.

**Kosten:** Je betaalt vooral voor **input tokens** (alles wat je naar de API stuurt: systeem, bestanden, chat). Grote prompts = veel input tokens = hogere kosten + sneller rate limit. **167k tokens in, 422 out** = bijna alle kosten zitten in het versturen, niet in het antwoord. Minder tokens per verzoek (nieuwe chat, één bestand) → minder kosten en grotere kans dat het lukt.

**Zonde als hij niks kan en het kost nog steeds geld:** In AGENTS.md staat nu een **Telegram-uitzondering**: in Telegram laad je **niet** SOUL, USER, memory, MEMORY aan het begin; alleen het bestand dat nodig is voor dit bericht (max 1). Zo blijft de prompt klein → hij kan wél antwoorden en je betaalt voor iets dat werkt.

**"Tokens voor niks" (398k in, 888 out):** Bijna alle kosten zitten in **input** die niet tot een goed antwoord leidden (rate limit, overflow, of te grote prompt). **Wat helpt:** (1) **Nieuwe chat** per onderwerp, **één concrete vraag** per keer – geen lange geschiedenis meenemen. (2) Bot moet **max 1 bestand** laden per bericht (zie Telegram-uitzondering in AGENTS.md). (3) **Limiet zetten** in Anthropic Console → Manage → Limits, zodat je niet ongemerkt veel verbruikt. (4) **Zwaardere of verkennende taken** via **cursor.com/agents** (repo bold700/nova) doen – dan loopt het verbruik via Cursor, niet via jouw API-key.

**"browser failed: Chrome extension relay... no tab is connected"?** ClawdBot kan Chrome alleen gebruiken als er een **tab is gekoppeld**. **Doe dit:** open **Chrome** op deze Mac → open een tab (bijv. google.com) → klik op het **Clawdbot Chrome-extension-icoon** in de tab (of in de toolbar) om die tab te **koppelen** (attach). Daarna kan de bot die tab gebruiken voor zoeken/pagina’s.
