#!/bin/bash
# Nova Kanban - Start Script

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Check of Flask geïnstalleerd is
if ! python3 -c "import flask" 2>/dev/null; then
    echo "Flask niet gevonden. Installeren..."
    pip3 install flask flask-cors
fi

# Toon IP adres voor mobiele toegang
IP=$(ipconfig getifaddr en0 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}')
if [ -n "$IP" ]; then
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║  📱 Mobiel: http://$IP:5555                      ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo ""
fi

# Start server
python3 server.py
