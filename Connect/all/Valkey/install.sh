#!/bin/bash

mkdir -p logs

printf "%s\n" "$setting_up_config"

if [[ ! -f "valkey.conf" ]]; then
    # Resolve version for config download (e.g., 9.0.2 -> 9.0)
    V_BRANCH=$(echo "${VALKEY_VERSION:-9.0}" | cut -d. -f1,2)
    curl -sSL "https://raw.githubusercontent.com/valkey-io/valkey/refs/heads/${V_BRANCH}/valkey.conf" -o valkey.conf
fi

printf "%s\n" "$installation_complete"
exit 0
