# Test: werkt de testmail-flow?

Korte checklist om te controleren of "test mail naar kcatimmer@gmail.com alsof naar Hartog" goed werkt.

---

## 1. Basis: script lokaal (snel check)

**Doel:** Zeker weten dat Himalaya + script op je Mac werken.

**Stappen:**
1. Open Terminal.
2. Voer uit:
   ```bash
   cd /Users/nova/clawd/3d-configurator-verkoop
   ./send-test-mail-hartog.sh kcatimmer@gmail.com
   ```
3. Controleer:
   - Geen foutmelding in de terminal.
   - In je inbox **kcatimmer@gmail.com**: mail van kenny.timmer@bold700.com, onderwerp "Idee voor Hartog Dakkapellen website", met bijlage (demo-afbeelding).

**Als dit lukt:** basis staat goed. Daarna test 2.

---

## 2. Via ClawdBot (Telegram)

**Doel:** Controleren of de bot de mail verstuurt (als hij exec heeft) of de juiste fallback geeft.

**Stappen:**
1. In Telegram tegen ClawdBot/Kenn zeggen:
   - *"Stuur test mail naar kcatimmer@gmail.com alsof naar Hartog"*
   - of: *"Test mail naar kcatimmer@gmail.com"*

**Verwacht gedrag:**

| Situatie | Wat je wilt zien |
|----------|-------------------|
| **Bot heeft exec** (draait op je Mac met shell/exec) | Bot zegt iets als "Test mail naar kcatimmer@gmail.com verstuurd via Himalaya." → Check inbox kcatimmer@gmail.com: mail moet er staan. |
| **Bot heeft geen exec** (alleen Telegram) | Bot zegt: *"Ik kan hier geen e-mail versturen. Voer lokaal op je Mac uit: `cd /Users/nova/clawd/3d-configurator-verkoop && ./send-test-mail-hartog.sh kcatimmer@gmail.com`"* → Jij voert dat commando uit → daarna check inbox. |

**Niet oké:** Bot probeert de mail via Telegram naar kcatimmer@gmail.com te "leveren" of vraagt "zal ik de mail eerst in het log opslaan?" als enige actie.

---

## 3. Verificatie

- **Inbox kcatimmer@gmail.com:** Mail van kenny.timmer@bold700.com, onderwerp over Hartog Dakkapellen, body + bijlage (demo).
- **Verzonden-map bold700 (optioneel):**  
  `himalaya envelope list --account bold700 --folder "Sent"`  
  De verstuurde mail zou hier zichtbaar moeten zijn (afhankelijk van je provider).

---

## 4. Als de bot nooit zelf verstuurt

Dan heeft ClawdBot in jouw setup waarschijnlijk **geen exec** op je Mac. Om "bot stuurt wanneer ik het vraag" te laten werken:

- ClawdBot/OpenClaw zo configureren dat de agent **wel** op je Mac draait met exec-tool (of een andere service op je Mac die bij "stuur test mail" het script of himalaya aanroept).

Tot die tijd: fallback is correct – jij voert lokaal `./send-test-mail-hartog.sh kcatimmer@gmail.com` uit nadat de bot dat aangeeft.
