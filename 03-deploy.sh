#!/usr/bin/env bash
# Serve moonshotai/Moonlight-16B-A3B-Instruct on 1× RTX A6000 (48 GB VRAM).
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="${ROOT_DIR}/.venv"
MODEL_DIR="${MODEL_DIR:-${ROOT_DIR}/models/Moonlight-16B-A3B-Instruct}"

HOST="${HOST:-0.0.0.0}"
PORT="${PORT:-30000}"
CONTEXT_LENGTH="${CONTEXT_LENGTH:-8192}"
MEM_FRACTION="${MEM_FRACTION:-0.90}"

if [[ ! -f "${VENV_DIR}/bin/activate" ]]; then
  echo "ERROR: Run ./01-install.sh first." >&2
  exit 1
fi

if [[ ! -d "${MODEL_DIR}" ]]; then
  echo "ERROR: Model not found at ${MODEL_DIR}. Run ./02-download-models.sh first." >&2
  exit 1
fi

# shellcheck source=/dev/null
source "${VENV_DIR}/bin/activate"

export CUDA_VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES:-0}"

exec sglang serve \
  --model-path "${MODEL_DIR}" \
  --tp 1 \
  --trust-remote-code \
  --dtype bfloat16 \
  --mem-fraction-static "${MEM_FRACTION}" \
  --context-length "${CONTEXT_LENGTH}" \
  --host "${HOST}" \
  --port "${PORT}"
