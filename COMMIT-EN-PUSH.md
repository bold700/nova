# Eerste commit en push (na gesleept naar nova)

Je hebt de inhoud van **clawd** naar **Documenten/GitHub/nova** gesleept. Er staat nu een **.gitignore** in deze map (zodat TOKEN-VOOR-CONTROL-UI.txt niet mee naar GitHub gaat).

**Voer in Terminal uit (eenmalig):**

```bash
cd /Users/nova/Documents/GitHub/nova

# Als er nog geen git-repo is:
git init
git remote add origin https://github.com/bold700/nova.git

# Bestanden toevoegen en committen
git add .
git commit -m "Verkoopplan, BEDRIJVENLIJST, cold email workflow"

# Naar GitHub pushen (je wordt om inloggen gevraagd)
git branch -M main
git push -u origin main
```

Als deze map al een **git-repo** was (van de eerdere clone), volstaat:

```bash
cd /Users/nova/Documents/GitHub/nova
git add .
git commit -m "Verkoopplan, BEDRIJVENLIJST, cold email workflow"
git push -u origin main
```

Daarna staat alles op **github.com/bold700/nova** en kun je op je telefoon bij **cursor.com/agents** die repo koppelen.
