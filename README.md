# Vast.ai Fooocus Docker Images

Optimized Docker images for running various Fooocus forks on Vast.ai with integrated web-based management tools and automated model provisioning.

## Features

**All-in-one Docker images** with:
- **Fooocus** (port 8010): AI image generation interface
- **Filebrowser** (port 7010): File management interface
- **ttyd** (port 7020): Web-based terminal (writable)
- **logdy** (port 7030): Log viewer
- **Automated Model Provisioning**: Download models from HuggingFace, CivitAI, and direct URLs
- **PyTorch 2.1.0 + CUDA 12.1**: Optimized for stability
- **Simple process management**: No complex orchestration

## Quick Start

### For Vast.ai Users

1. Create a new instance with one of our Docker images (see [Multi-Fork Docker Images](#multi-fork-docker-images) section)

2. Configure environment variables and ports:
   ```bash
   -e USERNAME=admin -e PASSWORD=fooocus -e OPEN_BUTTON_PORT=80 -p 80:80 -p 8010:8010 -p 7010:7010 -p 7020:7020 -p 7030:7030
   ```

   **Optional model provisioning** (see [Model Provisioning](#model-provisioning) section):
   ```bash
   -e PROVISION_URL=https://your-server.com/config.toml
   -e HF_TOKEN=hf_your_huggingface_token
   -e CIVITAI_TOKEN=your_civitai_token
   ```

4. Launch with "Entrypoint" mode for best compatibility

### Access Your Services

- **Landing Page**: OPEN_BUTTON_PORT (nginx homepage with links to all services)
- **Fooocus**: Port 8010 (main interface, protected with Gradio auth)
- **File Manager**: Port 7010 (manage models and outputs, protected with auth)
- **Terminal**: Port 7020 (command line access, writable, protected with auth)
- **Logs**: Port 7030 (monitor all application logs)

## Default Credentials

- Username: `admin`
- Password: `fooocus`

## Multi-Fork Docker Images

This repository also builds and publishes Docker images for multiple popular Fooocus forks. These images are automatically built daily and whenever upstream changes are detected.

### Available Fork Images

| Fork | Docker Image | Description |
|------|--------------|-------------|
| **mashb1t** | `ghcr.io/codechips/fooocus-mashb1t:latest` | Popular fork with additional features and improvements |
| **RuinedFooocus** | `ghcr.io/codechips/fooocus-ruined:latest` | Enhanced UI and additional features |
| **Fooocus Extend** | `ghcr.io/codechips/fooocus-extended:latest` | Extended functionality fork |
| **Fooocus MRE** | `ghcr.io/codechips/fooocus-mre:latest` | MoonRide303's enhanced version |

### Using Fork Images

Each fork image can be used as a drop-in replacement:

```bash
# Example: Run mashb1t's Fooocus fork
docker run -d --gpus all \
  -p 7860:7860 \
  -v ./models:/app/models \
  -v ./outputs:/app/outputs \
  ghcr.io/codechips/fooocus-mashb1t:latest

# Example: Run RuinedFooocus
docker run -d --gpus all \
  -p 7860:7860 \
  -v ./models:/app/models \
  -v ./outputs:/app/outputs \
  ghcr.io/codechips/fooocus-ruined:latest
```

### Fork Image Features

- **Automatic Updates**: Images are rebuilt daily when upstream changes are detected
- **Version Tags**: Each image is tagged with both `latest` and the commit SHA
- **Minimal Size**: Optimized Docker images with only essential dependencies
- **GPU Support**: Full CUDA 12.2 support with PyTorch pre-installed
- **Volume Mounts**: Standard model and output directories

### Fork-Specific Notes

- **mashb1t/Fooocus**: Includes advanced features like GroundingDINO, rembg, and face detection
- **RuinedFooocus**: Uses newer Gradio 5.x and has a different dependency structure (pip/modules.txt)
- **Fooocus_extend**: Includes all mashb1t features plus InsightFace and additional image processing
- **Fooocus-MRE**: Minimal requirements, closest to original Fooocus

### Build Status

The fork images are built using GitHub Actions with a matrix strategy. Check the [Actions tab](../../actions) to see the latest build status.

## Model Provisioning

The container supports external model provisioning via `PROVISION_URL` that can download models from multiple sources during startup.

### Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `PROVISION_URL` | URL to TOML configuration file for automatic provisioning | None | No |
| `WORKSPACE` | Target directory for models and data | `/workspace` | No |
| `HF_TOKEN` | HuggingFace API token for gated models | None | No |
| `CIVITAI_TOKEN` | CivitAI API token for some models | None | No |
| `USERNAME` | Authentication username for all services | `admin` | No |
| `PASSWORD` | Authentication password for all services | `fooocus` | No |
| `OPEN_BUTTON_PORT` | Port for Vast.ai "Open" button (nginx landing page) | `80` | No |
| `FOOOCUS_ARGS` | Additional arguments for Fooocus | Empty | No |
| `FOOOCUS_AUTO_UPDATE` | Enable auto-update on startup (set to "True" to enable) | Empty | No |
| `NO_ACCELERATE` | Disable accelerate optimization (enabled by default) | Empty | No |
| `ENABLE_TTYD` | Enable web terminal access (security control) | `true` | No |

### Quick Provisioning Setup

1. **Create a TOML configuration file** (see [examples](examples/)):
   ```toml
   # Basic configuration example
   [models.checkpoints.sdxl-base]
   source = "huggingface"
   repo = "stabilityai/stable-diffusion-xl-base-1.0"
   file = "sd_xl_base_1.0.safetensors"

   [models.lora.detail-tweaker]
   source = "civitai"
   model_id = "58390"
   ```

2. **Host the configuration file** (GitHub, Google Drive, S3, HTTP server, etc.)

3. **Launch container with provisioning**:
   ```bash
   docker run -d \
     -e USERNAME=admin -e PASSWORD=fooocus -e OPEN_BUTTON_PORT=80 \
     -p 80:80 -p 8010:8010 -p 7010:7010 -p 7020:7020 -p 7030:7030 \
     -e PROVISION_URL=https://drive.google.com/file/d/YOUR_FILE_ID/view \
     -e HF_TOKEN=hf_your_token_here \
     -e CIVITAI_TOKEN=your_civitai_token \
     ghcr.io/codechips/vastai-fooocus-plus:latest
   ```

### Provisioning Documentation

For detailed information about the provisioning system, including:
- Configuration format and examples
- Model sources (HuggingFace, CivitAI, URLs)
- Authentication setup
- CivitAI version ID vs model ID clarification
- Troubleshooting

See the comprehensive [PROVISION.md](PROVISION.md) documentation.

### Manual Provisioning

You can also run the provisioning script manually from inside the container:

```bash
# Access container terminal (via ttyd web interface or docker exec)
cd /opt/bin

# Provision from local file
./provision/provision.py /workspace/config.toml

# Provision from URL
./provision/provision.py https://example.com/config.toml

# Get help
./provision/provision.py --help
```

## Performance Optimization

### Accelerate Support (Enabled by Default)

The container uses HuggingFace Accelerate by default for optimized multi-core performance:

**Benefits:**
- **Multi-core optimization**: Uses `--num_cpu_threads_per_process=6` for better CPU utilization
- **Memory efficiency**: Improved memory management for large models
- **Faster loading**: Optimized model loading and inference
- **Automatic fallback**: Uses standard Python if accelerate is unavailable

**Control:**
```bash
# Disable accelerate if needed (not recommended)
-e NO_ACCELERATE=True
```

**Usage:**
- **Enabled by default**: No configuration needed for optimal performance
- **Automatic detection**: Only activates if accelerate is available
- **Safe fallback**: Uses standard Python launch if accelerate fails
- **Particularly beneficial**: On multi-core systems (most Vast.ai instances)

### TCMalloc Memory Optimization

The container automatically detects and uses TCMalloc for improved memory performance:

**Features:**
- **Automatic detection**: Finds and configures TCMalloc libraries at startup
- **glibc compatibility**: Handles different glibc versions (pre/post 2.34)
- **Memory efficiency**: Significantly reduces memory fragmentation
- **CPU performance**: Better memory allocation performance
- **Safe fallback**: Continues without TCMalloc if unavailable

**Control:**
- **Disable**: Set `NO_TCMALLOC=1` to skip TCMalloc setup
- **Manual override**: Set `LD_PRELOAD` to use custom memory allocator
- **Automatic**: Enabled by default on Linux systems

**Supported libraries:**
- `libtcmalloc-minimal4` (pre-installed in container)
- `libtcmalloc.so` variants
- Compatible with Ubuntu 22.04 glibc

## Directory Structure

```
vastai-fooocus-forks/
├── dockerfiles/                   # Shared base Docker configuration
│   └── base/                     # Shared base image (CUDA, services, deps)
│       └── Dockerfile
├── forks/                        # Fork-specific files and configurations
│   ├── mashb1t/                  # Fooocus Mashb1t fork
│   │   ├── Dockerfile            # Fork-specific Docker build
│   │   └── scripts/services/     # Fork-specific service scripts
│   │       └── fooocus.sh
│   ├── ruined/                   # RuinedFooocus fork
│   │   ├── Dockerfile
│   │   └── scripts/services/
│   │       └── fooocus.sh
│   ├── extended/                 # Fooocus Extended fork
│   │   ├── Dockerfile
│   │   └── scripts/services/
│   │       └── fooocus.sh
│   └── mre/                      # Fooocus MRE fork
│       ├── Dockerfile
│       └── scripts/services/
│           └── fooocus.sh
├── scripts/
│   ├── start.sh                   # Main orchestrator script
│   ├── services/                  # Modular service scripts
│   │   ├── utils.sh              # Shared utilities (TCMalloc, workspace)
│   │   ├── fooocus.sh            # Fooocus service (fork-aware)
│   │   ├── filebrowser.sh        # File browser service
│   │   ├── ttyd.sh               # Web terminal service
│   │   ├── logdy.sh              # Log viewer service
│   │   └── provisioning.sh       # Model provisioning service
│   └── provision/                 # Model provisioning system
│       ├── provision.py           # Main provisioning script
│       ├── config/                # Configuration parsing
│       ├── downloaders/           # Download implementations
│       ├── utils/                 # Utilities and logging
│       └── validators/            # Token validation
├── config/
│   ├── filebrowser/               # Filebrowser configuration
│   └── fooocus/                   # Fooocus configuration (if any)
├── examples/                      # Provisioning configuration examples
│   ├── provision-config.toml      # Production template
│   ├── test-provision-minimal.toml # Minimal test config
│   └── test-provision-full.toml   # Full feature example
├── provision-examples/            # External provisioning examples
│   ├── basic-models.toml          # Essential models
│   ├── comprehensive-models.toml  # Full-featured setup
│   ├── flux-models.toml           # FLUX.1-dev setup
│   ├── google-drive-example.toml  # Google Drive integration
│   └── README.md                  # Provision examples documentation
├── test_provision_local.sh        # Local testing script
├── .github/workflows/             # CI/CD workflows
│   ├── build-forks.yml           # New modular build workflow
│   └── build-matrix.yml          # Legacy workflow (DEPRECATED)
```

## Local Development

### Prerequisites
- [Docker](https://docs.docker.com/get-docker/)

### Quick Start
```bash
# Build image
docker build -t vastai-fooocus:local .

# Run container
docker run -d --name vastai-test \
  -e USERNAME=admin -e PASSWORD=fooocus -e OPEN_BUTTON_PORT=80 \
  -p 80:80 -p 8010:8010 -p 7010:7010 -p 7020:7020 -p 7030:7030 \
  vastai-fooocus:local
```

## Log Monitoring

The logdy interface (port 7030) provides real-time monitoring of:

- **Fooocus**: Complete Fooocus logs including model loading, generation progress, and errors
- **Filebrowser**: Application logs and access logs
- **ttyd**: Terminal session logs
- **Logdy**: Log viewer service logs

All logs are easily searchable through the logdy web interface.

## Security

### Authentication & Access Control

- **Unified authentication** across all services via USERNAME/PASSWORD environment variables
- **Fooocus**: Gradio built-in authentication with configurable credentials
- **Filebrowser**: Native authentication, scoped to `/workspace` directory only
- **TTYd terminal**: Basic authentication with full system access
- **Logdy**: Log viewer access

### Security Model

**Root Access**: Services run as root for maximum compatibility with AI workflows and Vast.ai platform requirements. This enables:
- GPU access and CUDA operations
- System package installation for model dependencies  
- Hardware optimization and driver management
- Full compatibility with existing AI tools and workflows

**Web Terminal Access**: TTYd provides web-based root shell access for:
- Installing additional packages and dependencies
- Debugging and troubleshooting
- Advanced system configuration
- Container management and monitoring

### Security Controls

| Control | Default | Description |
|---------|---------|-------------|
| `USERNAME` | `admin` | Authentication username for all services |
| `PASSWORD` | `fooocus` | Authentication password for all services |
| `ENABLE_TTYD` | `true` | Enable/disable web terminal access |

### Production Security Recommendations

For production deployments or enhanced security:

```bash
# Disable web terminal access
-e ENABLE_TTYD=false

# Use strong authentication credentials
-e USERNAME=your_secure_username
-e PASSWORD=your_strong_password

# Restrict network access with firewall rules
# Only expose necessary ports to trusted networks

# Consider using a reverse proxy with additional authentication layers
```

### Risk Assessment

**HIGH**: Web terminal provides full root system access
- **Mitigation**: Set strong credentials, disable TTYD if not needed, use network restrictions

**MEDIUM**: Services run with elevated privileges  
- **Mitigation**: This is intentional for AI workload compatibility

**LOW**: File browser access to workspace
- **Mitigation**: Already scoped to `/workspace` directory only

### Security Best Practices

1. **Change default credentials** before deployment
2. **Use strong passwords** for authentication
3. **Disable TTYd** (`ENABLE_TTYD=false`) if terminal access not needed
4. **Network isolation** - only expose ports to trusted networks
5. **Regular updates** - keep base images and dependencies current
6. **Monitor access logs** via the logdy interface (port 7030)

## Compatibility

- **CUDA**: 12.1 (with 12.2 base)
- **PyTorch**: 2.1.0 (with CUDA 12.1 support)
- **Python**: 3.10 (Ubuntu 22.04 default)
- **GPU**: NVIDIA GPUs with CUDA support
- **Platform**: Vast.ai, local Docker environments
- **Architecture**: x86_64 and ARM64



## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally with Docker
5. Submit a pull request

## License

This project is open source. Please check individual component licenses for specific terms.
