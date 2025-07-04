# Fooocus (Extend fork) - Ultimate AI Face & Image Processing

>The most comprehensive Fooocus fork with InsightFace integration and advanced face processing capabilities.
>
>Perfect for portrait enhancement, face swapping, age progression, and professional image manipulation workflows.

## Contents

1. [About Fooocus Extended](#about-fooocus-extended)
2. [Why Choose This Template](#why-choose-this-template)
3. [Quick Start](#quick-start)
4. [Connecting to Your Instance](#connecting-to-your-instance)
5. [Integrated Services](#integrated-services)
6. [Environment Variables](#environment-variables)
7. [Model Provisioning](#model-provisioning)
8. [Advanced Face Processing](#advanced-face-processing)
9. [Professional Features](#professional-features)
10. [Support & Resources](#support--resources)

## About Fooocus Extend

This template provides **Fooocus Extend** - the ultimate fork for professional face processing and advanced image manipulation. Building upon mashb1t's features, this fork adds powerful InsightFace integration and comprehensive image processing tools.

**What makes Extend special:**
- **InsightFace Integration**: State-of-the-art face analysis and manipulation
- **Face Swapping**: Professional-grade face replacement
- **Age & Gender Processing**: Advanced demographic modifications
- **All Mashb1t Features**: Including GroundingDINO and rembg
- **Enhanced Workflows**: Professional production pipelines

Powered by Vast.ai's enterprise-grade infrastructure with automatic updates and professional support.

## Why Choose This Template

### 👤 **Unmatched Face Processing**
- Industry-leading InsightFace models
- Professional face swapping
- Age progression/regression
- Gender transformation
- Emotion manipulation

### 🎯 **Complete Feature Set**
- Everything from mashb1t fork
- Plus advanced face tools
- Professional workflows
- Batch processing
- API automation

### 💼 **Enterprise Ready**
- Production-grade stability
- Professional support
- Scalable architecture
- Secure processing

### 💰 **Maximum Value on Vast.ai**
- All features in one package
- Optimized resource usage
- Cost-effective scaling

## Quick Start

1. **Select this template** on Vast.ai
2. **Choose a powerful GPU** (RTX 3090 or A5000 recommended for face processing)
3. **Configure your instance**:
   ```bash
   -e USERNAME=admin -e PASSWORD=your_secure_password
   -e OPEN_BUTTON_PORT=80
   -p 80:80 -p 8010:8010 -p 7010:7010 -p 7020:7020 -p 7030:7030
   ```
4. **Launch in "Interactive shell server, SSH" or "Jupyter-python notebook + SSH" mode**
5. **Click Open** to access your professional AI studio

Your comprehensive image processing suite is ready!

## Connecting to Your Instance

### Web Portal (Port 80)
Click the **Open** button for immediate access to all services through our professional landing page.

### Service Endpoints
- **Fooocus Extended**: `http://[instance-ip]:8010` - Main interface
- **File Manager**: `http://[instance-ip]:7010` - Asset management
- **Terminal**: `http://[instance-ip]:7020` - System access
- **Logs**: `http://[instance-ip]:7030` - Monitoring

### Professional Access
SSH available for advanced users with automated tmux sessions for persistent workflows.

## Integrated Services

### Fooocus Extended (Port 8010)
The complete package featuring:
- Full InsightFace integration
- Professional face swapping
- Age and gender manipulation
- GroundingDINO object detection
- Background removal (rembg)
- Advanced inpainting
- Batch processing

### File Browser (Port 7010)
Professional asset management:
- Model library organization
- Output categorization
- Batch file operations
- Preview galleries

### Web Terminal (Port 7020)
Advanced system control:
- Custom script execution
- Model fine-tuning
- Batch operations
- System optimization

### Log Viewer (Port 7030)
Enterprise monitoring:
- Real-time processing logs
- Performance metrics
- Error tracking
- Usage statistics

## Environment Variables

### Essential Settings
| Variable | Default | Description |
| --- | --- | --- |
| `USERNAME` | `admin` | Access username |
| `PASSWORD` | `fooocus` | Access password (CHANGE REQUIRED) |
| `OPEN_BUTTON_PORT` | `80` | Portal port |

### Model Configuration
| Variable | Description |
| --- | --- |
| `PROVISION_URL` | Model provisioning config URL |
| `HF_TOKEN` | HuggingFace token |
| `CIVITAI_TOKEN` | CivitAI API key |

### Performance Tuning
| Variable | Default | Description |
| --- | --- | --- |
| `FOOOCUS_ARGS` | | Custom launch parameters |
| `INSIGHTFACE_CACHE` | `/workspace/.insightface` | Face model cache |
| `NO_FACE_ENHANCE` | | Disable face enhancement |

## Model Provisioning

Extend supports comprehensive model provisioning:

**Environment Variables:**
```bash
-e PROVISION_URL="https://drive.google.com/file/d/YOUR_FILE_ID/view"
-e CIVITAI_TOKEN=your-civitai-token
-e HF_TOKEN=your-huggingface-token
```

**Example Configuration:**
```toml
# Face processing models
[models.insightface]
buffalo_l = { source = "huggingface", repo = "deepinsight/insightface", file = "buffalo_l.zip" }

# Standard models
[models.checkpoints]
realistic-vision = { source = "civitai", version_id = "245598" }

# Face-specific LoRAs
[models.lora]
face-enhancer = { source = "civitai", version_id = "789012" }
```

Complete guide: [PROVISION.md](https://github.com/codechips/vastai-fooocus-forks/blob/main/PROVISION.md)

## Advanced Face Processing

### InsightFace Capabilities
- **Face Detection**: Multi-face detection with landmarks
- **Face Recognition**: Identity preservation and matching
- **Face Swapping**: Seamless face replacement
- **Age Modification**: Realistic age progression
- **Gender Swap**: Natural gender transformation
- **Expression Transfer**: Emotion manipulation

### Professional Workflows
1. **Portrait Enhancement Pipeline**
   - Face detection → Enhancement → Background processing
   - Batch processing for photo shoots
   - Consistent style application

2. **Identity Preservation**
   - Face embedding extraction
   - Cross-image identity matching
   - Consistent character generation

3. **Demographic Studies**
   - Age progression sequences
   - Ethnicity preservation
   - Gender studies

### API Integration
```python
# Example: Batch face processing
for image in images:
    process_face(image, age_target=30, enhance=True)
```

## Professional Features

### Complete Toolset
- **GroundingDINO**: Precise object detection
- **Background Removal**: Clean extractions
- **Face Analysis**: Comprehensive metrics
- **Batch Processing**: Production workflows
- **API Access**: Automation ready

### Quality Assurance
- Consistent output quality
- Face verification checks
- Batch quality metrics
- Error handling
- Rollback capabilities

### Enterprise Integration
- RESTful API endpoints
- Webhook notifications
- Queue management
- Load balancing ready
- Monitoring integration

## Support & Resources

### Documentation
- [Fooocus Extended GitHub](https://github.com/shaitanzx/Fooocus_extend)
- [InsightFace Documentation](https://github.com/deepinsight/insightface)
- [Provisioning Guide](https://github.com/codechips/vastai-fooocus-forks/blob/main/PROVISION.md)
- [API Reference](https://github.com/lllyasviel/Fooocus/wiki)

### Professional Support
- Priority Discord support
- GitHub issue tracking
- Community workshops
- Video tutorials

### Optimization Tips
1. **Face Processing**: Use A5000 or better for complex operations
2. **Batch Jobs**: Enable queue mode for efficiency
3. **Memory**: 24GB+ VRAM recommended for all features
4. **Storage**: Allocate 100GB+ for models and outputs

---

**Ready for professional-grade AI image processing?** Launch Fooocus Extend now and access the most comprehensive set of AI image and face manipulation tools available. With Vast.ai's powerful GPUs and Extend's complete feature set, you have everything needed for production workflows.

*Enterprise-grade template with professional maintenance and support. Your success is guaranteed.*