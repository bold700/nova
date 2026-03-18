#!/usr/bin/env bash
set -euo pipefail

# Clean install OpenClaw and force local Ollama usage.
# Default model is lightweight for low-memory machines.

MODEL="${1:-qwen2.5:0.5b}"
OLLAMA_BASE_URL="${OLLAMA_BASE_URL:-http://127.0.0.1:11434}"
OPENCLAW_DIR="${HOME}/.openclaw"
BACKUP_DIR="${HOME}/.openclaw.backup-$(date +%Y%m%d-%H%M%S)"

log() {
  printf "\n[openclaw-install] %s\n" "$1"
}

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

ensure_zstd() {
  if have_cmd zstd; then
    return
  fi

  if have_cmd apt-get; then
    log "zstd ontbreekt, installeren via apt-get"
    sudo apt-get update
    sudo apt-get install -y zstd
    return
  fi

  echo "FOUT: zstd ontbreekt en kon niet automatisch geïnstalleerd worden."
  echo "Installeer zstd handmatig en run dit script opnieuw."
  exit 1
}

install_openclaw() {
  log "OpenClaw clean installeren (npm global)"
  npm uninstall -g openclaw >/dev/null 2>&1 || true
  npm install -g openclaw@latest
}

install_ollama() {
  log "Ollama installeren/updaten"
  ensure_zstd
  curl -fsSL https://ollama.com/install.sh | sh
}

start_ollama_if_needed() {
  if curl -fsS "${OLLAMA_BASE_URL}/api/tags" >/dev/null 2>&1; then
    log "Ollama draait al op ${OLLAMA_BASE_URL}"
    return
  fi

  log "Ollama starten"
  nohup ollama serve >/tmp/ollama-serve.log 2>&1 &
  sleep 2

  if ! curl -fsS "${OLLAMA_BASE_URL}/api/tags" >/dev/null 2>&1; then
    echo "FOUT: Ollama API is niet bereikbaar op ${OLLAMA_BASE_URL}"
    echo "Check /tmp/ollama-serve.log voor details."
    exit 1
  fi
}

backup_existing_openclaw_state() {
  if [[ -d "${OPENCLAW_DIR}" ]]; then
    log "Bestaande OpenClaw state back-uppen naar ${BACKUP_DIR}"
    mv "${OPENCLAW_DIR}" "${BACKUP_DIR}"
  fi
}

configure_openclaw_for_local_ollama() {
  log "OpenClaw non-interactive onboard (lokale modus, zonder daemon)"
  openclaw onboard \
    --non-interactive \
    --accept-risk \
    --mode local \
    --auth-choice ollama \
    --no-install-daemon \
    --skip-channels \
    --skip-skills \
    --skip-ui \
    --skip-search \
    --skip-health

  log "Forceer native lokale Ollama provider-configuratie"
  openclaw config set models.providers.ollama.baseUrl "${OLLAMA_BASE_URL}"
  openclaw config set models.providers.ollama.apiKey "OLLAMA_API_KEY"
  openclaw config set models.providers.ollama.api "ollama"

  log "Model pullen: ${MODEL}"
  ollama pull "${MODEL}"

  log "Standaardmodel instellen: ollama/${MODEL}"
  openclaw models set "ollama/${MODEL}"
}

start_gateway_if_needed() {
  if openclaw gateway health >/dev/null 2>&1; then
    log "OpenClaw gateway draait al"
    return
  fi

  # Bij clean install kan nog een oude gateway draaien met oude config/token.
  if pgrep -f "openclaw-gateway|openclaw gateway run" >/dev/null 2>&1; then
    log "Oude gateway processen gevonden, stoppen"
    pkill -f "openclaw-gateway|openclaw gateway run" || true
    sleep 2
  fi

  log "OpenClaw gateway starten"
  nohup openclaw gateway run >/tmp/openclaw-gateway.log 2>&1 &

  for _ in $(seq 1 15); do
    if openclaw gateway health >/dev/null 2>&1; then
      return
    fi
    sleep 1
  done

  echo "FOUT: OpenClaw gateway is niet bereikbaar."
  echo "Check /tmp/openclaw-gateway.log voor details."
  exit 1
}

validate_install() {
  log "Validatie: models status + Ollama models"
  openclaw models status --probe-provider ollama
  ollama list

  log "Smoke test: agent turn via gateway"
  openclaw agent --agent main --message "Zeg alleen: OK" --json >/tmp/openclaw-smoke.json
  rg -n "\"status\": \"ok\"|\"provider\": \"ollama\"|\"model\": \"${MODEL}\"" /tmp/openclaw-smoke.json
}

main() {
  log "Start clean install OpenClaw + lokale Ollama"
  install_openclaw
  install_ollama
  start_ollama_if_needed
  backup_existing_openclaw_state
  configure_openclaw_for_local_ollama
  start_gateway_if_needed
  validate_install

  log "KLAAR: OpenClaw gebruikt lokale Ollama (${MODEL})"
  echo "Config: ${HOME}/.openclaw/openclaw.json"
  echo "Gateway log: /tmp/openclaw-gateway.log"
  echo "Ollama log: /tmp/ollama-serve.log"
}

main "$@"
