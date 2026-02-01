# Himalaya instellen voor kenny.timmer@bold700.com

ClawdBot gebruikt **himalaya** om cold emails te versturen vanaf **kenny.timmer@bold700.com**. De config staat in `~/.config/himalaya/config.toml` en haalt het wachtwoord uit de macOS Keychain.

---

## Stap 1: Wachtwoord in Keychain zetten

Voer **eenmalig** in de Terminal uit (vervang `JOUW_WACHTWOORD` door het wachtwoord van kenny.timmer@bold700.com):

```bash
security add-generic-password -a "kenny.timmer@bold700.com" -s "himalaya-bold700" -w "JOUW_WACHTWOORD"
```

Daarna staat het wachtwoord in de Keychain; je hoeft het niet in een bestand te zetten.

---

## Stap 2: Servergegevens controleren (indien nodig)

De config gebruikt nu:

- **IMAP:** mail.bold700.com, poort 993 (TLS)
- **SMTP:** mail.bold700.com, poort 587 (STARTTLS)

Als jouw provider andere hostnamen of poorten gebruikt (bijv. imap.bold700.com, smtp.bold700.com, of poort 465 voor SMTP), pas dan `~/.config/himalaya/config.toml` aan. Die info staat vaak in Roundcube onder Instellingen → Accounts of in de documentatie van bold700.com.

---

## Stap 3: Testen

**Let op:** Er is **geen** `himalaya status`-commando. Gebruik **`himalaya envelope list`** (standaard = INBOX). Voor verzonden mail: **`himalaya envelope list --folder "Sent"`** (mapnaam kan "Verzonden" of "Sent Mail" zijn).

```bash
# Lijst van accounts
himalaya account list

# Inbox tonen (standaard map = INBOX)
himalaya envelope list
himalaya envelope list --account bold700

# Verzonden map tonen
himalaya envelope list --account bold700 --folder "Sent"

# Testmail versturen (vervang het adres) – zie himalaya message write of template send
himalaya message write
# of: himalaya template send (met From/To/Subject/body via stdin)
```

Als dit werkt, kan ClawdBot dezelfde account gebruiken voor cold emails.

---

## ClawdBot

Bij "cold email versturen" gebruikt ClawdBot standaard het **default** account; dat is nu **bold700**. Geen extra instelling nodig.

Als je ooit een ander account wilt gebruiken: in `~/.config/himalaya/config.toml` kun je `default = true` bij een ander account zetten, of ClawdBot kan in de workflow expliciet account `bold700` gebruiken.
