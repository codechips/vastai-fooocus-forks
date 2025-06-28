#!/usr/bin/env bash
# Fooocus Plus service

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

function provision_models() {
    # Internal model provisioning - downloads essential FooocusPlus models
    # Separate from external provisioning (PROVISION_URL) which runs earlier
    local PROVISION_MARKER="/opt/fooocus/.models_provisioned"

    if [[ ! -f "${PROVISION_MARKER}" ]] && [[ ! -f "/opt/fooocus/.models_provisioning" ]]; then
        echo "fooocus: starting internal model provisioning via parallel downloads..."
        echo "fooocus: downloading all essential FooocusPlus models"

        # Create provisioning marker to prevent duplicate runs
        touch /opt/fooocus/.models_provisioning

        # Run model provisioning in background
        (
            # Navigate to provision directory
            cd /opt/provision || exit 1

            echo "fooocus: [Provisioning] downloading models in parallel..."

            # Download essential models first
            if uv run provision.py "${WORKSPACE}/provision/essential.toml"; then
                echo "fooocus: [Provisioning] essential models downloaded successfully"
            else
                echo "fooocus: [Provisioning] WARNING: essential models download failed"
            fi

            # Download all models in parallel
            if uv run provision.py "${WORKSPACE}/provision/models.toml"; then
                echo "fooocus: [Provisioning] all models downloaded successfully"

                # List what was downloaded
                echo "fooocus: [Provisioning] downloaded models:"
                tree -L 3 ${WORKSPACE}/fooocus/models/ 2>/dev/null | head -50 || ls -la ${WORKSPACE}/fooocus/models/

                # Clean up provisioning marker and create completion marker
                rm -f /opt/fooocus/.models_provisioning
                touch "${PROVISION_MARKER}"
                echo "fooocus: [Provisioning] parallel download completed successfully"
            else
                echo "fooocus: [Provisioning] ERROR: model downloads failed!"
                rm -f /opt/fooocus/.models_provisioning
                exit 1
            fi

        ) > ${WORKSPACE}/logs/provisioning.log 2>&1 &

        echo "fooocus: model provisioning running in background (parallel downloads)"
        echo "fooocus: check ${WORKSPACE}/logs/provisioning.log for progress"
    elif [[ -f "/opt/fooocus/.models_provisioning" ]]; then
        echo "fooocus: model provisioning already in progress"
    else
        echo "fooocus: models already provisioned (found marker file)"
    fi
}

