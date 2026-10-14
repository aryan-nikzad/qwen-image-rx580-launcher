#!/usr/bin/env bash
set -euo pipefail

BASE="$HOME/Documents/llama-b11556-bin-ubuntu-vulkan-x64"
DIR="/run/media/aryan/Ventoy/Local_Disk/1437-FILES/1437-AI/qwenimage2.1turbo/PE"
MODEL="$DIR/pe_t2i_heretic-Q4_K_M.gguf"

if [[ ! -f "$MODEL" || ! -f "$DIR/system_prompt.txt" ]]; then
    echo "Error: model or system_prompt.txt not found."
    exit 1
fi

export GGML_VK_VISIBLE_DEVICES=2

exec "$BASE/llama-server" \
    --model "$MODEL" \
    --host 127.0.0.1 \
    --port 8081 \
    --jinja \
    --load-mode none -ngl 999
