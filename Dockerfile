# Multi-fork Fooocus Docker image with full services
FROM nvidia/cuda:12.2.2-base-ubuntu22.04

# Build arguments
ARG FORK_REPO
ARG FORK_COMMIT
ARG FORK_NAME
ARG DEBIAN_FRONTEND=noninteractive

# Set shell with pipefail for safety
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=on \
    SHELL=/bin/bash \
    PYTHONPATH=/opt/fooocus/.venv/lib/python3.10/site-packages

# Install system dependencies and uv in one layer, then clean up
# hadolint ignore=DL3008
RUN apt-get update && \
    # Install runtime dependencies (no Python packages - uv will handle Python)
    apt-get install -y --no-install-recommends \
    curl \
    git \
    build-essential \
    python3-dev \
    libgl1 \
    libglib2.0-0 \
    libgomp1 \
    libglfw3 \
    libgles2 \
    libtcmalloc-minimal4 \
    bc \
    nginx-light \
    tmux \
    tree \
    nano \
    vim \
    htop \
    # Additional dependencies for Fooocus features
    ffmpeg \
    libsm6 \
    libxext6 \
    libxrender-dev \
    # pygit2 dependencies
    libgit2-1.1 \
    libgit2-dev \
    pkg-config \
    # 7zip for SupportPack extraction
    p7zip-full \
    # Additional for opencv
    libopencv-dev \
    # Additional for insightface
    cmake \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    # Install uv for fast venv creation (but use pip for package installations)
    && curl -LsSf https://astral.sh/uv/install.sh | bash \
    && mv /root/.local/bin/uv /usr/local/bin/uv

# Install ttyd and logdy (architecture-aware)
RUN if [ "$(uname -m)" = "x86_64" ]; then \
    curl -L --progress-bar https://github.com/tsl0922/ttyd/releases/download/1.7.4/ttyd.x86_64 -o /usr/local/bin/ttyd && \
    curl -L --progress-bar https://github.com/logdyhq/logdy-core/releases/download/v0.13.0/logdy_linux_amd64 -o /usr/local/bin/logdy; \
    else \
    curl -L --progress-bar https://github.com/tsl0922/ttyd/releases/download/1.7.4/ttyd.aarch64 -o /usr/local/bin/ttyd && \
    curl -L --progress-bar https://github.com/logdyhq/logdy-core/releases/download/v0.13.0/logdy_linux_arm64 -o /usr/local/bin/logdy; \
    fi && \
    chmod +x /usr/local/bin/ttyd /usr/local/bin/logdy

# Install filebrowser and set up directories
RUN curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash && \
    mkdir -p /workspace/logs /opt/fooocus /root/.config

# Clone the specified fork (version-dependent layer)
WORKDIR /opt
RUN git clone https://github.com/${FORK_REPO}.git fooocus && \
    cd fooocus && \
    git checkout ${FORK_COMMIT}

WORKDIR /opt/fooocus

# Create Python environment with uv (fast)
# hadolint ignore=SC2015,DL3013
RUN uv venv --seed --python 3.10 .venv && \
    source .venv/bin/activate && \
    # Install essential system packages needed for pip to function
    pip install --upgrade pip setuptools wheel packaging && \
    # Install PyTorch first (common across most forks)
    if [ "${FORK_REPO}" != "runew0lf/RuinedFooocus" ]; then \
        pip install torch==2.1.0 torchvision==0.16.0 torchaudio --index-url https://download.pytorch.org/whl/cu121; \
    fi && \
    # Install fork-specific requirements
    if [ -f "requirements_docker.txt" ]; then \
        echo "Installing from requirements_docker.txt..." && \
        pip install -r requirements_docker.txt; \
    fi && \
    if [ -f "requirements_versions.txt" ]; then \
        echo "Installing from requirements_versions.txt..." && \
        pip install -r requirements_versions.txt; \
    elif [ -f "pip/modules.txt" ]; then \
        echo "Installing from pip/modules.txt (RuinedFooocus)..." && \
        pip install -r pip/modules.txt; \
    elif [ -f "requirements.txt" ]; then \
        echo "Installing from requirements.txt..." && \
        pip install -r requirements.txt; \
    else \
        echo "Warning: No requirements file found!"; \
    fi

# Clean up build dependencies and cache
RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create required directories
RUN mkdir -p /opt/bin /opt/provision /opt/nginx/html /opt/config

# Copy configuration files and scripts (frequently changing layer)
COPY config/filebrowser/filebrowser.json /root/.filebrowser.json
COPY config/nginx/sites-available/default /etc/nginx/sites-available/default
COPY scripts/start.sh /opt/bin/start.sh
COPY scripts/services/ /opt/bin/services/
COPY scripts/provision/ /opt/provision/

# Copy HTML templates directly to nginx directory
COPY config/nginx/html/ /opt/nginx/html/

# Copy provision configurations
COPY config/provision/ /opt/config/provision/

# Configure filebrowser, set permissions, and final cleanup
# hadolint ignore=SC2015
RUN chmod +x /opt/bin/start.sh /opt/bin/services/*.sh /opt/provision/provision.py && \
    # Capture build metadata
    date -u +"%Y-%m-%dT%H:%M:%SZ" > /root/BUILDTIME.txt && \
    cd /opt/fooocus && git rev-parse HEAD > /root/BUILD_SHA.txt 2>/dev/null || echo "unknown" > /root/BUILD_SHA.txt && \
    echo "${FORK_NAME}" > /root/FORK_NAME.txt && \
    filebrowser config init && \
    filebrowser users add admin admin --perm.admin && \
    # Final cleanup
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    # Remove any remaining build artifacts
    find /opt -name "*.pyc" -delete && \
    find /opt -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

# Set environment variables
ENV USERNAME=admin \
    PASSWORD=fooocus \
    WORKSPACE=/workspace \
    FOOOCUS_ARGS="" \
    FOOOCUS_AUTO_UPDATE="" \
    NO_ACCELERATE="" \
    OPEN_BUTTON_PORT=80

# Expose ports
EXPOSE 80 8010 7010 7020 7030

# Set working directory
WORKDIR /workspace

# Entrypoint
ENTRYPOINT ["/opt/bin/start.sh"]