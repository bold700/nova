# Actie: Cold email per bedrijf

**Takenreeks:** Volg **`TAKEN-REEKS.md`** – **één stap per beurt**, **één bestand per stap**. Eerst BEDRIJVENLIJST (contact), dan TEMPLATES (opstellen), dan versturen. Niet alles in één keer laden (voorkomt "prompt too large").

**Contactgegevens:** Alleen **`BEDRIJVENLIJST.md`** (kolommen Contactpersoon, Email, Bron, Laatst gecontroleerd). `CONTACTEN-VERKOOP.md` bestaat niet meer.

Workflow: e-mails verzamelen → mail opstellen → mail versturen → bevestigen → reacties melden. **Uitvoering:** per stap één bestand, reageer, volgende beurt volgende stap.

---

## Stap 1: E-mails verzamelen per bedrijf

**Doel:** Voor elk bedrijf uit `BEDRIJVENLIJST.md` een contact-e-mail (en evt. telefoon) hebben. Bijhouden in **dezelfde** `BEDRIJVENLIJST.md` (kolommen Contactpersoon, Email, Bron, Laatst gecontroleerd).

**Aanbevolen: jij zoekt, ClawdBot vult in.**

- **Jij:** Google *"[bedrijfsnaam] contact"* (bijv. "Hartog Dakkapellen contact") – e-mail/telefoon staat vaak direct in de resultaten of het knowledge panel. Sneller dan ClawdBot laten zoeken.
- **Daarna:** Zeg tegen ClawdBot: *"Voeg e-mail toe: [bedrijf], [email]"* (evt. + telefoon). ClawdBot vult de contactkolommen in `BEDRIJVENLIJST.md` in (Bron = handmatig) en bevestigt. Daarna kan hij meteen de cold email opstellen en versturen.

**Optioneel: ClawdBot laten zoeken.**

- Zeg *"Zoek contactgegevens voor [bedrijf]"* → ClawdBot zoekt op het web en vult BEDRIJVENLIJST in als hij iets vindt. Lukt dat niet of duurt het te lang: zoek zelf en geef door met *"Voeg e-mail toe: [bedrijf], [email]"*.

**Wat jij zegt:**
- *"Voeg e-mail toe: Hartog Dakkapellen, info@hartogdakkapellen.nl"* → ClawdBot past `BEDRIJVENLIJST.md` aan (Email, Bron, Laatst gecontroleerd), bevestigt. Daarna: *"Stel cold email op voor Hartog Dakkapellen"* en eventueel *"Verstuur naar Hartog Dakkapellen"*.
- *"Welke bedrijven hebben nog geen e-mail?"* → ClawdBot geeft de lijst uit BEDRIJVENLIJST (waar Email leeg is).

**Bestanden:** Lees en bijwerk `BEDRIJVENLIJST.md` (bedrijf, website, situatie, prioriteit + contactkolommen).

---

## Stap 2: Mail opstellen

**Doel:** Persoonlijke cold email voor één (of meer) bedrijven, klaar om te versturen of ter goedkeuring.

**Wat jij doet:**
- *"Stel cold email op voor [bedrijfsnaam]"* of *"Stel cold emails op voor de eerste 5 bedrijven uit BEDRIJVENLIJST die nog geen mail in het log hebben."*

**Wat ClawdBot doet:**
1. Lees `TEMPLATES-OUTREACH.md` (sectie "Cold email (verbeterde versie)" + "Mijn gegevens"). Handtekening is altijd Kenny Timmer, 061480282, bold700.com.
2. Lees `BEDRIJVENLIJST.md` voor e-mail, bedrijfsnaam en contactpersoon (kolommen Contactpersoon, Email). **[Naam] in aanhef:** gebruik Contactpersoon indien ingevuld (zo niet: opzoeken op LinkedIn/website, anders "Beste heer/mevrouw").
3. Vul alle [PLACEHOLDER]-velden in (specifiek detail, [Dag]/[Dag] voor CTA, evt. [Plaats]). **Onderwerp:** kies één uit de template, bijv. "Kort ideetje voor [Bedrijfsnaam]", "Vraagje over jullie offerteproces", of "Gezien op Instagram – idee".
4. **Persoonlijke afbeelding:** Check of `demos/[bedrijf-slug].png` of `demos/[bedrijf-slug].jpg` bestaat (bijv. `demos/hartog-dakkapellen.png`). Zo ja: vermeld in de draft dat de mail **met bijlage** wordt verstuurd (voorbeeld configurator met hun branding). Zo nee: vermeld dat er geen demo-afbeelding is – mail gaat zonder bijlage, of gebruiker voegt eerst een afbeelding toe in `demos/`. Zie `demos/README.md` voor bestandsnaam (slug = bedrijfsnaam, kleine letters, spaties = streepjes).
5. Toon de opgestelde mail (onderwerp + body) in de chat. Optioneel: schrijf naar `drafts/cold-[bedrijf-slug].txt`.
6. Vraag: *"Zo versturen? (Ja = stap 3; Nee = zeg wat er anders moet.)"*

