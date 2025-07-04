# Fooocus (Mashb1t fork) - Advanced AI Image Generation

>The most feature-rich Fooocus fork with professional-grade computer vision capabilities.
>
>Includes GroundingDINO for object detection, rembg for background removal, and advanced face detection - everything you need for production-ready AI image workflows.

## Contents

1. [About Fooocus Mashb1t](#about-fooocus-mashb1t)
2. [Why Choose This Template](#why-choose-this-template)
3. [Quick Start](#quick-start)
4. [Connecting to Your Instance](#connecting-to-your-instance)
5. [Integrated Services](#integrated-services)
6. [Environment Variables](#environment-variables)
7. [Model Provisioning](#model-provisioning)
8. [Advanced Features](#advanced-features)
9. [Performance Optimization](#performance-optimization)
10. [Support & Resources](#support--resources)

## About Fooocus Mashb1t

This template provides the **mashb1t Fooocus fork** - the community's choice for advanced AI image generation with professional features. Built on Vast.ai's optimized infrastructure, this image includes everything you need to start generating stunning AI artwork immediately.

**What makes Mashb1t special:**
- **GroundingDINO Integration**: Advanced object detection and segmentation
- **Background Removal**: Built-in rembg for instant background removal
- **Face Detection & Enhancement**: Professional portrait processing
- **Enhanced Inpainting**: Superior masked editing capabilities
- **All Fooocus Features**: Full compatibility with base Fooocus workflows

This container builds upon Vast.ai's reliable infrastructure, ensuring stable and consistent performance.

## Why Choose This Template

### 🚀 **Production-Ready Features**
- Pre-configured with advanced CV models
- Professional background removal tools
- Enterprise-grade face detection
- Batch processing capabilities

### 💰 **Cost-Effective on Vast.ai**
- Optimized for Vast.ai's GPU infrastructure
- Efficient memory usage with TCMalloc
- Auto-shutdown capabilities to save credits

### 🛠️ **Complete Development Environment**
- Web-based file manager for easy model management
- Integrated terminal for advanced operations
- Real-time log viewer for debugging
- Automated model provisioning system

### 🔒 **Secure & Reliable**
- Password-protected services
- Stable PyTorch 2.1.0 + CUDA 12.1
- Professional support community

## Quick Start

1. **Select this template** on Vast.ai
2. **Choose your GPU** (Recommended: RTX 3090 or better for advanced features)
3. **Configure your instance**:
   ```bash
   -e USERNAME=admin -e PASSWORD=your_secure_password
   -e OPEN_BUTTON_PORT=80
   -p 80:80 -p 8010:8010 -p 7010:7010 -p 7020:7020 -p 7030:7030
   ```
4. **Launch in "Entrypoint" mode**
5. **Access via the Open button** on your instance

That's it! Your professional AI image generation studio is ready.

## Connecting to Your Instance

### Instance Portal (Port 80)
Click the **Open** button on your Vast.ai instance card to access the landing page with links to all services.

### Direct Service Access
- **Fooocus UI**: `http://[instance-ip]:8010` - Main generation interface
- **File Browser**: `http://[instance-ip]:7010` - Manage models and outputs
- **Web Terminal**: `http://[instance-ip]:7020` - Command line access
- **Log Viewer**: `http://[instance-ip]:7030` - Monitor all services

### SSH Access
For advanced users, SSH is available with key-based authentication. The session automatically starts in tmux for persistence.

## Integrated Services

### Fooocus Mashb1t (Port 8010)
The main attraction - mashb1t's enhanced Fooocus with:
- GroundingDINO for precise object detection
- Background removal with rembg
- Advanced face detection and enhancement
- All standard Fooocus features plus more

### File Browser (Port 7010)
Professional file management interface:
- Upload/download models with drag & drop
- Organize your outputs
- Preview generated images
- Manage model collections

### Web Terminal (Port 7020)
Full terminal access via browser:
- Install additional packages
- Run custom scripts
- Debug issues
- Fine-tune configurations

### Log Viewer (Port 7030)
Real-time log monitoring:
- View Fooocus generation logs
- Monitor model downloads
- Debug errors
- Track performance

## Environment Variables

### Essential Configuration
| Variable | Default | Description |
| --- | --- | --- |
| `USERNAME` | `admin` | Username for all services |
| `PASSWORD` | `fooocus` | Password for all services (CHANGE THIS!) |
| `OPEN_BUTTON_PORT` | `80` | Port for the landing page |

### Model Provisioning
| Variable | Description |
| --- | --- |
| `PROVISION_URL` | URL to your model configuration TOML file |
| `HF_TOKEN` | HuggingFace token for gated models |
| `CIVITAI_TOKEN` | CivitAI API token for model downloads |

### Performance Tuning
| Variable | Default | Description |
| --- | --- | --- |
| `FOOOCUS_ARGS` | | Additional Fooocus launch arguments |
| `NO_TCMALLOC` | | Disable TCMalloc optimization |
| `NO_ACCELERATE` | | Disable HF Accelerate |

### Advanced Options
| Variable | Description |
| --- | --- |
| `FOOOCUS_AUTO_UPDATE` | Enable auto-updates (set to `true`) |
| `WORKSPACE` | Override workspace directory (default: `/workspace`) |

## Model Provisioning

This template includes an advanced provisioning system that automatically downloads your models on startup:

1. Create a TOML configuration file with your models
2. Host it on GitHub, Google Drive, or any web server
3. Set `PROVISION_URL` to your config file URL
4. Models download automatically when the instance starts

Example configuration:
```toml
[models.checkpoints]
sdxl-base = { source = "huggingface", repo = "stabilityai/stable-diffusion-xl-base-1.0", file = "sd_xl_base_1.0.safetensors" }

[models.lora]
detail-enhancer = { source = "civitai", model_id = "135867" }
```

See [PROVISION.md](https://github.com/codechips/vastai-fooocus-forks/blob/main/PROVISION.md) for complete documentation.

## Advanced Features

### GroundingDINO Integration
- Precise object detection in images
- Advanced masking for inpainting
- Automatic region selection
- Professional segmentation tools

### Background Removal (rembg)
- One-click background removal
- Multiple algorithm options
- Batch processing support
- Alpha channel preservation

### Face Detection & Enhancement
- Automatic face detection
- Gender and age estimation
- Face enhancement options
- Batch portrait processing

### Workflow Automation
- Save and load generation settings
- Batch processing capabilities
- API access for automation
- Custom script integration

## Performance Optimization

### GPU Memory Management
- Efficient VRAM usage with optimized settings
- Automatic memory cleanup between generations
- Support for both high-end and budget GPUs

### Generation Speed
- TCMalloc for improved memory performance
- HuggingFace Accelerate for multi-core optimization
- Optimized model loading
- Efficient batch processing

### Storage Efficiency
- Symlinked model directories to save space
- Automatic output organization
- Configurable cache management

## Support & Resources

### Documentation
- [Fooocus Repository](https://github.com/lllyasviel/Fooocus)
- [Mashb1t Fork](https://github.com/mashb1t/Fooocus)
- [Provisioning Guide](https://github.com/codechips/vastai-fooocus-forks/blob/main/PROVISION.md)
- [Vast.ai Documentation](https://docs.vast.ai/)

### Community
- Vast.ai Discord community
- Fooocus GitHub discussions
- Reddit r/StableDiffusion

### Troubleshooting Tips
1. **Out of Memory**: Reduce batch size or image resolution
2. **Slow Generation**: Ensure you selected a GPU instance
3. **Model Not Found**: Check provisioning logs at port 7030
4. **Authentication Issues**: Verify USERNAME and PASSWORD are set

---

**Ready to create amazing AI art?** Launch this template now and join thousands of artists and developers using Fooocus on Vast.ai. With mashb1t's advanced features and Vast.ai's affordable GPU power, you have everything you need for professional AI image generation.

*This template is professionally maintained and supported. Your success is our priority.*