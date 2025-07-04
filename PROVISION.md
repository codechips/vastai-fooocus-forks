# Model Provisioning System

The VastAI Fooocus container includes a powerful provisioning system that automatically downloads models from HuggingFace, CivitAI, and direct URLs during container startup.

## Table of Contents
- [Quick Start](#quick-start)
- [Configuration Format](#configuration-format)
- [Model Sources](#model-sources)
  - [HuggingFace Models](#huggingface-models)
  - [CivitAI Models](#civitai-models)
  - [Direct URL Downloads](#direct-url-downloads)
- [Model Categories](#model-categories)
- [Authentication](#authentication)
- [Example Configurations](#example-configurations)
- [How It Works](#how-it-works)
- [Troubleshooting](#troubleshooting)

## Quick Start

1. Create a TOML configuration file with your desired models
2. Host it on a web server, GitHub, or Google Drive
3. Set the `PROVISION_URL` environment variable to your config URL
4. Start the container - models download automatically

```bash
docker run -e PROVISION_URL=https://example.com/my-models.toml ...
```

## Configuration Format

The provisioning system uses TOML format for configuration. Models are organized by category:

```toml
[models.checkpoints]
model-name = { source = "huggingface", repo = "...", file = "..." }

[models.lora]
another-model = { source = "civitai", model_id = "..." }

[models.vae]
vae-model = { source = "url", url = "https://..." }
```

## Model Sources

### HuggingFace Models

Download models from HuggingFace repositories:

```toml
[models.checkpoints]
# Basic HuggingFace model
sdxl-base = { 
    source = "huggingface", 
    repo = "stabilityai/stable-diffusion-xl-base-1.0", 
    file = "sd_xl_base_1.0.safetensors" 
}

# Gated model (requires HF_TOKEN)
flux-dev = { 
    source = "huggingface", 
    repo = "black-forest-labs/FLUX.1-dev", 
    file = "flux1-dev.safetensors", 
    gated = true 
}

# Download all files from a repo
embeddings-pack = { 
    source = "huggingface", 
    repo = "username/embeddings-collection", 
    download_all = true 
}
```

**Authentication**: Set `HF_TOKEN` environment variable for gated models.

### CivitAI Models

Download models from CivitAI:

```toml
[models.checkpoints]
# CivitAI model using version ID
juggernaut-xl = { source = "civitai", model_id = "288982" }

[models.lora]
# Another CivitAI model
detail-tweaker = { source = "civitai", model_id = "135867" }
```

**Important: Use Version ID, not Model ID!**
- When browsing CivitAI, each model has multiple versions
- Use the **version ID** from the URL: `?modelVersionId=288982`
- Don't use the model ID from: `/models/133005`

**How to find the Version ID:**
1. Go to the model page on civitai.com
2. Select the specific version you want from the dropdown
3. Look at the URL or click "Copy Link" on the download button
4. Use the number after `modelVersionId=`

**Authentication**: Set `CIVITAI_TOKEN` environment variable for certain models.

### Direct URL Downloads

Download from any direct URL:

```toml
[models.upscale_models]
# Simple URL download
upscaler = { source = "url", url = "https://example.com/model.pth" }

# With custom filename
custom-vae = { 
    source = "url", 
    url = "https://example.com/download?id=123", 
    filename = "my-custom-vae.safetensors" 
}
```

## Model Categories

Models are organized into categories that map to Fooocus directory structure:

| Category | Directory | Description |
|----------|-----------|-------------|
| `checkpoints` | `/opt/fooocus/models/checkpoints/` | Main Stable Diffusion models |
| `lora` | `/opt/fooocus/models/loras/` | LoRA adaptations |
| `vae` | `/opt/fooocus/models/vae/` | VAE models |
| `embeddings` | `/opt/fooocus/models/embeddings/` | Textual inversions |
| `controlnet` | `/opt/fooocus/models/controlnet/` | ControlNet models |
| `upscale_models` | `/opt/fooocus/models/upscale_models/` | ESRGAN upscalers |
| `inpaint` | `/opt/fooocus/models/inpaint/` | Inpainting models |
| `text_encoder` | `/opt/fooocus/models/text_encoder/` | CLIP/T5 encoders |
| `hypernetworks` | `/opt/fooocus/models/hypernetworks/` | Hypernetworks |
| `clip_vision` | `/opt/fooocus/models/clip_vision/` | CLIP vision models |

## Authentication

### HuggingFace Token
For gated models (like FLUX), you need a HuggingFace token:

1. Get your token from https://huggingface.co/settings/tokens
2. Set the environment variable: `HF_TOKEN=your_token_here`
3. Accept model licenses on HuggingFace before downloading

### CivitAI Token
Some CivitAI models require authentication:

1. Get your API key from https://civitai.com/user/account
2. Set the environment variable: `CIVITAI_TOKEN=your_token_here`

## Example Configurations

### Basic SDXL Setup
```toml
# Basic SDXL setup with VAE
[models.checkpoints]
sdxl-base = { 
    source = "huggingface", 
    repo = "stabilityai/stable-diffusion-xl-base-1.0", 
    file = "sd_xl_base_1.0.safetensors" 
}

[models.vae]
sdxl-vae = { 
    source = "huggingface", 
    repo = "madebyollin/sdxl-vae-fp16-fix", 
    file = "sdxl_vae.safetensors" 
}

[models.lora]
detail-enhancer = { source = "civitai", model_id = "135867" }
```

### FLUX Setup
```toml
# FLUX.1-dev complete setup
[models.checkpoints]
flux-dev = { 
    source = "huggingface", 
    repo = "black-forest-labs/FLUX.1-dev", 
    file = "flux1-dev.safetensors", 
    gated = true 
}

[models.vae]
flux-vae = { 
    source = "huggingface", 
    repo = "black-forest-labs/FLUX.1-dev", 
    file = "ae.safetensors", 
    gated = true 
}

[models.text_encoder]
clip_l = { 
    source = "huggingface", 
    repo = "comfyanonymous/flux_text_encoders", 
    file = "clip_l.safetensors" 
}
t5xxl_fp8 = { 
    source = "huggingface", 
    repo = "comfyanonymous/flux_text_encoders", 
    file = "t5xxl_fp8_e4m3fn.safetensors" 
}
```

### Mixed Sources
```toml
# Mix different sources in one config
[models.checkpoints]
# From HuggingFace
sdxl = { source = "huggingface", repo = "stabilityai/stable-diffusion-xl-base-1.0", file = "sd_xl_base_1.0.safetensors" }
# From CivitAI
juggernaut = { source = "civitai", model_id = "288982" }

[models.embeddings]
# Direct URL
easy-negative = { source = "url", url = "https://huggingface.co/datasets/gsdf/EasyNegative/resolve/main/EasyNegative.safetensors" }
```

## How It Works

1. **Container Startup**: The provisioning system runs before Fooocus starts
2. **Configuration Fetch**: Downloads and parses your TOML configuration
3. **Token Validation**: Checks HF_TOKEN and CIVITAI_TOKEN if needed
4. **Parallel Downloads**: Downloads multiple models concurrently
5. **Progress Tracking**: Shows download progress in logs
6. **Model Storage**: Saves to `/workspace/fooocus/models/` (symlinked to `/opt/fooocus/models/`)
7. **Fooocus Launch**: Starts with all models available

### Model Storage Location
- Models are downloaded to: `/workspace/fooocus/models/{category}/`
- Symlinked to: `/opt/fooocus/models/{category}/`
- This ensures models persist across container restarts

## Troubleshooting

### Common Issues

**"Model not found" errors**
- Check the model/version ID is correct
- Ensure the model is public or you have proper authentication
- Verify the category matches the model type

**"Authentication failed"**
- Check your tokens are set correctly
- For HuggingFace: Accept the model license on the website
- For CivitAI: Ensure your API key has proper permissions

**"Download failed"**
- Check network connectivity
- Verify the URL is accessible
- Check disk space in `/workspace`

### Validation

Test your configuration without downloading:
```bash
docker run -e PROVISION_URL=https://your-config.toml -e DRY_RUN=true ...
```

### Logs

Provisioning logs are saved to: `/workspace/logs/provision.log`

View logs:
```bash
docker exec <container> cat /workspace/logs/provision.log
```

## Advanced Features

### Custom Headers
Add authentication headers for private URLs:
```toml
[models.checkpoints]
private-model = { 
    source = "url", 
    url = "https://private-server.com/model.safetensors",
    headers = { Authorization = "Bearer token123" }
}
```

### Conditional Downloads
Models are only downloaded if they don't already exist, making provisioning idempotent.

### Resume Support
Failed downloads are automatically cleaned up and can be retried.