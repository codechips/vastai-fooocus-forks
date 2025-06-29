#!/usr/bin/env bash
# Fooocus Plus service

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"


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

    # Note: Only external provisioning via PROVISION_URL is supported
    # Internal provisioning has been removed for simplicity

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
