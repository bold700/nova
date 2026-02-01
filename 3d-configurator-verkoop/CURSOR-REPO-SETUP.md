# Repo-setup voor Cursor Agent vanaf telefoon (cursor.com/agents)

Om **cursor.com/agents** te gebruiken met deze projectmap, moet `clawd` in een Git-repo staan en op GitHub (of GitLab) gepusht zijn. Daarna koppel je die repo in Cursor web/mobile.

---

## Stappen (eenmalig)

### 1. Git-repo initialiseren (als nog niet gedaan)

In de map `clawd` (bovenliggende map van deze map):

```bash
cd /Users/nova/clawd
git init
```

Er staat al een `.gitignore` die o.a. `TOKEN-VOOR-CONTROL-UI.txt` uitsluit.

### 2. Eerste commit

```bash
git add .
git commit -m "Initial: verkoopplan, BEDRIJVENLIJST, cold email workflow"
```

### 3. GitHub-repo aanmaken

1. Ga naar [github.com/new](https://github.com/new).
2. Maak een **private** repo (bijv. `clawd` of `verkoopplan-3d`).
3. **Geen** README/ .gitignore toevoegen (je hebt ze lokaal al).
4. Kopieer de repo-URL (bijv. `https://github.com/jij/clawd.git`).

### 4. Remote toevoegen en pushen

De repo **bold700/nova** is al als `origin` gekoppeld. Eerste commit staat lokaal. **Eenmalig zelf pushen** (inloggen of SSH):

```bash
cd /Users/nova/clawd
git push -u origin main
```

(Als je nog geen remote had: `git remote add origin https://github.com/bold700/nova.git` – staat al.)

### 5. Repo koppelen in Cursor

1. Op je telefoon: ga naar **cursor.com/agents** (of open de Cursor PWA).
2. Log in met hetzelfde Cursor-account als op je Mac.
3. Koppel de **GitHub-repo** (clawd) – volg de Cursor-flow om een repo te verbinden.
4. Daarna kun je taken geven; de agent werkt in die repo (BEDRIJVENLIJST, drafts, enz.).

---

## Gevoelige gegevens

- `TOKEN-VOOR-CONTROL-UI.txt` staat in `.gitignore` en gaat **niet** mee naar GitHub.
- Geen wachtwoorden of API-keys in de bestanden zetten; gebruik env vars of lokaal config (buiten de repo).
