#!/usr/bin/env bash
set -euo pipefail

# OpenClaw + lokale Ollama setup script
# Draait OpenClaw volledig lokaal zonder cloud API keys

OLLAMA_MODEL="${OLLAMA_MODEL:-qwen2.5:7b}"
OLLAMA_EMBED_MODEL="${OLLAMA_EMBED_MODEL:-nomic-embed-text}"
OLLAMA_BASE_URL="${OLLAMA_BASE_URL:-http://127.0.0.1:11434}"
WORKSPACE="${WORKSPACE:-$(pwd)}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

check_node() {
  if ! command -v node &>/dev/null; then
    error "Node.js niet gevonden. Installeer Node 22+ via: https://nodejs.org/"
  fi
  local ver
  ver=$(node -v | sed 's/v//' | cut -d. -f1)
  if [ "$ver" -lt 22 ]; then
    error "Node.js $ver gevonden, maar 22+ is vereist. Update Node.js."
  fi
  info "Node.js $(node -v) gevonden"
}

install_ollama() {
  if command -v ollama &>/dev/null; then
    info "Ollama al geinstalleerd: $(ollama --version 2>/dev/null || echo 'versie onbekend')"
    return
  fi
  info "Ollama installeren..."
  if ! command -v zstd &>/dev/null; then
    warn "zstd niet gevonden, installeren..."
    sudo apt-get update -qq && sudo apt-get install -y -qq zstd
  fi
  curl -fsSL https://ollama.com/install.sh | sh
  info "Ollama geinstalleerd"
}

start_ollama() {
  if curl -sf "$OLLAMA_BASE_URL/api/tags" &>/dev/null; then
    info "Ollama draait al op $OLLAMA_BASE_URL"
    return
  fi
  info "Ollama starten..."
  ollama serve &>/tmp/ollama-setup.log &
  local retries=10
  while [ $retries -gt 0 ]; do
    if curl -sf "$OLLAMA_BASE_URL/api/tags" &>/dev/null; then
      info "Ollama gestart"
      return
    fi
    sleep 2
    retries=$((retries - 1))
  done
  error "Kan Ollama niet starten. Check /tmp/ollama-setup.log"
}

pull_models() {
  info "Model pullen: $OLLAMA_MODEL"
  ollama pull "$OLLAMA_MODEL"

  info "Embedding model pullen: $OLLAMA_EMBED_MODEL"
  ollama pull "$OLLAMA_EMBED_MODEL"

  info "Beschikbare modellen:"
  ollama list
}

install_openclaw() {
  if command -v openclaw &>/dev/null; then
    info "OpenClaw al geinstalleerd: $(openclaw --version 2>/dev/null)"
    read -rp "Opnieuw installeren? (j/n) " reply
    if [[ "$reply" =~ ^[jJyY]$ ]]; then
      npm install -g openclaw@latest
    fi
  else
    info "OpenClaw installeren..."
    npm install -g openclaw@latest
  fi
  info "OpenClaw $(openclaw --version) klaar"
}

configure_openclaw() {
  info "OpenClaw configureren met Ollama..."
  openclaw onboard --non-interactive \
    --auth-choice ollama \
    --custom-base-url "$OLLAMA_BASE_URL" \
    --custom-model-id "$OLLAMA_MODEL" \
    --accept-risk \
    --workspace "$WORKSPACE" \
    --skip-health

  openclaw config set agents.defaults.memorySearch.enabled false

  info "OpenClaw geconfigureerd"
  info "  Model:     ollama/$OLLAMA_MODEL"
  info "  Ollama:    $OLLAMA_BASE_URL"
  info "  Workspace: $WORKSPACE"
}

verify() {
  info "Verificatie..."
  echo ""
  openclaw models list
  echo ""
  info "OpenClaw doctor:"
  openclaw doctor || true
  echo ""
  info "Setup compleet!"
  echo ""
  echo "=== Volgende stappen ==="
  echo "  1. Start de gateway:    openclaw gateway run"
  echo "  2. Open het dashboard:  openclaw dashboard"
  echo "  3. Of start de daemon:  openclaw daemon install && openclaw daemon start"
  echo ""
  echo "=== Handige commando's ==="
  echo "  openclaw status          - Bekijk de status"
  echo "  openclaw models list     - Bekijk beschikbare modellen"
  echo "  openclaw logs --follow   - Volg de logs"
  echo "  ollama list              - Bekijk Ollama modellen"
  echo "  ollama ps                - Bekijk geladen modellen"
  echo ""
  echo "=== Model wisselen ==="
  echo "  ollama pull <model>                     - Download nieuw model"
  echo "  openclaw models set ollama/<model>       - Stel in als default"
  echo ""
}

main() {
  echo ""
  echo "  🦞 OpenClaw + Ollama Local Setup"
  echo "  ================================="
  echo "  Model:     $OLLAMA_MODEL"
  echo "  Embedding: $OLLAMA_EMBED_MODEL"
  echo "  Ollama:    $OLLAMA_BASE_URL"
  echo "  Workspace: $WORKSPACE"
  echo ""

  check_node
  install_ollama
  start_ollama
  pull_models
  install_openclaw
  configure_openclaw
  verify
}

main "$@"
