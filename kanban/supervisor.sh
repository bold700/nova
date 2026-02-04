#!/bin/bash
# Nova Kanban Supervisor
# Houdt Kanban server + Cloudflare tunnel draaiende, herstart bij crashes

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="$SCRIPT_DIR/supervisor.log"
TUNNEL_URL_FILE="$SCRIPT_DIR/TUNNEL-URL.txt"
HEALTH_CHECK_INTERVAL=30  # seconden tussen health checks

# Kleuren voor logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$LOG_FILE"
}

cleanup() {
    log "${YELLOW}[SUPERVISOR]${NC} Afsluiten..."
    kill $KANBAN_PID 2>/dev/null
    kill $TUNNEL_PID 2>/dev/null
    exit 0
}

trap cleanup SIGINT SIGTERM

start_kanban() {
    log "${GREEN}[KANBAN]${NC} Server starten..."
    cd "$SCRIPT_DIR"
    python3 server.py >> "$LOG_FILE" 2>&1 &
    KANBAN_PID=$!
    sleep 2

    if kill -0 $KANBAN_PID 2>/dev/null; then
        log "${GREEN}[KANBAN]${NC} Draait op PID $KANBAN_PID"
    else
        log "${RED}[KANBAN]${NC} Kon niet starten!"
        return 1
    fi
}

start_tunnel() {
    log "${GREEN}[TUNNEL]${NC} Cloudflare tunnel starten..."

    # Start tunnel en vang URL op
    cloudflared tunnel --url http://localhost:5555 2>&1 | while read line; do
        echo "$line" >> "$LOG_FILE"
        # Vang de tunnel URL op
        if [[ "$line" == *"trycloudflare.com"* ]]; then
            URL=$(echo "$line" | grep -oE 'https://[a-z-]+\.trycloudflare\.com')
            if [ -n "$URL" ]; then
                echo "$URL" > "$TUNNEL_URL_FILE"
                log "${GREEN}[TUNNEL]${NC} URL: $URL"
            fi
        fi
    done &
    TUNNEL_PID=$!
    sleep 5

    if kill -0 $TUNNEL_PID 2>/dev/null; then
        log "${GREEN}[TUNNEL]${NC} Draait op PID $TUNNEL_PID"
    else
        log "${RED}[TUNNEL]${NC} Kon niet starten!"
        return 1
    fi
}

check_kanban_health() {
    # Check of de server reageert
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:5555/api/tasks | grep -q "200"; then
        return 0
    else
        return 1
    fi
}

check_process() {
    kill -0 $1 2>/dev/null
    return $?
}

# =============================================================================
# Main
# =============================================================================

log "${GREEN}[SUPERVISOR]${NC} ======================================"
log "${GREEN}[SUPERVISOR]${NC} Nova Kanban Supervisor gestart"
log "${GREEN}[SUPERVISOR]${NC} ======================================"

# Check of Flask geïnstalleerd is
if ! python3 -c "import flask" 2>/dev/null; then
    log "${YELLOW}[SUPERVISOR]${NC} Flask installeren..."
    pip3 install flask flask-cors
fi

# Start services
start_kanban
start_tunnel

# Toon info
IP=$(ipconfig getifaddr en0 2>/dev/null)
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  🎯 Nova Kanban Supervisor                                    ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo "║  Lokaal:  http://localhost:5555                               ║"
echo "║  LAN:     http://$IP:5555                            ║"
echo "║  Tunnel:  $(cat "$TUNNEL_URL_FILE" 2>/dev/null || echo 'Wordt geladen...')  ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo "║  ✓ Auto-restart bij crashes                                   ║"
echo "║  ✓ Health checks elke ${HEALTH_CHECK_INTERVAL}s                                    ║"
echo "║  Log: $LOG_FILE                                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "Druk Ctrl+C om te stoppen"
echo ""

# Monitor loop
KANBAN_RESTARTS=0
TUNNEL_RESTARTS=0

while true; do
    sleep $HEALTH_CHECK_INTERVAL

    # Check Kanban server
    if ! check_process $KANBAN_PID; then
        log "${RED}[KANBAN]${NC} Crashed! Herstarten... (restart #$((++KANBAN_RESTARTS)))"
        start_kanban
    elif ! check_kanban_health; then
        log "${YELLOW}[KANBAN]${NC} Reageert niet, herstarten... (restart #$((++KANBAN_RESTARTS)))"
        kill $KANBAN_PID 2>/dev/null
        sleep 2
        start_kanban
    fi

    # Check Tunnel
    if ! check_process $TUNNEL_PID; then
        log "${RED}[TUNNEL]${NC} Crashed! Herstarten... (restart #$((++TUNNEL_RESTARTS)))"
        start_tunnel
    fi

    # Elke 10 checks, log status
    if [ $((SECONDS % 300)) -lt $HEALTH_CHECK_INTERVAL ]; then
        log "${GREEN}[SUPERVISOR]${NC} Status OK - Kanban restarts: $KANBAN_RESTARTS, Tunnel restarts: $TUNNEL_RESTARTS"
    fi
done
