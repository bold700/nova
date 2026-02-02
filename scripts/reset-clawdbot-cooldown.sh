#!/bin/bash
# Reset clawdbot API cooldown (na rate limit 429) en/of Telegram-sessie (na context overflow)
# Gebruik als: ./scripts/reset-clawdbot-cooldown.sh [--session]

AUTH_FILE="$HOME/.clawdbot/agents/main/agent/auth-profiles.json"
SESSIONS_DIR="$HOME/.clawdbot/agents/main/sessions"

# Telegram-sessie resetten (verwijdert 439+ regels geschiedenis → voorkomt context overflow)
reset_telegram_session() {
  local session_file="$SESSIONS_DIR/c7179d4a-9deb-433b-83e8-1acf2b129444.jsonl"
  if [[ -f "$session_file" ]]; then
    head -1 "$session_file" > "${session_file}.tmp" && mv "${session_file}.tmp" "$session_file"
    echo "Telegram-sessie gereset (geschiedenis gewist)."
  else
    echo "Telegram-sessiebestand niet gevonden."
  fi
}

if [[ "$1" == "--session" ]]; then
  reset_telegram_session
  exit 0
fi

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
  echo "Cooldown gereset. Probeer opnieuw."
  echo "Tip: bij context overflow, run: $0 --session"
else
  echo "jq niet geïnstalleerd. Installeer met: brew install jq"
  echo "Of edit handmatig: $AUTH_FILE"
  echo "Zet cooldownUntil en lastFailureAt op null, errorCount op 0, failureCounts op {}"
  exit 1
fi
