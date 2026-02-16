#!/bin/bash

printf "$script_version\n" "1.0"
echo "$learn_more"

# Define default memory if not set
if [[ -z "${SERVER_MEMORY}" ]]; then
  SERVER_MEMORY="512"
fi

printf "$starting_valkey\n" "${SERVER_PORT}"
printf "$configuring_memory\n" "${SERVER_MEMORY}"

if [[ -n "${SERVER_PASSWORD}" ]]; then
  echo "$configuring_password"
fi

echo "$entering_cli"

declare -a params=(
    /home/container/valkey.conf
    --save 60 1
    --dir /home/container/
    --bind 0.0.0.0
    --port "${SERVER_PORT}"
    --maxmemory "${SERVER_MEMORY}mb"
    --daemonize yes
)

if [[ -n "${SERVER_PASSWORD}" ]]; then
    params+=(--requirepass "${SERVER_PASSWORD}")
fi

declare -a cli_params=(-p "${SERVER_PORT}")
if [[ -n "${SERVER_PASSWORD}" ]]; then
    cli_params+=(-a "${SERVER_PASSWORD}")
fi

# Execute Valkey Server in background, then open CLI
# When CLI is closed, shutdown the server safely
/usr/local/bin/valkey-server "${params[@]}" && \
    /usr/local/bin/valkey-cli "${cli_params[@]}"

echo "$stopping_valkey"
/usr/local/bin/valkey-cli "${cli_params[@]}" shutdown save
