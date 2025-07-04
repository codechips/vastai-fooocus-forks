# Fooocus (MRE fork) - Minimal & Lightning Fast

>The lightweight champion - Minimal Requirements Edition for maximum efficiency and speed.
>
>Perfect for budget-conscious creators who want pure Fooocus performance without the overhead.

## Contents

1. [About Fooocus MRE](#about-fooocus-mre)
2. [Why Choose This Template](#why-choose-this-template)
3. [Quick Start](#quick-start)
4. [Connecting to Your Instance](#connecting-to-your-instance)
5. [Integrated Services](#integrated-services)
6. [Environment Variables](#environment-variables)
7. [Model Provisioning](#model-provisioning)
8. [Performance Benefits](#performance-benefits)
9. [Best Use Cases](#best-use-cases)
10. [Support & Resources](#support--resources)

## About Fooocus MRE

This template provides **Fooocus MRE (Minimal Requirements Edition)** by MoonRide303 - the most efficient Fooocus implementation available. Stripped of unnecessary features while maintaining core functionality, MRE is perfect for users who value speed, efficiency, and cost-effectiveness.

**What makes MRE special:**
- **Minimal Resource Usage**: Runs on lower-spec GPUs
- **Lightning Fast**: Reduced overhead means faster generation
- **Pure Fooocus**: Core features without bloat
- **Cost Effective**: Lower GPU requirements save money
- **Stable & Reliable**: Fewer dependencies mean fewer issues

Optimized for Vast.ai's infrastructure with the same professional maintenance as our other templates.

## Why Choose This Template

### ⚡ **Maximum Efficiency**
- Fastest startup times
- Minimal memory footprint
- Quick generation speeds
- Reduced complexity

### 💵 **Budget Friendly**
- Runs on cheaper GPUs
- Lower VRAM requirements
- Reduced storage needs
- Maximum value per dollar

### 🎯 **Focused Functionality**
- Core Fooocus features
- No unnecessary additions
- Clean, simple interface
- Easy to understand

### 🔧 **Rock Solid Stability**
- Fewer dependencies
- Less to break
- Easier troubleshooting
- Consistent performance

## Quick Start

1. **Select this template** on Vast.ai
2. **Choose an economical GPU** (RTX 3060 or better works great!)
3. **Configure your instance**:
   ```bash
   -e USERNAME=admin -e PASSWORD=your_secure_password
   -e OPEN_BUTTON_PORT=80
   -p 80:80 -p 8010:8010 -p 7010:7010 -p 7020:7020 -p 7030:7030
   ```
4. **Launch in "Entrypoint" mode**
5. **Click Open** to start creating

Minimal setup, maximum creativity!

## Connecting to Your Instance

### Simple Access (Port 80)
Click the **Open** button on your Vast.ai instance for instant access to all services.

### Direct Services
- **Fooocus MRE**: `http://[instance-ip]:8010` - Clean generation interface
- **File Browser**: `http://[instance-ip]:7010` - Simple file management
- **Terminal**: `http://[instance-ip]:7020` - System access
- **Logs**: `http://[instance-ip]:7030` - Monitor operations

### Authentication Note
MRE has a quirk: authentication only works with the `--share` flag. We've configured standard password protection for other services, but be aware of this limitation.

## Integrated Services

### Fooocus MRE (Port 8010)
Pure Fooocus experience:
- Text-to-image generation
- Image-to-image transformation
- Inpainting capabilities
- LoRA support
- Model switching
- Essential controls only

### File Browser (Port 7010)
Streamlined file management:
- Upload/download models
- Organize outputs
- Simple navigation
- Quick previews

### Web Terminal (Port 7020)
Basic system access:
- Command line interface
- Package management
- Configuration editing
- Troubleshooting

### Log Viewer (Port 7030)
Essential monitoring:
- Generation logs
- Error tracking
- Performance data
- System status

## Environment Variables

### Core Settings
| Variable | Default | Description |
| --- | --- | --- |
| `USERNAME` | `admin` | Service username |
| `PASSWORD` | `fooocus` | Service password (PLEASE CHANGE) |
| `OPEN_BUTTON_PORT` | `80` | Landing page port |

### Model Setup
| Variable | Description |
| --- | --- |
| `PROVISION_URL` | Auto-download models config |
| `HF_TOKEN` | HuggingFace token |
| `CIVITAI_TOKEN` | CivitAI token |

### MRE Specific
| Variable | Default | Description |
| --- | --- | --- |
| `FOOOCUS_ARGS` | | Additional arguments |
| `MINIMAL_MODE` | `true` | Keep it minimal |
| `NO_ACCELERATE` | | Disable if issues |

## Model Provisioning

MRE supports the same automatic provisioning system:

```toml
# Efficient model selection
[models.checkpoints]
# Smaller, efficient models recommended
dreamshaper-7 = { source = "civitai", model_id = "109123" }

[models.vae]
# Essential VAE only
vae-ft-mse = { source = "huggingface", repo = "stabilityai/sd-vae-ft-mse-original", file = "vae-ft-mse-840000-ema-pruned.safetensors" }
```

See [PROVISION.md](https://github.com/codechips/vastai-fooocus-forks/blob/main/PROVISION.md) for details.

## Performance Benefits

### Resource Efficiency
- **Lower VRAM**: Runs on 6GB GPUs
- **Faster Loading**: Minimal dependencies
- **Quick Generation**: Less overhead
- **Smaller Footprint**: Saves storage

### Cost Savings
- Use cheaper GPU instances
- Shorter generation times
- Lower bandwidth usage
- Reduced storage costs

### Reliability
- Fewer points of failure
- Simpler troubleshooting
- Consistent performance
- Stable operation

## Best Use Cases

### Perfect For:
1. **Budget-Conscious Creators**
   - Maximum value per dollar
   - Professional results on a budget
   - Efficient resource usage

2. **High-Volume Generation**
   - Faster turnaround
   - Batch processing
   - Production workflows

3. **Learning & Experimentation**
   - Simple interface
   - Core features only
   - Easy to understand

4. **Stable Production**
   - Reliable operation
   - Minimal complexity
   - Easy maintenance

### May Not Suit:
- Users needing advanced CV features
- Complex face processing workflows
- Cutting-edge experimental features

## Support & Resources

### Documentation
- [Fooocus MRE GitHub](https://github.com/MoonRide303/Fooocus-MRE)
- [Original Fooocus](https://github.com/lllyasviel/Fooocus)
- [Provisioning Guide](https://github.com/codechips/vastai-fooocus-forks/blob/main/PROVISION.md)
- [Vast.ai Support](https://docs.vast.ai/)

### Community
- Vast.ai Discord
- GitHub discussions
- Reddit communities
- User forums

### Quick Fixes
1. **Auth Issues**: MRE only supports auth with --share flag
2. **Memory Errors**: Reduce batch size or resolution
3. **Slow Speed**: Ensure GPU (not CPU) instance
4. **Models Missing**: Check provisioning logs

---

**Ready for efficient AI art generation?** Launch Fooocus MRE now and experience the perfect balance of functionality and efficiency. With Vast.ai's affordable GPUs and MRE's minimal requirements, you get professional results without breaking the bank.

*Professionally maintained minimal template. Maximum efficiency, minimum cost.*