#!/bin/bash
# SMS naar Kanban - Handmatig script
# Leest SMS'jes van een specifiek nummer en voegt ze toe aan Kanban
#
# Gebruik: ./scripts/sms-naar-kanban.sh [telefoon-nummer]
# Standaard: +31613469782 (werk telefoon)

PHONE="${1:-+31613469782}"
KANBAN_URL="http://localhost:5555/api/bot/add"
MESSAGES_DB="$HOME/Library/Messages/chat.db"
PROCESSED_FILE="$HOME/.sms-kanban-processed.txt"

# Maak processed file als die niet bestaat
touch "$PROCESSED_FILE"

echo "📱 SMS naar Kanban"
echo "Telefoon: $PHONE"
echo "---"

# Check of Messages DB bestaat
if [[ ! -f "$MESSAGES_DB" ]]; then
  echo "❌ Messages database niet gevonden: $MESSAGES_DB"
  echo "Tip: Geef Terminal 'Full Disk Access' in Systeemvoorkeuren > Privacy & Beveiliging"
  exit 1
fi

# Haal SMS'jes op van vandaag (of laatste 24 uur)
# SQLite query voor iMessage/SMS database
MESSAGES=$(sqlite3 "$MESSAGES_DB" "
SELECT
  m.rowid,
  m.text
FROM message m
JOIN handle h ON m.handle_id = h.rowid
WHERE h.id LIKE '%${PHONE/+/}%'
  AND m.is_from_me = 0
  AND m.text IS NOT NULL
  AND m.text != ''
  AND datetime(m.date/1000000000 + 978307200, 'unixepoch', 'localtime') > datetime('now', '-24 hours', 'localtime')
ORDER BY m.date DESC
" 2>/dev/null)

if [[ -z "$MESSAGES" ]]; then
  echo "Geen nieuwe SMS'jes gevonden van $PHONE (laatste 24 uur)"
  exit 0
fi

COUNT=0
while IFS='|' read -r rowid text; do
  # Skip als al verwerkt
  if grep -q "^$rowid$" "$PROCESSED_FILE" 2>/dev/null; then
    continue
  fi

  # Skip lege berichten
  if [[ -z "$text" ]]; then
    continue
  fi

  echo "➕ Toevoegen: $text"

  # Voeg toe aan Kanban
  RESPONSE=$(curl -s -X POST "$KANBAN_URL" \
    -H "Content-Type: application/json" \
    -d "{\"title\": \"$text\"}")

  if echo "$RESPONSE" | grep -q '"id"'; then
    echo "   ✅ Toegevoegd"
    echo "$rowid" >> "$PROCESSED_FILE"
    ((COUNT++))
  else
    echo "   ❌ Fout: $RESPONSE"
  fi
done <<< "$MESSAGES"

echo "---"
echo "✅ $COUNT SMS'jes toegevoegd aan Kanban"
