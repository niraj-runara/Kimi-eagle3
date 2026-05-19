# kimi-k2.5-eagle3 on SGLang

Scripts to install SGLang, download [lightseekorg/kimi-k2.5-eagle3](https://huggingface.co/lightseekorg/kimi-k2.5-eagle3), and serve it on a single NVIDIA GPU (e.g. 1× RTX 3060).

## Requirements

- **OS**: Linux (recommended for NVIDIA + CUDA)
- **GPU**: NVIDIA with [CUDA 12.0+](https://developer.nvidia.com/cuda-downloads) and a working driver (`nvidia-smi` works)
- **Python**: 3.10 or newer
- **Disk**: ~10 GB free for the model weights (3B params, BF16/F16)
- **RAM**: 16 GB+ recommended

## Quick start

Run these in order from the project root:

```bash
chmod +x 01-install.sh 02-download-models.sh 03-deploy.sh

./01-install.sh
./02-download-models.sh
./03-deploy.sh
```

The server listens on **http://0.0.0.0:30000** (OpenAI-compatible API at `/v1`).

## What each script does

| Script | Purpose |
|--------|---------|
| `01-install.sh` | Creates `.venv` and installs SGLang (≥0.5.8) and the `hf` CLI (`huggingface_hub`) |
| `02-download-models.sh` | Runs `hf download` into `models/kimi-k2.5-eagle3/` (no login step) |
| `03-deploy.sh` | Starts `sglang serve` with that local path on GPU 0 |

## Test the server

In another terminal (with the server still running):

```bash
curl http://127.0.0.1:30000/v1/models
```

Chat completion example:

```bash
curl http://127.0.0.1:30000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "kimi-k2.5-eagle3",
    "messages": [{"role": "user", "content": "Hello"}],
    "max_tokens": 64
  }'
```

Or with Python:

```bash
source .venv/bin/activate
pip install openai

python - <<'EOF'
from openai import OpenAI

client = OpenAI(base_url="http://127.0.0.1:30000/v1", api_key="EMPTY")
r = client.chat.completions.create(
    model="kimi-k2.5-eagle3",
    messages=[{"role": "user", "content": "Say hi in one sentence."}],
    max_tokens=64,
)
print(r.choices[0].message.content)
EOF
```

## Options

**Change host or port** when deploying:

```bash
HOST=127.0.0.1 PORT=8080 ./03-deploy.sh
```

**Use a different GPU** (multi-GPU machine):

```bash
CUDA_VISIBLE_DEVICES=1 ./03-deploy.sh
```


## About this model

[kimi-k2.5-eagle3](https://huggingface.co/lightseekorg/kimi-k2.5-eagle3) is an **EAGLE3 draft model** (~3B parameters) trained to speed up [moonshotai/Kimi-K2.5](https://huggingface.co/moonshotai/Kimi-K2.5) via speculative decoding. These scripts serve it **on its own** with SGLang for local testing; for the intended speedup setup (draft + full Kimi-K2.5), see the [model card](https://huggingface.co/lightseekorg/kimi-k2.5-eagle3#quick-start).

## Layout

```
.
├── 01-install.sh
├── 02-download-models.sh
├── 03-deploy.sh
├── .venv/                 # created by 01-install.sh
└── models/
    └── kimi-k2.5-eagle3/  # created by 02-download-models.sh
```
