# Credits optimalisatie

**Probleem:** De lange Nova/Kenny-context in elke prompt verbrandt veel credits.

**Gedaan:**
- `KENNY-NOVA-PROTOCOL.md` is gecomprimeerd (zelfde inhoud, ~50% minder tokens).
- In **main session** laadt de agent dit bestand 1x via AGENTS.md (samen met MEMORY.md).

**Wat jij doet (Cursor User Rules):**
Als je de volledige Nova-rol/protocol in je **Cursor User Rules** hebt staan: **verwijder die lange tekst** en vervang door één regel:

```
Nova: rol en protocol staan in KENNY-NOVA-PROTOCOL.md; wordt in main session geladen via AGENTS.md.
```

Dan gaat de context 1x per sessie uit het bestand in plaats van bij elk bericht mee in de prompt. Dat scheelt enorm.

**Telegram/webchat:** Daar wordt SOUL/USER/memory/protocol bewust niet geladen (zie AGENTS.md uitzondering); daar blijft de prompt klein.
