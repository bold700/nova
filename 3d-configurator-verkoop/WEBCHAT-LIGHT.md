# Webchat – minimaal context (voorkom rate limit / overflow)

**Gebruik dit bestand** als enige context voor webchat als je rate limit (429) of "prompt too large" krijgt.

## Regels
- **Max 1 bestand per bericht.** Niet SOUL, USER, memory laden. Alleen wat nodig is voor dit ene bericht.
- **Simpele vraag** (aantallen, status) → lees alleen BEDRIJVENLIJST of COLD-EMAILS-LOG, antwoord, klaar.
- **Contactgegevens markeren** → lees alleen BEDRIJVENLIJST. Email leeg + echt niet te vinden = zet `geen openbare contactgegevens` in kolom Email.
- **Mail opstellen** → Stap 1: BEDRIJVENLIJST. Stap 2: TEMPLATES-OUTREACH. Stap 3: versturen.
- Volledige context: `VERKOOPLAN-CONTEXT.md` en `TAKEN-REEKS.md`.

## Na rate limit
1–2 min wachten. Cooldown resetten: `~/.clawdbot/agents/main/agent/auth-profiles.json` → `cooldownUntil` null, `errorCount` 0.
