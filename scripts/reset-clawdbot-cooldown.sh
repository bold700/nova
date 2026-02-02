#!/bin/bash
# Reset clawdbot API cooldown (na rate limit 429)
# Gebruik als: ./scripts/reset-clawdbot-cooldown.sh

AUTH_FILE="$HOME/.clawdbot/agents/main/agent/auth-profiles.json"

if [[ ! -f "$AUTH_FILE" ]]; then
  echo "Bestand niet gevonden: $AUTH_FILE"
  exit 1
fi

# Reset cooldown met jq
if command -v jq &>/dev/null; then
  jq '
    if .usageStats then
      .usageStats |= with_entries(
        .value |= . + { errorCount: 0, lastFailureAt: null, failureCounts: {}, cooldownUntil: null }
      )
    else . end
  ' "$AUTH_FILE" > "${AUTH_FILE}.tmp" && mv "${AUTH_FILE}.tmp" "$AUTH_FILE"
  echo "Cooldown gereset. Probeer opnieuw in de webchat."
else
  echo "jq niet geïnstalleerd. Installeer met: brew install jq"
  echo "Of edit handmatig: $AUTH_FILE"
  echo "Zet cooldownUntil en lastFailureAt op null, errorCount op 0, failureCounts op {}"
  exit 1
fi
