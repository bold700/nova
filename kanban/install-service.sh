#!/bin/bash
# Installeert Nova Kanban als achtergrondservice die automatisch start bij boot

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLIST_NAME="com.nova.kanban.plist"
PLIST_SRC="$SCRIPT_DIR/$PLIST_NAME"
PLIST_DST="$HOME/Library/LaunchAgents/$PLIST_NAME"

echo "🎯 Nova Kanban Service Installer"
echo "================================="
echo ""

# Check dependencies
echo "Checking dependencies..."
if ! command -v python3 &>/dev/null; then
    echo "❌ Python3 niet gevonden!"
    exit 1
fi

if ! command -v cloudflared &>/dev/null; then
    echo "⚠️  Cloudflared niet gevonden, installeren..."
    brew install cloudflared
fi

if ! python3 -c "import flask" 2>/dev/null; then
    echo "⚠️  Flask niet gevonden, installeren..."
    pip3 install flask flask-cors
fi

echo "✅ Dependencies OK"
echo ""

# Stop bestaande service als die draait
if launchctl list | grep -q "com.nova.kanban"; then
    echo "Stopping existing service..."
    launchctl unload "$PLIST_DST" 2>/dev/null
fi

# Kopieer plist naar LaunchAgents
echo "Installing service..."
mkdir -p "$HOME/Library/LaunchAgents"
cp "$PLIST_SRC" "$PLIST_DST"

# Start service
echo "Starting service..."
launchctl load "$PLIST_DST"

sleep 3

# Check status
if launchctl list | grep -q "com.nova.kanban"; then
    echo ""
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║  ✅ Nova Kanban Service geïnstalleerd!                    ║"
    echo "╠═══════════════════════════════════════════════════════════╣"
    echo "║  • Start automatisch bij boot                             ║"
    echo "║  • Herstart automatisch bij crashes                       ║"
    echo "║  • Tunnel URL: kanban/TUNNEL-URL.txt                      ║"
    echo "╠═══════════════════════════════════════════════════════════╣"
    echo "║  Commando's:                                              ║"
    echo "║  • Stop:    launchctl unload ~/Library/LaunchAgents/$PLIST_NAME"
    echo "║  • Start:   launchctl load ~/Library/LaunchAgents/$PLIST_NAME"
    echo "║  • Logs:    tail -f kanban/supervisor.log                 ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
else
    echo "❌ Service kon niet starten. Check logs:"
    echo "   cat $SCRIPT_DIR/launchd-stderr.log"
fi