**Bestanden:** `TEMPLATES-OUTREACH.md`, `BEDRIJVENLIJST.md`, `demos/` (optioneel).

---

## Stap 3: Mail versturen

**Doel:** De goedgekeurde mail daadwerkelijk versturen en loggen.

**Voorwaarden:**
- E-mail versturen kan via **gog** (Gmail) of **himalaya** (IMAP/SMTP). Als die niet geconfigureerd zijn: ClawdBot geeft alleen de draft en zegt: "Verstuur zelf en zeg het me daarna."
- Volgens AGENTS.md: **vraag altijd bevestiging** voordat je een e-mail verstuurt.

**Wat ClawdBot doet:**
1. Als gebruiker "ja" zegt op de draft:
   - **Met himalaya:**  
     - **Zonder bijlage:** body (From, To, Subject, body) via stdin naar `himalaya template send --account bold700`.  
     - **Met persoonlijke afbeelding:** als `demos/[bedrijf-slug].png` of `demos/[bedrijf-slug].jpg` bestaat: bouw het bericht als tekst + MML-bijlage. Aan het einde van de body (na handtekening, voor de afsluitende newline) voeg toe: `\n<#part filename=<absoluut-pad-naar-demos/[bedrijf-slug].png>><#/part>\n`. Voorbeeld: `...bold700.com\n<#part filename=/Users/nova/clawd/3d-configurator-verkoop/demos/hartog-dakkapellen.png><#/part>\n`. Pipe het geheel naar `himalaya template send --account bold700`. Account **bold700** = kenny.timmer@bold700.com. Zie HIMALAYA-SETUP-BOLD700.md.  
     - Als geen demo-afbeelding: verstuur zonder bijlage.
   - **Met gog:** body-file (evt. bijlage apart indien gog dat ondersteunt).  
   - Zonder gog/himalaya: toon nogmaals de draft en vraag de gebruiker zelf te versturen.
2. Na versturen: **alleen als het himalaya-commando succesvol afsluit (exit code 0)** en de gebruiker niet meldt dat de mail niet aankwam:
   - **Log:** Vul in `COLD-EMAILS-LOG.md` een nieuwe rij in: Bedrijf, Email, Datum verstuurd (vandaag), Onderwerp, rest leeg.
   - **Bevestiging:** Stuur naar de gebruiker: *"Cold email verstuurd naar [bedrijf] ([email]). Gelogd in COLD-EMAILS-LOG."*
3. Bij fout, time-out, of als de gebruiker zegt dat de mail niet is aangekomen: meld het, log **niet** (of pas na handmatige bevestiging), en zeg niet dat de mail verstuurd is. "Message successfully sent!" van Himalaya is niet altijd betrouwbaar. Geef de fallback: *"Voer lokaal uit: ./send-test-mail-hartog.sh [emailadres]"* (voor testmail) of vraag of de gebruiker handmatig heeft verstuurd (dan alsnog loggen).

**Bestanden:** `COLD-EMAILS-LOG.md` (bijwerken), draft-bestand of body uit stap 2.

---

## Test mail naar een e-mailadres (bijv. kcatimmer@gmail.com)

**Doel:** **Jij (ClawdBot) moet de mail versturen** wanneer de gebruiker het vraagt. De gebruiker triggert dit vaak onderweg of wanneer hij bezig is – hij kan het script dan niet zelf draaien. Elk **@-adres** = e-mail via **Himalaya**, nooit via Telegram.

**Als de gebruiker zegt:** *"Stuur de cold email van Hartog naar kcatimmer@gmail.com"* of *"Test mail naar kcatimmer@gmail.com"* (of "alsof het een mail naar Hartog is"):

