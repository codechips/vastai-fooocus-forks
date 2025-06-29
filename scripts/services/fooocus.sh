#!/usr/bin/env bash
# Fooocus Plus service

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"


function start_fooocus() {
    echo "fooocus: starting Fooocus fork with pre-provisioned models"
    cd /opt/fooocus
    source .venv/bin/activate

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


    echo "fooocus: started on port 8010"
    echo "fooocus: log file at ${WORKSPACE}/logs/fooocus.log"
}

# Note: Function is called explicitly from start.sh
# No auto-execution when sourced to prevent duplicate processes
