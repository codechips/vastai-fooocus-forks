#!/usr/bin/env bash
# Filebrowser service

function start_filebrowser() {
    echo "filebrowser: starting"
    cd /root

    # Remove existing database to ensure clean initialization
    rm -f /root/filebrowser.db

    # Initialize database and create admin user
    echo "filebrowser: initializing database"
    if ! /usr/local/bin/filebrowser config init --minimum-password-length 5; then
        echo "filebrowser: ERROR - Failed to initialize database"
        return 1
    fi
    
    # Set the password to use (default to fooocus if not provided)
    ADMIN_PASSWORD="${PASSWORD:-fooocus}"
    
    # Validate password length (minimum 5 characters as per config)
    if [[ ${#ADMIN_PASSWORD} -lt 5 ]]; then
        echo "filebrowser: ERROR - Password must be at least 5 characters long (provided: '${ADMIN_PASSWORD}')"
        echo "filebrowser: Cannot proceed with password shorter than minimum length"
        return 1
    fi
    
    # Create admin user with the specified password
    echo "filebrowser: creating admin user"
    if ! /usr/local/bin/filebrowser users add admin "${ADMIN_PASSWORD}" --perm.admin; then
        echo "filebrowser: ERROR - Failed to create admin user"
        return 1
    fi
    
    echo "filebrowser: admin user created successfully"

    # Start filebrowser in background
    nohup /usr/local/bin/filebrowser >"${WORKSPACE}/logs/filebrowser.log" 2>&1 &
    echo "filebrowser: started on port 7010"
    echo "filebrowser: log file at ${WORKSPACE}/logs/filebrowser.log"
}

# Note: Function is called explicitly from start.sh
# No auto-execution when sourced to prevent duplicate processes