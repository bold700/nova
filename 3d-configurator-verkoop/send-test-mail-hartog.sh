#!/bin/bash
# Test mail: cold email Hartog Dakkapellen naar opgegeven adres (default: kcatimmer@gmail.com)
# Gebruik: ./send-test-mail-hartog.sh [emailadres]
# Voorbeeld: ./send-test-mail-hartog.sh kcatimmer@gmail.com

TO="${1:-kcatimmer@gmail.com}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEMO_IMG="$SCRIPT_DIR/demos/hartog-dakkapellen.png"

# Body = verbeterde template (TEMPLATES-OUTREACH.md), placeholders ingevuld voor Hartog test
BODY="Hoi,

Ik kwam jullie advertentie voor dakkapellen op Instagram tegen en was onder de indruk – de kwaliteit van jullie projecten.

Eén ding viel me op: bezoekers kunnen op jullie website niet zelf hun dakkapel samenstellen. Steeds meer dakkapelbedrijven stappen over op online configurators – jullie kunnen vooroplopen. Uit onderzoek blijkt dat dit tot 40% meer serieuze aanvragen kan leiden.

Ik heb een 3D-configurator gebouwd waarmee klanten zelf afmetingen, materialen en kleuren kiezen en direct de prijs zien – vergelijkbaar met hoe Tesla auto's verkoopt.

Kan ik je dinsdag of donderdag even 10 minuten bellen om te laten zien hoe dit voor Hartog Dakkapellen werkt? Ik kan een versie met jullie branding maken; bijgevoegd een voorbeeld.

Met vriendelijke groet,
Kenny Timmer
061480282
bold700.com"

SUBJECT="Kort ideetje voor Hartog Dakkapellen"

if [[ -f "$DEMO_IMG" ]]; then
  printf 'From: kenny.timmer@bold700.com\nTo: %s\nSubject: %s\n\n%s\n<#part filename=%s><#/part>\n' "$TO" "$SUBJECT" "$BODY" "$DEMO_IMG" | himalaya template send --account bold700
else
  printf 'From: kenny.timmer@bold700.com\nTo: %s\nSubject: %s\n\n%s\n' "$TO" "$SUBJECT" "$BODY" | himalaya template send --account bold700
fi

echo "Klaar. Check je inbox op $TO"
