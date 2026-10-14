# Qwen Image 2.1 Turbo on Multi-GPU AMD RX 580

A practical `stable-diffusion.cpp` launcher configuration for running **Qwen Image 2.1 Turbo (AD Q4_K)** on Linux with multiple AMD RX 580 GPUs using Vulkan.

The included launcher uses a low-step Turbo sampling configuration, Flash Attention, VAE tiling, and projection previews.

## What's configured

- **Diffusion model:** `Qwen-Image-2.1-Turbo-AD-Q4_K.gguf`
- **Text/vision encoder:** `Qwen3-VL-8B-Instruct-UD-Q4_K_XL.gguf`
- **VAE:** BF16 Qwen Image 2.1 VAE
- **Vulkan backend mapping:** diffusion on `vulkan1`, text encoder on `vulkan2`, VAE on `vulkan3`
- **Sampling:** 8 steps, Euler, CFG 1.0, explicit sigma schedule
- **Memory/performance options:** Flash Attention and VAE tiling (`16x128`, overlap `0.1`)
- **Preview:** `proj` every step

## Requirements

- Linux with working AMDGPU/Mesa Vulkan drivers
- A multi-GPU AMD RX 580 setup (or another setup with compatible Vulkan devices)
- A working Vulkan build of [stable-diffusion.cpp](https://github.com/leejet/stable-diffusion.cpp) that supports the options used in the script and Qwen Image 2.1
- The model, VAE, text encoder, and vision projection files listed above

Support for specific flags and model combinations depends on the `stable-diffusion.cpp` build/version. Confirm available options with `sd-server --help` if a flag is rejected.

## Setup

1. Download/build a compatible `stable-diffusion.cpp` Vulkan build and obtain the required model files separately.
2. Edit `SERVER` and `MODEL_DIR` at the top of `run-qwen-image-2.1-turbo.sh` to match your own paths.
3. Check that the filenames in the script match the files you downloaded.
4. Make the script executable and run it:

   ```bash
   chmod +x run-qwen-image-2.1-turbo.sh
   ./run-qwen-image-2.1-turbo.sh
   ```

The included paths are specific to the original author's machine and will need changing on other systems.

## Vulkan device mapping

The script explicitly assigns three backend roles:

```text
diffusion = vulkan1
text encoder = vulkan2
VAE = vulkan3
```

These are device indices as enumerated by the build, **not guaranteed physical GPU numbers**. Check the startup log to confirm which Vulkan device each index represents on your machine. This mapping does not itself split one model across GPUs or make each GPU render a separate section of the image.

## Notes

- `--preview proj` requests projection-based previews and does not require a separate TAESD model file when supported by the build.
- VAE tiling can reduce peak VAE memory use, with possible performance/quality trade-offs depending on the implementation.
- The launcher contains `--diffusion-fa` twice as in the supplied command; if your build rejects or warns about repeated flags, remove one occurrence.
- This configuration is a tested starting point, not a guarantee of best performance on every RX 580 system. GPU memory, PCIe topology, driver version, and build options can change results.
- Model weights are not included in this repository. Respect the license and terms that apply to each model.


## Qwen Image prompt enhancer (Heretic)

The repository also includes `run-qwen-image-2.1-pe-heretic.sh`, a separate `llama-server` launcher for the Qwen Image 2.1 PE Heretic Q4_K_M prompt-enhancer model.

- **Model:** `pe_t2i_heretic-Q4_K_M.gguf`
- **Server address:** `http://127.0.0.1:8081`
- **Vulkan device visibility:** `GGML_VK_VISIBLE_DEVICES=2`
- **Expected files:** the model and `system_prompt.txt` in the `PE` directory

Edit `BASE` and `DIR` in the script for your machine, then run:

```bash
chmod +x run-qwen-image-2.1-pe-heretic.sh
./run-qwen-image-2.1-pe-heretic.sh
```

The launcher starts the server only; it does not automatically connect the prompt enhancer to `sd-server`. The `system_prompt.txt` file is checked for existence by the script but is not explicitly passed as a server argument.

## License

This repository's launcher and documentation are released under the MIT License. See [LICENSE](LICENSE). Third-party software and model weights retain their own licenses.
