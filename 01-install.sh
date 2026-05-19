#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="${ROOT_DIR}/.venv"
PYTHON="${PYTHON:-python3}"

if ! command -v "${PYTHON}" >/dev/null 2>&1; then
  echo "ERROR: ${PYTHON} not found." >&2
  exit 1
fi

"${PYTHON}" -m venv "${VENV_DIR}"
# shellcheck source=/dev/null
source "${VENV_DIR}/bin/activate"

python -m pip install --upgrade pip wheel setuptools
pip install "sglang>=0.5.8" "huggingface_hub[cli]>=0.26.0" "hf_transfer>=0.1.8"

export HF_HUB_ENABLE_HF_TRANSFER=1

echo "Done. Next: ./02-download-models.sh"
