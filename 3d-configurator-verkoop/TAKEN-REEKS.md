# Takenreeks – één stap per beurt (voorkom "prompt too large")

**Principe:** Doe **één stap per beurt**. Laad per stap **één bestand** (of minimaal). Reageer. In de volgende beurt de volgende stap. **Nooit** alle bestanden (BEDRIJVENLIJST + ACTIE + TEMPLATES + VERKOOPLAN-CONTEXT) in één keer laden.

---

## Simpele vragen (1 stap, klaar)

| Vraag | Stap 1 | Klaar |
|-------|--------|-------|
| "Hoeveel potentielen met e-mail?" | Lees **alleen** BEDRIJVENLIJST.md, tel rijen waar Email ingevuld is. Geef getal. | Ja |
| "Welke bedrijven missen e-mail?" | Lees **alleen** BEDRIJVENLIJST.md, geef bedrijfsnamen waar Email leeg is. | Ja |
| "Hoeveel cold emails verstuurd?" | Lees **alleen** COLD-EMAILS-LOG.md, tel rijen. Geef getal. | Ja |
| "Voeg e-mail toe: [bedrijf], [email]" | Lees **alleen** BEDRIJVENLIJST.md, vul Email/Bron/Laatst gecontroleerd in voor dat bedrijf, bevestig. | Ja |

---

## Cold email opstellen (meerdere stappen, één per beurt)

**Gebruiker zegt:** "Stel cold email op voor [bedrijf]"

| Stap | Wat je doet | Bestand(en) | Na je reactie |
|------|-------------|-------------|----------------|
| **1** | Lees **alleen** BEDRIJVENLIJST.md, zoek de rij voor dat bedrijf (Email, Contactpersoon). | Alleen BEDRIJVENLIJST | Zeg: "Ik heb [bedrijf], email [x]. Zal ik de mailtekst opstellen? (stap 2)" |
| **2** | Lees **alleen** TEMPLATES-OUTREACH.md (sectie "Cold email (verbeterde versie)" + "Mijn gegevens"). Check evt. demos/[bedrijf-slug].png. | Alleen TEMPLATES-OUTREACH (+ evt. demos) | Gebruik contact uit stap 1, vul template in, toon onderwerp + body. Zeg: "Zo versturen? (Ja = stap 3)" |
| **3** | Alleen als gebruiker "ja" zegt: verstuur via himalaya (of geef fallback script). Lees **alleen** COLD-EMAILS-LOG.md om te loggen. | Alleen wat nodig voor versturen + COLD-EMAILS-LOG | Bevestig: "Mail verstuurd, gelogd." |

**Niet doen:** In één beurt BEDRIJVENLIJST + TEMPLATES + ACTIE-COLD-EMAIL + VERKOOPLAN-CONTEXT laden. Wel: eerst stap 1, reageer; dan stap 2, reageer; dan stap 3.

---

## Test mail versturen

**Gebruiker zegt:** "Stuur test mail naar kcatimmer@gmail.com alsof naar Hartog"

| Stap | Wat je doet | Bestand(en) |
|------|-------------|-------------|
| **1** | Lees **alleen** TEMPLATES-OUTREACH.md (cold email body voor Hartog) of gebruik send-test-mail-hartog.sh. Bouw bericht (From, To, Subject, body). | Alleen TEMPLATES (of script) |
| **2** | Voer himalaya template send uit (of zeg: "Voer lokaal uit: ./send-test-mail-hartog.sh kcatimmer@gmail.com"). | – |

---

## Check-in / taken (cron)

Bij check-in (06:00, 16:00): verzin 3 taken voor jou + 1 voor de gebruiker. **Per taak die je daarna uitvoert:** één stap per beurt. Bijv. "Ik ga BEDRIJVENLIJST bijwerken" → lees alleen BEDRIJVENLIJST, doe de wijziging, bevestig. Niet tegelijk alles laden.

---

## Samenvatting

- **Één stap per beurt.** Eén (of weinig) bestand per stap.
- **Simpele vraag** → 1 bestand, antwoord, klaar.
- **Mail opstellen** → Stap 1: BEDRIJVENLIJST. Stap 2: TEMPLATES + opstellen. Stap 3: versturen + log.
- **Nooit** in één keer: BEDRIJVENLIJST + ACTIE-COLD-EMAIL + TEMPLATES + VERKOOPLAN-CONTEXT + memory + TOOLS.
