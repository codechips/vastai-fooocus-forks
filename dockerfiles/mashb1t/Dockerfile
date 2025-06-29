# Fooocus Mashb1t fork - enhanced features with CV capabilities
ARG BASE_IMAGE=ghcr.io/codechips/fooocus-base:latest
# hadolint ignore=DL3006
FROM ${BASE_IMAGE}

# Clone Fooocus Mashb1t fork
WORKDIR /opt
RUN git clone https://github.com/mashb1t/Fooocus.git fooocus

WORKDIR /opt/fooocus
ARG FORK_COMMIT=main
RUN git checkout ${FORK_COMMIT}

# Create Python environment and install dependencies
# hadolint ignore=SC2015,DL3013,DL3042,SC1091
RUN uv venv --seed --python 3.10 .venv && \
    source .venv/bin/activate && \
    pip install --no-cache-dir --upgrade pip setuptools wheel packaging && \
    # Install PyTorch first for optimal compatibility
    pip install --no-cache-dir torch==2.1.0 torchvision==0.16.0 torchaudio --index-url https://download.pytorch.org/whl/cu121 && \
    # Install from requirements_docker.txt (preferred for Docker builds)
    if [ -f "requirements_docker.txt" ]; then \
        echo "Installing from requirements_docker.txt..." && \
        pip install --no-cache-dir -r requirements_docker.txt; \
    else \
        echo "Installing from requirements_versions.txt..." && \
        pip install --no-cache-dir -r requirements_versions.txt; \
    fi

# Set Python path for the virtual environment
ENV PYTHONPATH=/opt/fooocus/.venv/lib/python3.10/site-packages

# Capture build metadata
RUN git rev-parse HEAD > /root/BUILD_SHA.txt 2>/dev/null || echo "unknown" > /root/BUILD_SHA.txt && \
    date -u +"%Y-%m-%dT%H:%M:%SZ" > /root/BUILDTIME.txt && \
    echo "mashb1t" > /root/FORK_NAME.txt

# Clean up
RUN find /opt -name "*.pyc" -delete && \
    find /opt -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

# Entrypoint
ENTRYPOINT ["/opt/bin/start.sh"]