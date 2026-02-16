#!/bin/bash

printf "$script_version\n" "1.1"
echo "$learn_more"

# Define default memory if not set
if [[ -z "${SERVER_MEMORY}" ]]; then
  SERVER_MEMORY="512"
fi

printf "$starting_valkey\n" "${SERVER_PORT}"
printf "$configuring_memory\n" "${SERVER_MEMORY}"

if [[ -n "${SERVER_PASSWORD}" ]]; then
  echo "$configuring_password"
  if [[ "${SERVER_PASSWORD}" == "change this" ]]; then
    echo -e "$password_not_changed"
  fi
fi

declare -a params=(
    /home/container/valkey.conf
    --save 60 1
    --dir /home/container/
    --bind 0.0.0.0
    --port "${SERVER_PORT}"
    --maxmemory "${SERVER_MEMORY}mb"
    --pidfile "/home/container/valkey.pid"
    --daemonize yes
    --logfile "/home/container/logs/server.log"
)

if [[ -n "${SERVER_PASSWORD}" ]]; then
    params+=(--requirepass "${SERVER_PASSWORD}")
fi

declare -a cli_params=(-p "${SERVER_PORT}")
if [[ -n "${SERVER_PASSWORD}" ]]; then
    cli_params+=(-a "${SERVER_PASSWORD}")
fi

# Ensure logs directory exists
mkdir -p logs

# Execute Valkey Server in background
/usr/local/bin/valkey-server "${params[@]}"

# Wait for server to be ready
echo "$waiting_server"
MAX_RETRIES=30
RETRIES=0
until /usr/local/bin/valkey-cli -p "${SERVER_PORT}" ${SERVER_PASSWORD:+-a "${SERVER_PASSWORD}"} PING > /dev/null 2>&1; do
    sleep 1
    RETRIES=$((RETRIES + 1))
    if [ $RETRIES -ge $MAX_RETRIES ]; then
        echo "Error: Valkey server failed to start within $MAX_RETRIES seconds."
        echo "Check logs/server.log for more details."
        exit 1
    fi
done

echo "$entering_cli"

# Open CLI
/usr/local/bin/valkey-cli "${cli_params[@]}"

echo "$stopping_valkey"
/usr/local/bin/valkey-cli "${cli_params[@]}" shutdown save
