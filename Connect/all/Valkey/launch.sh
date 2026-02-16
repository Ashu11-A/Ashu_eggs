#!/bin/bash

# Standardize output
printf "$script_version\n" "1.4"
echo "$learn_more"

# Define default memory if not set
if [[ -z "${SERVER_MEMORY}" ]]; then
  SERVER_MEMORY="512"
fi

printf "$starting_valkey\n" "${SERVER_PORT}"
printf "$configuring_memory\n" "${SERVER_MEMORY}"

if [[ -n "${SERVER_PASSWORD}" ]]; then
    if [[ "${SERVER_PASSWORD}" == "change this" ]]; then
        echo -e "$password_not_changed"
    fi
fi

# Ensure logs directory exists
mkdir -p logs
touch logs/server.log

# Show logs in terminal
tail -n 0 -f logs/server.log &
LOG_PID=$!

declare -a params=(
    /home/container/valkey.conf
    --save 60 1
    --dir /home/container/
    --bind 0.0.0.0
    --port "${SERVER_PORT}"
    --maxmemory "${SERVER_MEMORY}mb"
    --pidfile "/home/container/valkey.pid"
    --logfile "/home/container/logs/server.log"
)

if [[ -n "${SERVER_PASSWORD}" ]]; then
    params+=(--requirepass "${SERVER_PASSWORD}")
fi

# Function to handle shutdown and cleanup tail
cleanup() {
    kill "$LOG_PID" 2>/dev/null
    exit 0
}
trap cleanup SIGINT SIGTERM

# Execute Valkey Server
/usr/local/bin/valkey-server "${params[@]}"
