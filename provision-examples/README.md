# Provision Script Examples

This directory contains example TOML configuration files for the model provisioning system via `PROVISION_URL`.

## Quick Start

1. **Choose an example** from this directory or create your own TOML file
2. **Host the file** somewhere accessible (GitHub, Google Drive, your own server, etc.)
3. **Set the PROVISION_URL** environment variable when starting the container:

```bash
docker run -e PROVISION_URL=https://your-server.com/config.toml your-image
```

## Examples

### [`basic-models.toml`](basic-models.toml)
Essential models to get started:
- SDXL base and refiner checkpoints
- SDXL VAE
- One popular LoRA

**Use case**: Minimal setup, fastest download

### [`comprehensive-models.toml`](comprehensive-models.toml)
Full-featured setup:
- Multiple checkpoints (SDXL + community models)
- Several LoRAs for different styles
- ControlNet models
- Upscaling models

**Use case**: Complete workshop setup

### [`flux-models.toml`](flux-models.toml)
FLUX.1-dev setup:
- FLUX checkpoint and VAE (requires HuggingFace token)
- Required text encoders
- FLUX-compatible LoRAs

**Use case**: FLUX model experimentation

### [`google-drive-example.toml`](google-drive-example.toml)
Google Drive integration:
- Shows how to use Google Drive sharing links
- Handles large file virus scan warnings
- Custom model sharing

**Use case**: Sharing custom models privately

## Configuration Format

Each TOML file follows this structure:

```toml
[models.CATEGORY.MODEL_NAME]
source = "huggingface" | "civitai" | "url"
# ... source-specific parameters
```

**Categories**: `checkpoints`, `lora`, `vae`, `controlnet`, `esrgan`, `embeddings`, `text_encoder`

**Sources**:
- `huggingface`: HuggingFace Hub models
- `civitai`: CivitAI models  
- `url`: Direct URLs (including Google Drive)

## Authentication

For gated models, set these environment variables:
- `HF_TOKEN`: HuggingFace token for gated models
- `CIVITAI_TOKEN`: CivitAI token (if needed)

## Tips

- **Test locally**: Use `--dry-run` to validate configuration without downloading
- **Start small**: Begin with `basic-models.toml` and add more models later
- **Check logs**: Monitor `/workspace/logs/provision.log` for download progress
- **Storage planning**: Comprehensive setups can use 20+ GB of storage

## Creating Your Own

1. Copy an example file
2. Modify the models to your needs
3. Host the file somewhere accessible
4. Use the URL with `PROVISION_URL`

See the [main README](../README.md#model-provisioning) for complete documentation.