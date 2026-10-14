#!/usr/bin/env bash
set -euo pipefail

SERVER="/home/aryan/Documents/sd-master-1b0ba10-bin-Linux-Ubuntu-24.04-x86_64-vulkan/sd-server"
MODEL_DIR="/run/media/aryan/Ventoy/Local_Disk/1437-FILES/1437-AI/qwenimage2.1turbo"

exec "$SERVER" \
  --diffusion-model "$MODEL_DIR/Qwen-Image-2.1-Turbo-AD-Q4_K.gguf" \
  --vae "$MODEL_DIR/qwen_image_2.1_vae_bf16.safetensors" \
  --llm "$MODEL_DIR/Qwen3-VL-8B-Instruct-UD-Q4_K_XL.gguf" \
  --backend "diffusion=vulkan1,te=vulkan2,vae=vulkan3" \
  --prompt 'a neon sign that reads "OPEN LATE", rainy night' \
  --steps 8 \
  --cfg-scale 1.0 \
  --sampling-method euler \
  --sigmas '1.0,0.978453,0.95418,0.926626,0.89508,0.845148,0.704534,0.414568,0.0' \
  -W 1024 -H 1024 \
  --diffusion-fa --llm_vision "$MODEL_DIR/mmproj-BF16.gguf" --diffusion-fa --vae-tiling --vae-tile-size 16x128 --vae-tile-overlap 0.1 --preview proj --preview-interval 1
