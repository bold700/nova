#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_DIR="${1:-/workspace}"
MODEL_ID="${OPENCLAW_OLLAMA_MODEL:-qwen2.5:3b}"
GATEWAY_PORT="${OPENCLAW_GATEWAY_PORT:-18789}"
CONFIG_DIR="${HOME}/.openclaw"
CONFIG_PATH="${CONFIG_DIR}/openclaw.json"
OLLAMA_LOG="${CONFIG_DIR}/ollama-serve.log"

require_cmd() {
  command -v "$1" >/dev/null 2>&1
}

ensure_zstd() {
  if require_cmd zstd; then
    return
  fi

  sudo apt-get update
  sudo apt-get install -y zstd
}

ensure_openclaw() {
  if require_cmd openclaw; then
    return
  fi

  npm install -g openclaw@latest
}

ensure_ollama() {
  if require_cmd ollama; then
    return
  fi

  curl -fsSL https://ollama.com/install.sh | sh
}

wait_for_ollama() {
  for _ in $(seq 1 30); do
    if curl -fsS http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
      return
    fi
    sleep 1
  done

  echo "Ollama startte niet op tijd." >&2
  exit 1
}

ensure_ollama_running() {
  mkdir -p "${CONFIG_DIR}"

  if curl -fsS http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
    return
  fi

  nohup ollama serve >"${OLLAMA_LOG}" 2>&1 &
  wait_for_ollama
}

cleanup_heavy_default_model() {
  if [[ "${MODEL_ID}" == "glm-4.7-flash" ]]; then
    return
  fi

  if ollama list | rg '^glm-4\.7-flash(:latest)?\s' >/dev/null 2>&1; then
    ollama rm glm-4.7-flash >/dev/null 2>&1 || true
  fi
}

write_config() {
  mkdir -p "${CONFIG_DIR}/agents/main/sessions"

  export WORKSPACE_DIR MODEL_ID GATEWAY_PORT CONFIG_PATH
  python3 <<'PY'
import json
import os
import secrets
from pathlib import Path

config_path = Path(os.environ["CONFIG_PATH"])
config = {
    "models": {
        "mode": "merge",
        "providers": {
            "ollama": {
                "baseUrl": "http://127.0.0.1:11434",
                "apiKey": "ollama-local",
                "api": "ollama",
                "models": [
                    {
                        "id": os.environ["MODEL_ID"],
                        "name": os.environ["MODEL_ID"],
                        "reasoning": False,
                        "input": ["text"],
                        "cost": {
                            "input": 0,
                            "output": 0,
                            "cacheRead": 0,
                            "cacheWrite": 0,
                        },
                        "contextWindow": 32768,
                        "maxTokens": 8192,
                    }
                ],
            }
        },
    },
    "agents": {
        "defaults": {
            "model": {"primary": f"ollama/{os.environ['MODEL_ID']}"},
            "models": {f"ollama/{os.environ['MODEL_ID']}": {}},
            "workspace": os.environ["WORKSPACE_DIR"],
        }
    },
    "tools": {"profile": "coding"},
    "commands": {
        "native": "auto",
        "nativeSkills": "auto",
        "restart": True,
        "ownerDisplay": "raw",
    },
    "session": {"dmScope": "per-channel-peer"},
    "gateway": {
        "port": int(os.environ["GATEWAY_PORT"]),
        "mode": "local",
        "bind": "loopback",
        "auth": {
            "mode": "token",
            "token": secrets.token_hex(24),
        },
        "tailscale": {
            "mode": "off",
            "resetOnExit": False,
        },
    },
    "plugins": {"entries": {"ollama": {"enabled": True}}},
}

config_path.write_text(json.dumps(config, indent=2) + "\n", encoding="utf-8")
PY
}

main() {
  ensure_zstd
  ensure_openclaw
  ensure_ollama
  ensure_ollama_running
  ollama pull "${MODEL_ID}"
  cleanup_heavy_default_model
  write_config
  openclaw config validate >/dev/null

  echo "OpenClaw staat klaar met lokaal model: ${MODEL_ID}"
  echo "Config: ${CONFIG_PATH}"
}

main "$@"
