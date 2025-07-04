# Fooocus (Ruined fork) - Modern UI for AI Art

>Experience Fooocus with a cutting-edge Gradio 5.x interface and enhanced user experience.
>
>The cleanest, most intuitive way to generate AI images with modern web technologies and streamlined authentication.

## Contents

1. [About RuinedFooocus](#about-ruinedfooocus)
2. [Why Choose This Template](#why-choose-this-template)
3. [Quick Start](#quick-start)
4. [Connecting to Your Instance](#connecting-to-your-instance)
5. [Integrated Services](#integrated-services)
6. [Environment Variables](#environment-variables)
7. [Model Provisioning](#model-provisioning)
8. [Unique Features](#unique-features)
9. [Performance & Compatibility](#performance--compatibility)
10. [Support & Resources](#support--resources)

## About RuinedFooocus

This template provides **RuinedFooocus** - a modern reimagining of Fooocus with the latest Gradio 5.x interface. Created by runew0lf, this fork focuses on user experience, clean design, and streamlined workflows while maintaining full compatibility with Fooocus models and features.

**What makes RuinedFooocus special:**
- **Gradio 5.x Interface**: The latest UI framework with modern components
- **Enhanced User Experience**: Intuitive controls and better organization
- **Clean Authentication**: Built-in --auth support for secure access
- **Streamlined Dependencies**: Modern pip/modules.txt structure
- **Full Fooocus Compatibility**: All the power, better interface

Built on Vast.ai's optimized infrastructure for reliable and consistent performance.

## Why Choose This Template

### 🎨 **Modern Interface Design**
- Latest Gradio 5.x components
- Responsive and mobile-friendly
- Dark mode support
- Intuitive parameter organization

### 🚀 **Simplified Workflow**
- Cleaner UI reduces learning curve
- Better parameter grouping
- Enhanced preview capabilities
- Streamlined generation process

### 💎 **Premium Experience on Vast.ai**
- Optimized for cloud deployment
- Efficient resource utilization
- Cost-effective GPU usage

### 🔐 **Security First**
- Native authentication support
- Secure password protection
- No external dependencies

## Quick Start

1. **Select this template** on Vast.ai
2. **Choose your GPU** (Any modern GPU works great)
3. **Configure your instance**:
   ```bash
   -e USERNAME=admin -e PASSWORD=your_secure_password
   -e OPEN_BUTTON_PORT=80
   -p 80:80 -p 8010:8010 -p 7010:7010 -p 7020:7020 -p 7030:7030
   ```
4. **Launch in "Entrypoint" mode**
5. **Click Open** to access your modern AI art studio

You're ready to create with the most user-friendly Fooocus interface!

## Connecting to Your Instance

### Instance Portal (Port 80)
Click the **Open** button on your Vast.ai instance for instant access to all services through our beautiful landing page.

### Direct Service URLs
- **RuinedFooocus**: `http://[instance-ip]:8010` - Modern generation interface
- **File Browser**: `http://[instance-ip]:7010` - Elegant file management
- **Web Terminal**: `http://[instance-ip]:7020` - Browser-based console
- **Log Viewer**: `http://[instance-ip]:7030` - Real-time monitoring

### Authentication
All services are protected with your configured username and password. RuinedFooocus uses native Gradio authentication for seamless security.

## Integrated Services

### RuinedFooocus (Port 8010)
The star of the show - modern Fooocus with:
- Beautiful Gradio 5.x interface
- Organized parameter sections
- Enhanced preview system
- Mobile-responsive design
- All core Fooocus features

### File Browser (Port 7010)
Elegant file management:
- Modern web interface
- Drag-and-drop uploads
- Image preview gallery
- Model organization tools

### Web Terminal (Port 7020)
Full system access:
- Browser-based terminal
- Package installation
- System monitoring
- Configuration editing

### Log Viewer (Port 7030)
Professional monitoring:
- Real-time log streaming
- Filter and search
- Multi-log viewing
- Performance metrics

## Environment Variables

### Core Configuration
| Variable | Default | Description |
| --- | --- | --- |
| `USERNAME` | `admin` | Login username |
| `PASSWORD` | `fooocus` | Login password (MUST CHANGE!) |
| `OPEN_BUTTON_PORT` | `80` | Landing page port |

### Model Management
| Variable | Description |
| --- | --- |
| `PROVISION_URL` | Auto-provision models from TOML config |
| `HF_TOKEN` | HuggingFace access token |
| `CIVITAI_TOKEN` | CivitAI API token |

### Customization
| Variable | Default | Description |
| --- | --- | --- |
| `FOOOCUS_ARGS` | | Additional launch arguments |
| `FOOOCUS_AUTO_UPDATE` | | Enable automatic updates |
| `NO_ACCELERATE` | | Disable acceleration |

## Model Provisioning

RuinedFooocus supports automatic model downloads on startup:

1. Create a TOML configuration file
2. Upload to GitHub, Google Drive, or any URL
3. Set `PROVISION_URL` environment variable
4. Models download automatically

Quick example:
```toml
[models.checkpoints]
dreamshaper-xl = { source = "civitai", model_id = "351306" }

[models.vae]
sdxl-vae = { source = "huggingface", repo = "madebyollin/sdxl-vae-fp16-fix", file = "sdxl_vae.safetensors" }
```

Full documentation: [PROVISION.md](https://github.com/codechips/vastai-fooocus-forks/blob/main/PROVISION.md)

## Unique Features

### Modern UI Components
- **Gradio 5.x**: Latest interface technology
- **Responsive Design**: Works on any device
- **Dark Mode**: Easy on the eyes
- **Organized Layouts**: Logical parameter grouping

### Enhanced Workflows
- **Quick Settings**: Favorite parameter combinations
- **Better Previews**: Enhanced image viewing
- **Streamlined Controls**: Fewer clicks to generate
- **Modern Aesthetics**: Professional appearance

### Clean Architecture
- **Simplified Dependencies**: Modern pip structure
- **Native Authentication**: Built-in security
- **Efficient Codebase**: Optimized for performance
- **Regular Updates**: Latest features and fixes

## Performance & Compatibility

### Optimized for Cloud
- Designed for containerized environments
- Efficient memory usage
- Fast startup times
- Minimal overhead

### GPU Compatibility
- Works with all modern NVIDIA GPUs
- Optimized for both consumer and datacenter cards
- Automatic memory management
- Efficient batch processing

### Model Support
- Full SDXL compatibility
- LoRA and embedding support
- VAE selection
- All standard Fooocus models

## Support & Resources

### Documentation
- [RuinedFooocus GitHub](https://github.com/runew0lf/RuinedFooocus)
- [Original Fooocus](https://github.com/lllyasviel/Fooocus)
- [Provisioning Guide](https://github.com/codechips/vastai-fooocus-forks/blob/main/PROVISION.md)
- [Vast.ai Docs](https://docs.vast.ai/)

### Getting Help
- Vast.ai Discord server
- GitHub Issues
- Community forums
- Built-in documentation

### Common Solutions
1. **Login Issues**: Verify USERNAME/PASSWORD are set correctly
2. **UI Not Loading**: Check port 8010 is open
3. **Model Errors**: Review provisioning logs
4. **Performance**: Ensure GPU instance is selected

---

**Ready for the best Fooocus experience?** Launch RuinedFooocus now and enjoy AI image generation with a modern, intuitive interface. Combine the power of Vast.ai's affordable GPUs with the elegance of RuinedFooocus for an unmatched creative experience.

*This template is professionally maintained and supported. Create with confidence.*