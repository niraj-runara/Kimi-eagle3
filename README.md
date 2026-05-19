# Moonlight 16B Instruct on SGLang — RTX 3090

Scripts to install SGLang, download [moonshotai/Moonlight-16B-A3B-Instruct](https://huggingface.co/moonshotai/Moonlight-16B-A3B-Instruct), and serve it on **1× NVIDIA RTX 3090 (24 GB VRAM)**.

## Requirements

- **GPU**: **NVIDIA RTX 3090** (24 GB VRAM), driver + CUDA 12+
- **OS**: Linux (recommended)
- **Python**: 3.10 or newer
- **Disk**: ~35 GB free for BF16 weights
- **PSU / cooling**: 3090 is ~350 W; ensure adequate power and airflow

16B MoE (~3B active per token). SGLang loads experts efficiently; 24 GB is enough for serving with the defaults below.

## Quick start

```bash
chmod +x 01-install.sh 02-download-models.sh 03-deploy.sh

./01-install.sh
./02-download-models.sh
./03-deploy.sh
```

Server: **http://0.0.0.0:30000** (`/v1` OpenAI-compatible API).

Defaults in `03-deploy.sh`: **8k context** (model max), **BF16**, **85% static memory**.

## What each script does

| Script | Purpose |
|--------|---------|
| `01-install.sh` | Creates `.venv`, installs SGLang and the `hf` CLI |
| `02-download-models.sh` | `hf download` → `models/Moonlight-16B-A3B-Instruct/` |
| `03-deploy.sh` | `sglang serve` on GPU 0 |

## Test the server

```bash
curl http://127.0.0.1:30000/v1/models
```

```bash
curl http://127.0.0.1:30000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "moonshotai/Moonlight-16B-A3B-Instruct",
    "messages": [{"role": "user", "content": "What is the capital of France?"}],
    "max_tokens": 256
  }'
```

## Options

```bash
HOST=127.0.0.1 PORT=8080 ./03-deploy.sh
CONTEXT_LENGTH=4096 MEM_FRACTION=0.80 ./03-deploy.sh   # if OOM
CUDA_VISIBLE_DEVICES=1 ./03-deploy.sh

MODEL_ID=moonshotai/Moonlight-16B-A3B-Instruct \
MODEL_DIR=/path/to/model \
./02-download-models.sh

MODEL_DIR=/path/to/model ./03-deploy.sh
```

## Reactivate later

```bash
source .venv/bin/activate
./03-deploy.sh
```

## Troubleshooting

| Problem | What to try |
|---------|-------------|
| `hf` not found | `./01-install.sh`, then `source .venv/bin/activate` |
| Download fails | Free disk space; re-run `./02-download-models.sh` |
| CUDA OOM | `CONTEXT_LENGTH=4096 MEM_FRACTION=0.75 ./03-deploy.sh` |
| Port in use | `PORT=30001 ./03-deploy.sh` |

## About this model

[moonshotai/Moonlight-16B-A3B-Instruct](https://huggingface.co/moonshotai/Moonlight-16B-A3B-Instruct) is Moonshot’s **16B MoE instruct** model (~3B active params, **8K** context, BF16). Same architecture family as DeepSeek-V3; supported by SGLang per the [model card](https://huggingface.co/moonshotai/Moonlight-16B-A3B-Instruct).

## Layout

```
.
├── 01-install.sh
├── 02-download-models.sh
├── 03-deploy.sh
├── .venv/
└── models/
    └── Moonlight-16B-A3B-Instruct/
```
