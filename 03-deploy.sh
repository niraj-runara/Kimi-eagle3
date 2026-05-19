#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="${ROOT_DIR}/.venv"
MODEL_DIR="${MODEL_DIR:-${ROOT_DIR}/models/kimi-k2.5-eagle3}"

HOST="${HOST:-0.0.0.0}"
PORT="${PORT:-30000}"

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
  --mem-fraction-static 0.75 \
  --host "${HOST}" \
  --port "${PORT}"
