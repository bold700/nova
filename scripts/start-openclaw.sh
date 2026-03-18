#!/usr/bin/env bash
# Start OpenClaw met lokale Ollama
# Gebruik: ./scripts/start-openclaw.sh

set -e

OLLAMA_PORT=11434
GATEWAY_PORT=18789
LOG_DIR=/tmp/openclaw-logs
MODEL="qwen2.5:7b"

mkdir -p "$LOG_DIR"

echo "=== OpenClaw + Lokale Ollama Startup ==="

# --- Geheugencache vrijmaken zodat het model laadt ---
if [ -w /proc/sys/vm/drop_caches ]; then
  echo "[0/3] Geheugencache vrijmaken..."
  echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1 || true
fi

# --- Ollama starten als die nog niet draait ---
if ! curl -s "http://localhost:${OLLAMA_PORT}/api/version" > /dev/null 2>&1; then
  echo "[1/3] Ollama starten..."
  ollama serve > "$LOG_DIR/ollama.log" 2>&1 &
  OLLAMA_PID=$!
  echo "      PID: $OLLAMA_PID"
  for i in $(seq 1 20); do
    if curl -s "http://localhost:${OLLAMA_PORT}/api/version" > /dev/null 2>&1; then
      echo "      Ollama klaar."
      break
    fi
    sleep 1
  done
else
  echo "[1/3] Ollama draait al."
fi

# --- Model checken ---
echo "[2/3] Model controleren: $MODEL"
if ! ollama list 2>/dev/null | grep -q "${MODEL%%:*}"; then
  echo "      Model niet gevonden, downloaden..."
  ollama pull "$MODEL"
else
  echo "      Model aanwezig: $MODEL"
fi

# --- OpenClaw gateway starten ---
if ! curl -s "http://localhost:${GATEWAY_PORT}/" > /dev/null 2>&1; then
  echo "[3/3] OpenClaw gateway starten..."
  openclaw gateway run > "$LOG_DIR/openclaw-gateway.log" 2>&1 &
  GW_PID=$!
  echo "      PID: $GW_PID"
  sleep 4
  if curl -s "http://localhost:${GATEWAY_PORT}/" > /dev/null 2>&1; then
    echo "      Gateway klaar."
  else
    echo "      WAARSCHUWING: Gateway nog niet bereikbaar. Log: $LOG_DIR/openclaw-gateway.log"
  fi
else
  echo "[3/3] OpenClaw gateway draait al op poort $GATEWAY_PORT."
fi

echo ""
echo "=== Klaar! ==="
echo "   Dashboard:  http://localhost:${GATEWAY_PORT}/"
echo "   Model:      ollama/$MODEL"
echo "   Workspace:  /workspace"
echo "   Logs:       $LOG_DIR/"
echo ""
echo "Model testen:   curl -s http://localhost:${OLLAMA_PORT}/api/generate \\"
echo "                  -d '{\"model\":\"${MODEL}\",\"prompt\":\"Zeg hallo\",\"stream\":false}'"
echo ""
echo "Alles stoppen:  pkill ollama; pkill -f 'openclaw gateway'"
