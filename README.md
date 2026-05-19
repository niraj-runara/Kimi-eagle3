# Moonlight 16B (4-bit) on SGLang — RTX 3090

Scripts to install SGLang, download [slowfastai/Moonlight-16B-A3B-Instruct-bnb-4bit](https://huggingface.co/slowfastai/Moonlight-16B-A3B-Instruct-bnb-4bit), and serve it on **1× NVIDIA RTX 3090 (24 GB VRAM)**.

## Requirements

- **GPU**: **NVIDIA RTX 3090** (24 GB VRAM), driver + CUDA 12+
- **OS**: Linux (recommended)
- **Python**: 3.10 or newer
- **Disk**: ~15 GB free for the 4-bit weights
- **PSU / cooling**: 3090 is ~350 W; ensure adequate power and airflow

This model uses ~8–10 GB for weights; on a 3090 the rest of VRAM is available for KV cache and longer context.

## Quick start

Run these in order from the project root:

```bash
chmod +x 01-install.sh 02-download-models.sh 03-deploy.sh

./01-install.sh
./02-download-models.sh
./03-deploy.sh
```

The server listens on **http://0.0.0.0:30000** (OpenAI-compatible API at `/v1`).

Default deploy settings (`03-deploy.sh`): **8k context**, **90% static memory** for KV cache — comfortable on 24 GB.

## What each script does

| Script | Purpose |
|--------|---------|
| `01-install.sh` | Creates `.venv` and installs SGLang, `bitsandbytes`, and the `hf` CLI |
| `02-download-models.sh` | Runs `hf download` into `models/Moonlight-16B-A3B-Instruct-bnb-4bit/` |
| `03-deploy.sh` | Starts `sglang serve` on GPU 0 (3090-tuned defaults) |

## Test the server

```bash
curl http://127.0.0.1:30000/v1/models
```

```bash
curl http://127.0.0.1:30000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "slowfastai/Moonlight-16B-A3B-Instruct-bnb-4bit",
    "messages": [{"role": "user", "content": "What is the capital of France?"}],
    "max_tokens": 256
  }'
```

## Options

```bash
HOST=127.0.0.1 PORT=8080 ./03-deploy.sh

# Longer context (try 16384 if you have headroom; back off if OOM)
CONTEXT_LENGTH=16384 ./03-deploy.sh

# Another GPU in a multi-GPU box
CUDA_VISIBLE_DEVICES=1 ./03-deploy.sh

MODEL_ID=slowfastai/Moonlight-16B-A3B-Instruct-bnb-4bit \
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
| `hf` not found | Run `./01-install.sh`, then `source .venv/bin/activate` |
| Download fails | Check disk space and network; re-run `./02-download-models.sh` |
| CUDA OOM | Lower `CONTEXT_LENGTH` or `MEM_FRACTION=0.85 ./03-deploy.sh` |
| Port in use | `PORT=30001 ./03-deploy.sh` |
| Slow first load | Normal; 3090 is loading ~15 GB from disk into VRAM |

## About this model

[slowfastai/Moonlight-16B-A3B-Instruct-bnb-4bit](https://huggingface.co/slowfastai/Moonlight-16B-A3B-Instruct-bnb-4bit) is a **4-bit bitsandbytes** quant of [moonshotai/Moonlight-16B-A3B-Instruct](https://huggingface.co/moonshotai/Moonlight-16B-A3B-Instruct) (16B MoE, ~3B active). The authors note these weights are for **personal testing only** — use with caution.

## Layout

```
.
├── 01-install.sh
├── 02-download-models.sh
├── 03-deploy.sh
├── .venv/
└── models/
    └── Moonlight-16B-A3B-Instruct-bnb-4bit/
```
