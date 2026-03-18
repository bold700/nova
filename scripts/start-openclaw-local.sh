#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="${HOME}/.openclaw"
OLLAMA_LOG="${CONFIG_DIR}/ollama-serve.log"

mkdir -p "${CONFIG_DIR}"

if ! curl -fsS http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
  nohup ollama serve >"${OLLAMA_LOG}" 2>&1 &

  for _ in $(seq 1 30); do
    if curl -fsS http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
      break
    fi
    sleep 1
  done
fi

exec openclaw gateway --force "$@"
