#!/bin/bash
# Check support@bold700.com en kenny.timmer@bold700.com inbox voor facturen en werkaanvragen

LOG_FILE="$HOME/Documents/GitHub/nova/memory/support-inbox-$(date +%Y-%m-%d).md"

echo "## Bold700 Inbox Check - $(date '+%Y-%m-%d %H:%M')" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

ALERT_FOUND=false

# Check support@bold700.com
echo "### 📧 support@bold700.com" >> "$LOG_FILE"
EMAILS_SUPPORT=$(himalaya envelope list --account support --page-size 20 2>/dev/null)
IMPORTANT_SUPPORT=$(echo "$EMAILS_SUPPORT" | grep -iE "factuur|invoice|betaling|payment|offerte|quote|aanvraag|request|urgent|order")

if [ -n "$IMPORTANT_SUPPORT" ]; then
    echo "⚠️ **Belangrijke berichten:**" >> "$LOG_FILE"
    echo '```' >> "$LOG_FILE"
    echo "$IMPORTANT_SUPPORT" >> "$LOG_FILE"
    echo '```' >> "$LOG_FILE"
    ALERT_FOUND=true
else
    echo "Geen urgente berichten." >> "$LOG_FILE"
fi

echo "" >> "$LOG_FILE"

# Check kenny.timmer@bold700.com
echo "### 📧 kenny.timmer@bold700.com" >> "$LOG_FILE"
EMAILS_KENNY=$(himalaya envelope list --account bold700 --page-size 20 2>/dev/null)
IMPORTANT_KENNY=$(echo "$EMAILS_KENNY" | grep -iE "factuur|invoice|betaling|payment|offerte|quote|aanvraag|request|urgent|order")

if [ -n "$IMPORTANT_KENNY" ]; then
    echo "⚠️ **Belangrijke berichten:**" >> "$LOG_FILE"
    echo '```' >> "$LOG_FILE"
    echo "$IMPORTANT_KENNY" >> "$LOG_FILE"
    echo '```' >> "$LOG_FILE"
    ALERT_FOUND=true
else
    echo "Geen urgente berichten." >> "$LOG_FILE"
fi

echo "" >> "$LOG_FILE"

# Output voor ClawdBot
if [ "$ALERT_FOUND" = true ]; then
    echo "ALERT"
else
    echo "OK"
fi
