#!/usr/bin/env bash
# Download lightseekorg/kimi-k2.5-eagle3 weights separately from serving.
#
# Defaults to a repo-local model directory so 03-deploy.sh can serve from disk
# without implicitly downloading from Hugging Face.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="${ROOT_DIR}/.venv"
MODEL_ID="${MODEL_ID:-lightseekorg/kimi-k2.5-eagle3}"
MODEL_DIR="${MODEL_DIR:-${ROOT_DIR}/models/kimi-k2.5-eagle3}"
REVISION="${REVISION:-}"

if [[ -f "${VENV_DIR}/bin/activate" ]]; then
  # shellcheck source=/dev/null
  source "${VENV_DIR}/bin/activate"
fi

if [[ ! -x "$(command -v hf)" ]]; then
  echo "hf (Hugging Face CLI) not found. Run ./01-install.sh first." >&2
  exit 1
fi

mkdir -p "${MODEL_DIR}"

DOWNLOAD=(hf download "${MODEL_ID}" --local-dir "${MODEL_DIR}")
if [[ -n "${REVISION}" ]]; then
  DOWNLOAD+=(--revision "${REVISION}")
fi

echo "Downloading ${MODEL_ID} to ${MODEL_DIR}"
echo "Command: ${DOWNLOAD[*]}"
"${DOWNLOAD[@]}"

echo ""
echo "Done. Serve from the local copy with:"
echo "  MODEL_DIR=${MODEL_DIR} ./03-deploy.sh"
