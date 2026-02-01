# Verkoopplan aansturen vanaf je telefoon (Cursor Agent)

Alles wat we voor ClawdBot doen (BEDRIJVENLIJST, cold email, templates, actielijst) kun je ook **via de Cursor-agent vanaf je telefoon** aansturen. Twee manieren.

---

## Ontwikkeling aansturen onderweg

**Doel:** Onderweg (telefoon) de ontwikkeling aansturen – bestanden aanpassen, BEDRIJVENLIJST bijwerken, cold email drafts, commits pushen, enz.

**Twee manieren:**

| Situatie | Hoe | Mac nodig? |
|----------|-----|------------|
| **Mac thuis uit** | **cursor.com/agents** op telefoon → repo **bold700/nova** koppelen → taken geven. Agent werkt in de **cloud** in die repo, kan bestanden bewerken en **pushen** naar GitHub. Thuis: op Mac `git pull` en verder werken. | Nee |
| **Mac thuis aan** | **ClawdBot (Telegram)** of **Cursor Mobile app** → je stuurt opdrachten vanaf telefoon. Agent draait op **deze Mac**, kan bestanden bewerken, `git commit` + `git push`, Chrome, Himalaya (mail). | Ja |

**Aanbevolen onderweg:** **cursor.com/agents** met repo **bold700/nova**. Dan kun je altijd (Mac aan of uit) vanaf je telefoon zeggen: *"Voeg e-mail toe: [bedrijf], [email]"*, *"Pas cold email template aan: …"*, *"Commit en push deze wijzigingen"* – de agent werkt in de cloud, pusht naar GitHub. Thuis op je Mac: `cd /Users/nova/Documents/GitHub/nova` → `git pull` en je hebt de laatste stand.

---

## Optie 1: Cursor Web/Mobile Agent (cursor.com/agents)

**Hoe het werkt:** Je opent op je telefoon **cursor.com/agents** (of de PWA), koppelt de repo **bold700/nova** (deze projectmap staat daar), en geeft daar opdrachten. De agent werkt in de cloud in die repo. **Onderweg:** ideaal – Mac hoeft niet aan; agent bewerkt bestanden en kan **commit + push** doen.

**Wat je vanaf je telefoon kunt doen:**
- *"Voeg e-mail toe: Reno Totaalbouw, info@renototaalbouw.nl"* → agent past BEDRIJVENLIJST.md aan
- *"Zoek contactgegevens voor [bedrijf]"* → agent zoekt (web) en vult BEDRIJVENLIJST in
- *"Welke bedrijven hebben nog geen e-mail?"* → agent leest BEDRIJVENLIJST, antwoordt
- *"Stel cold email op voor Hartog Dakkapellen"* → agent gebruikt TEMPLATES + BEDRIJVENLIJST, toont draft
- *"Update ACTIELIJST met vandaag gedaan"* → agent past actielijst aan

**Wat je nodig hebt:**
1. **Repo:** **bold700/nova** staat al op GitHub (deze map = Documenten/GitHub/nova).
2. **Cursor account:** Inloggen op cursor.com met hetzelfde account als op je Mac.
3. **cursor.com/agents:** Op telefoon in browser (of PWA) → repo **bold700/nova** koppelen → taken geven.

**Let op:** De web-agent werkt in de **codebase van de repo**. Hij kan bestanden bewerken, zoeken, en (als Cursor dat ondersteunt) web search. Hij kan **niet** lokaal Himalaya of je Mac-terminal aansturen – dus "verstuur deze mail via Himalaya" moet je zelf op je Mac doen, of je gebruikt ClawdBot (Telegram) daarvoor. Voor **contact zoeken, BEDRIJVENLIJST bijwerken, drafts opstellen** is de Cursor-agent ideaal vanaf je telefoon.

---

## Optie 2: Cursor Mobile app (telefoon → je Mac)

**Hoe het werkt:** Op je **Mac** staat Cursor open met de workspace **clawd** (deze map). Je installeert de **Cursor AI Mobile** app op je telefoon; die praat met Cursor op je Mac via Cursor CLI. Je stuurt vanaf je telefoon een prompt → die wordt op je Mac uitgevoerd **in deze workspace**.

**Wat je vanaf je telefoon kunt doen:** Hetzelfde als hierboven (BEDRIJVENLIJST, contact zoeken, cold email opstellen). Plus: als je Mac aanstaat en Cursor open heeft met clawd, kan de agent ook **lokaal** dingen doen (bijv. terminal, als je dat toestaat). Himalaya/ mail versturen blijft afhankelijk van wat de Cursor-agent op de Mac mag uitvoeren.

**Wat je nodig hebt:**
1. **Mac:** Cursor geïnstalleerd, **Cursor CLI** geïnstalleerd, **Full Disk Access** voor Cursor (macOS) zodat de agent in je projectmap kan.
2. **Workspace:** Op je Mac Cursor open met de map **Documenten/GitHub/nova** als workspace (File → Open Folder → nova).
3. **Cursor AI Mobile app:** Op je telefoon installeren (App Store), koppelen met je Mac (volg de app-setup). Daarna prompts sturen; die lopen op je Mac in de nova-workspace.

**Voordeel t.o.v. web-agent:** Agent draait op **jouw** Mac, dus heeft toegang tot je lokale omgeving (Himalaya, scripts) als je dat toestaat. **Nadeel:** Mac moet aan en Cursor open met clawd.

---

## Samen met ClawdBot (Telegram)

- **Telegram (ClawdBot):** Blijft handig voor snelle vragen, check-ins, en (als de gateway draait) mail versturen via Himalaya, cron (06:00/16:00). Gebruik **nieuwe chat** voor zoek-/contacttaken om context overflow te voorkomen.
- **Cursor-agent vanaf telefoon:** Beter voor "werk in de bestanden" – BEDRIJVENLIJST bijwerken, contact zoeken, drafts opstellen – zonder context overflow, omdat de Cursor-agent in een schone repo/workspace werkt.

**Praktisch:** Contact zoeken of BEDRIJVENLIJST bijwerken → Cursor-agent (web of mobile). Mail daadwerkelijk versturen of snelle vraag → ClawdBot Telegram (of lokaal script).

---

## Korte referentie: bestanden voor de agent

| Taak | Bestand(en) |
|------|-------------|
| Contact toevoegen / wie heeft geen e-mail | `3d-configurator-verkoop/BEDRIJVENLIJST.md` |
| Cold email opstellen | `3d-configurator-verkoop/TEMPLATES-OUTREACH.md`, BEDRIJVENLIJST.md |
| Verkoopacties / weekplan | `3d-configurator-verkoop/ACTIELIJST-WEEKEN.md`, `ACTIELIJST-VERKOOPLAN.md` |
| Workflow uitleg | `3d-configurator-verkoop/ACTIE-COLD-EMAIL.md`, `VERKOOPLAN-CONTEXT.md` |

De agent moet **TAKEN-REEKS** volgen: één stap per beurt, niet alle bestanden tegelijk laden (voorkomt "prompt too large").