- **Niet doen:** Telegram gebruiken voor dat adres (e-mailadres ≠ Telegram-ontvanger; je krijgt "niet herkend"). Ook niet: zeggen "ik kan het niet, jij moet het script draaien" als je wél shell/exec hebt – dan moet jij versturen.
- **Wel doen (eerst):** **Zelf de e-mail versturen via Himalaya** als je shell/exec hebt op de machine waar Himalaya staat. Dat is de bedoeling:
  1. Bouw het bericht (plain text, geen HTML). Formaat:
     ```
     From: kenny.timmer@bold700.com
     To: kcatimmer@gmail.com
     Subject: Idee voor Hartog Dakkapellen website

     [body van de cold email – zie COLD-EMAILS-LOG of TEMPLATES-OUTREACH]
     [na handtekening, evt. nieuwe regel en:]
     <#part filename=/Users/nova/clawd/3d-configurator-verkoop/demos/hartog-dakkapellen.png><#/part>
     ```
  2. **Exact commando:** Er is géén `himalaya send`. Gebruik **`himalaya template send --account bold700`** met het bericht op stdin. Voorbeeld (exec/bash):
     `printf 'From: kenny.timmer@bold700.com\nTo: kcatimmer@gmail.com\nSubject: Idee voor Hartog Dakkapellen website\n\n[BODY HIER]\n' | himalaya template send --account bold700`
     Of: schrijf het volledige bericht naar een tijdelijk bestand en: `himalaya template send --account bold700 < /pad/naar/bestand`.
  3. Bevestig naar de gebruiker: *"Test mail naar kcatimmer@gmail.com verstuurd via Himalaya."*

De **ontvanger** is het e-mailadres; de **verzending** gaat via Himalaya (SMTP), niet via Telegram.

**Status controleren:** Er is **geen** `himalaya status`. Gebruik **`himalaya envelope list`** voor de inbox; voor verzonden mail: **`himalaya envelope list --account bold700 --folder "Sent"`** (mapnaam kan "Verzonden" of "Sent Mail" zijn). **Let op:** "Message successfully sent!" van Himalaya is niet altijd betrouwbaar – als de ontvanger niets krijgt of de mail niet in Verzonden staat, vertrouw dan de gebruiker en geef de fallback (lokaal script).

**Fallback (alleen als het echt niet kan):** Als je **geen** shell/exec hebt (bijv. je draait alleen in Telegram zonder toegang tot de machine) of himalaya faalt (sandbox, geen netwerk): zeg dan *"Ik kan hier geen e-mail versturen. Voer lokaal op je Mac uit: `cd /Users/nova/clawd/3d-configurator-verkoop && ./send-test-mail-hartog.sh kcatimmer@gmail.com`"* (of het genoemde adres). Niet zeggen "zal ik de email eerst in het log opslaan?" – dat vervangt versturen niet. Optioneel: mailtekst in een draft-bestand zetten als de gebruiker die wil zien.

**Samenvatting:** Eerst zelf proberen te versturen met `himalaya template send`. Alleen als je geen exec hebt of het commando faalt: fallback (gebruiker het script lokaal laten draaien). Voor "bot stuurt wanneer ik het vraag" moet ClawdBot dus in een omgeving draaien waar exec mogelijk is (bijv. op de Mac met exec-tool); anders kan hij fysiek geen himalaya aanroepen.

---

## Stap 4: Laten weten als ze zijn verstuurd

**Doel:** De gebruiker krijgt elke keer een korte bevestiging na een verstuurde cold email.

**Hoe:** Zie stap 3: direct na het versturen een bericht naar de gebruiker (Telegram/last channel) met: *"Cold email verstuurd naar [bedrijf] ([email])."* Alles wordt ook in `COLD-EMAILS-LOG.md` gezet.

**Optioneel – cron:** Een cron-job die bijvoorbeeld wekelijks vraagt: *"Lees COLD-EMAILS-LOG. Stuur een korte samenvatting: hoeveel cold emails zijn er in totaal verstuurd, en hoeveel daarvan hebben een reactie?"* en dat naar de gebruiker levert.

---

## Stap 5: Laten weten als er een reactie binnen is

**Doel:** Zodra er een reactie komt op een cold email, de gebruiker direct een melding geven.

**Hoe:** Via **Gmail pubsub** (incoming mail → webhook → OpenClaw). Als dat is ingesteld:

