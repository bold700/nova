#!/bin/bash
# Debug script - kijk wat er in Messages database staat

MESSAGES_DB="$HOME/Library/Messages/chat.db"

echo "=== Laatste 10 berichten (alle nummers) ==="
sqlite3 "$MESSAGES_DB" "
SELECT
  h.id as telefoon,
  substr(m.text, 1, 50) as bericht,
  datetime(m.date/1000000000 + 978307200, 'unixepoch', 'localtime') as tijd
FROM message m
JOIN handle h ON m.handle_id = h.rowid
WHERE m.is_from_me = 0
  AND m.text IS NOT NULL
ORDER BY m.date DESC
LIMIT 10
" 2>/dev/null

echo ""
echo "=== Alle bekende telefoon handles ==="
sqlite3 "$MESSAGES_DB" "SELECT id FROM handle WHERE id LIKE '%6134%' OR id LIKE '%31%'" 2>/dev/null