function start_fooocus() {
    echo "fooocus: starting Fooocus fork with pre-provisioned models"

    # Activate the uv-created virtual environment first
    source /opt/fooocus/.venv/bin/activate

    # Change to the Fooocus directory (required for proper operation)
    cd /opt/fooocus

    # Step 1: Install system build dependencies for Python package compilation (if needed)
    echo "fooocus: preparing build dependencies for fork package compilation..."
    apt-get update -qq
    apt-get install -y -qq --no-install-recommends \
        build-essential \
        python3-dev
    echo "fooocus: build dependencies installed - fork will handle all Python packages"
    echo "fooocus: (libgit2-dev, pkg-config, pygit2, and packaging already installed at build time)"

    # Step 2: Copy provision configs to workspace for user visibility and control
    echo "fooocus: setting up provision configs in workspace..."
    if [ ! -d "${WORKSPACE}/provision" ]; then
        mkdir -p "${WORKSPACE}/provision"
        cp -r /opt/config/provision/* "${WORKSPACE}/provision/"
        echo "fooocus: provision configs copied to ${WORKSPACE}/provision/"
        echo "fooocus: users can edit configs at ${WORKSPACE}/provision/*.toml"
    else
        echo "fooocus: provision configs already exist in workspace"
    fi

    # Step 3: Pre-provision all models BEFORE starting Fooocus
    echo "fooocus: provisioning models before Fooocus startup..."
    if [ -f "/opt/provision/provision.py" ]; then
        cd /opt/provision

        # Download essential models first (prevents CLIP startup errors)
        echo "fooocus: downloading essential models..."
        uv run provision.py "${WORKSPACE}/provision/essential.toml" || echo "Warning: Essential model download failed"

        # Run model provisioning (download all models in parallel)
        provision_models

        cd /opt/fooocus
    else
        echo "fooocus: provision script not found, skipping model download"
    fi

    # All forks use port 7860 or 7865 by default, we'll override to 8010 to match expected port
    DEFAULT_ARGS="--listen 0.0.0.0 --port 8010"

    # Get fork name for configuration decisions
    FORK_NAME=$(cat /root/FORK_NAME.txt 2>/dev/null || echo "unknown")
    
    # Handle authentication based on fork type and capabilities
    if [[ ${USERNAME} ]] && [[ ${PASSWORD} ]]; then
        echo "fooocus: enabling authentication for user: ${USERNAME}"
        
        case "${FORK_NAME}" in
            "ruined")
                # RuinedFooocus uses command line auth
                DEFAULT_ARGS="${DEFAULT_ARGS} --auth ${USERNAME}/${PASSWORD}"
                echo "fooocus: RuinedFooocus authentication enabled via --auth argument"
                ;;
            "mashb1t"|"extended"|"mre"|*)
                # All other forks use auth.json file
                cat > auth.json << EOF
[
  {
    "user": "${USERNAME}",
    "pass": "${PASSWORD}"
  }
]
EOF
                echo "fooocus: auth.json created for ${FORK_NAME} fork"
                echo "fooocus: authentication will be enabled automatically with --listen"
                ;;
        esac
    else
        echo "fooocus: starting without authentication (no USERNAME/PASSWORD set)"
        echo "fooocus: WARNING - will be accessible externally without authentication on 0.0.0.0"
        echo "fooocus: set USERNAME and PASSWORD environment variables to enable authentication"
    fi

    # Determine entry point and update behavior based on fork and settings
    if [[ "${FOOOCUS_AUTO_UPDATE}" == "True" ]] || [[ "${FOOOCUS_AUTO_UPDATE}" == "true" ]]; then
        if [[ -f "entry_with_update.py" ]]; then
            ENTRY_POINT="entry_with_update.py"
            echo "fooocus: auto-update enabled, using entry_with_update.py"
        else
            ENTRY_POINT="launch.py"
            echo "fooocus: auto-update requested but entry_with_update.py not found, using launch.py"
        fi
    else
        ENTRY_POINT="launch.py"
        echo "fooocus: auto-update disabled (default), using launch.py"
        
        # For RuinedFooocus, add offline mode to prevent updates even with launch.py
        if [[ "${FORK_NAME}" == "ruined" ]]; then
            DEFAULT_ARGS="${DEFAULT_ARGS} --offline"
            export RF_OFFLINE=1
            echo "fooocus: RuinedFooocus detected, enabling offline mode"
        fi
    fi

    # Combine default args with any custom args (after determining all arguments)
    FULL_ARGS="${DEFAULT_ARGS} ${FOOOCUS_ARGS}"

    # Prepare TCMalloc for better memory performance
    prepare_tcmalloc

    # Use accelerate by default, allow opt-out
    if [[ "${NO_ACCELERATE}" != "True" ]] && command -v accelerate >/dev/null 2>&1; then
        echo "fooocus: launching with accelerate and args: ${FULL_ARGS}"
        nohup accelerate launch --num_cpu_threads_per_process=6 ${ENTRY_POINT} ${FULL_ARGS} >${WORKSPACE}/logs/fooocus.log 2>&1 &
    else
        echo "fooocus: launching with standard python and args: ${FULL_ARGS}"
        nohup python ${ENTRY_POINT} ${FULL_ARGS} >${WORKSPACE}/logs/fooocus.log 2>&1 &
    fi

    # Clean up build dependencies after Fooocus starts (background task)
    echo "fooocus: starting background cleanup..."
    (
        # Wait for Fooocus to start up (check log for startup indicators)
        sleep 60  # Give time for startup
        
        # Look for common startup indicators in the log
        while ! (grep -q "Running on\|Share.*gradio\|localhost" ${WORKSPACE}/logs/fooocus.log 2>/dev/null); do
            sleep 15
            # Timeout after 10 minutes
            if [[ $(grep -c "sleep 15" /proc/$$/cmdline 2>/dev/null || echo 0) -gt 40 ]]; then
                echo "fooocus: startup timeout, proceeding with cleanup"
                break
            fi
        done

        echo "fooocus: Fooocus startup completed"

        echo "fooocus: cleaning up build dependencies..."
        apt-get remove -y build-essential python3-dev
        echo "fooocus: (keeping libgit2-dev, pkg-config for pygit2 compatibility)"
        apt-get autoremove -y
        apt-get clean
        rm -rf /var/lib/apt/lists/*
        echo "fooocus: build dependencies cleanup completed"
    ) >${WORKSPACE}/logs/fooocus_cleanup.log 2>&1 &

    echo "fooocus: started on port 8010"
    echo "fooocus: log file at ${WORKSPACE}/logs/fooocus.log"
    echo "fooocus: cleanup log at ${WORKSPACE}/logs/fooocus_cleanup.log"
}

# Note: Function is called explicitly from start.sh
# No auto-execution when sourced to prevent duplicate processes
