#!/usr/bin/env bash
# Fooocus MRE fork service

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"


function start_fooocus() {
    echo "fooocus: starting Fooocus MRE fork with pre-provisioned models"
    cd /opt/fooocus
    source .venv/bin/activate

    # MRE fork uses port 7860 by default, we'll override to 8010 to match expected port
    DEFAULT_ARGS="--listen 0.0.0.0 --port 8010"

    # Handle authentication for MRE fork
    if [[ ${USERNAME} ]] && [[ ${PASSWORD} ]]; then
        echo "fooocus: creating auth.json for user: ${USERNAME}"
        
        # MRE fork uses auth.json file
        cat > auth.json << EOF
[
  {
    "user": "${USERNAME}",
    "pass": "${PASSWORD}"
  }
]
EOF
        echo "fooocus: auth.json created for MRE fork"
        echo "fooocus: WARNING: MRE fork only enables authentication with --share flag"
        echo "fooocus: Without --share, the service will be accessible without authentication"
        echo "fooocus: Consider using a different fork if network authentication is required"
        
        # Optionally add --share if you want to enable auth (but this creates a public link)
        # DEFAULT_ARGS="${DEFAULT_ARGS} --share"
    else
        echo "fooocus: starting without authentication (no USERNAME/PASSWORD set)"
        echo "fooocus: WARNING - will be accessible externally without authentication on 0.0.0.0"
        echo "fooocus: set USERNAME and PASSWORD environment variables to enable authentication"
    fi

    # Determine entry point and update behavior based on settings
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
    fi

    # Combine default args with any custom args
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

    echo "fooocus: MRE fork started on port 8010"
    echo "fooocus: log file at ${WORKSPACE}/logs/fooocus.log"
}

# Note: Function is called explicitly from start.sh
# No auto-execution when sourced to prevent duplicate processes