1. Nieuwe e-mail in Gmail → Google Pub/Sub → OpenClaw webhook (bijv. `hooks.presets: ["gmail"]` + mapping).
2. De hook stuurt o.a. afzender, onderwerp en snippet naar de agent.
3. Mapping met `deliver: true` en `channel: "last"` (of vast kanaal) zorgt dat de gebruiker een bericht krijgt, bijv.: *"Reactie in inbox: van [afzender], onderwerp [subject], snippet [eerste regels]."*

**Setup (eenmalig):** Zie docs: [Gmail pubsub](https://docs.clawd.bot/automation/gmail-pubsub). Kort: `gcloud` + `gog` + OpenClaw webhooks + Tailscale (of andere tunnel). Hook mapping met `deliver: true` zodat elke nieuwe mail (of alleen INBOX) naar de gebruiker wordt gestuurd. Optioneel: in de hook/mapping filteren op "Re: Idee voor" of afzender-domein, zodat alleen reacties op cold emails worden gemeld.

**Zonder Gmail pubsub:** ClawdBot kan geen live reacties zien. Gebruiker kijkt zelf in de inbox en kan zeggen: *"Reactie van [bedrijf]: [korte samenvatting]"* → ClawdBot werkt `COLD-EMAILS-LOG.md` bij (Reactie? = ja, Datum reactie, Notitie).

---

## Samenvatting voor ClawdBot

| Gebruiker vraagt | Actie |
|------------------|--------|
| "Voeg e-mail toe: [bedrijf], [email]" | Update `BEDRIJVENLIJST.md` (kolommen Email, Bron, Laatst gecontroleerd), bevestig. **Dit is de snelste route:** gebruiker zoekt zelf (Google "[bedrijfsnaam] contact"), geeft door; ClawdBot vult in en doet daarna opstellen/versturen/loggen. |
| "Zoek contactgegevens voor [bedrijf]" | Optioneel: web search + evt. website, update BEDRIJVENLIJST (Email, Bron, Laatst gecontroleerd), rapporteer. Als niets gevonden: zeg "Niet gevonden – zoek zelf (Google '[bedrijf] contact') en zeg dan: Voeg e-mail toe: [bedrijf], [email]." |
| "Stel cold email op voor [bedrijf]" | Template invullen, tonen. Check `demos/[bedrijf-slug].png` of `.jpg` – zo ja: vermeld "met bijlage (voorbeeld met hun branding)". Vraag "zo versturen?". |
| "Verstuur de cold email naar [bedrijf]" (na goedkeuring) | himalaya/gog send. **Met persoonlijke afbeelding:** als `demos/[bedrijf-slug].png` of `.jpg` bestaat: voeg MML-bijlage toe (`<#part filename=<absoluut-pad>><#/part>`). Log in COLD-EMAILS-LOG; bevestig naar gebruiker. |
| "Stuur (test) mail naar [emailadres]" / "test mail naar kcatimmer@gmail.com alsof naar Hartog" | **Doel: jij verstuurt.** Eerst zelf `himalaya template send --account bold700` uitvoeren (From kenny.timmer@bold700.com, To het adres, Subject + body uit TEMPLATES-OUTREACH/Hartog, evt. bijlage demos/hartog-dakkapellen.png) als je shell/exec hebt. NOOIT Telegram voor @-adres. Alleen als je geen exec hebt of het faalt: fallback *"Voer lokaal uit: ./send-test-mail-hartog.sh [adres]"* in 3d-configurator-verkoop. |
| "Welke cold emails zijn verstuurd?" | Lees COLD-EMAILS-LOG, geef korte samenvatting. |
| "Er is een reactie van [bedrijf]: [samenvatting]" | Update COLD-EMAILS-LOG (reactie = ja, datum, notitie). |

**Bestanden:** `BEDRIJVENLIJST.md` (bedrijven + contacten in één), `TEMPLATES-OUTREACH.md`, `COLD-EMAILS-LOG.md`, `demos/` (optioneel: afbeelding per bedrijf voor bijlage). Bij versturen: vraag altijd bevestiging; na versturen: log + bericht naar gebruiker. **Himalaya:** Gebruik `himalaya envelope list` (of `--account bold700`) om inbox/verzonden te controleren; er is **geen** `himalaya status`. Alleen "verstuurd" melden en loggen als het commando echt succesvol afsluit.
