# Demos – Persoonlijke afbeelding per bedrijf

Sla hier een **screenshot of mockup** op van de 3D-configurator **met de branding van het bedrijf** (logo, kleuren, bedrijfsnaam). Die afbeelding wordt als bijlage meegestuurd met de cold email voor een persoonlijke touch.

## Bestandsnaam

Gebruik het **bedrijfsnaam-slug** (kleine letters, streepjes voor spaties):

| Bedrijf               | Bestandsnaam              |
|-----------------------|---------------------------|
| Hartog Dakkapellen    | hartog-dakkapellen.png    |
| Reno Totaalbouw       | reno-totaalbouw.png      |
| G. Theuns & Zoon      | theuns-zoon.png          |

**Formaat:** `.png` of `.jpg`. Bijvoorbeeld: `hartog-dakkapellen.png`.

## Workflow

1. **Jij (of iemand):** Maak een screenshot/mockup van de configurator met hun branding → sla op in deze map als `[bedrijf-slug].png` (of .jpg).
2. **ClawdBot:** Bij *"Verstuur cold email naar [bedrijf]"* kijkt hij of `demos/[bedrijf-slug].png` (of .jpg) bestaat. Zo ja: stuurt hij de mail **met die afbeelding als bijlage**. Zo nee: stuurt hij de mail zonder bijlage (of meldt: "Geen demo-afbeelding voor [bedrijf] – wil je er een toevoegen?").

## Pad voor ClawdBot

Volledig pad: `[workspace]/3d-configurator-verkoop/demos/[bedrijf-slug].png`  
Bijv. voor Hartog Dakkapellen: `.../demos/hartog-dakkapellen.png`
