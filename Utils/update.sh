#!/bin/bash

# Standardized update utility for Ashu_eggs
# Use this to avoid redundancy in start.sh and install.sh scripts.
# Usage: curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/update.sh | bash -s -- <type> <args>

TYPE="$1"
shift

update_script() {
    local SCRIPT_PATH="$1"
    local UPDATE_URL="$2"
    local MSG="$3"
    local MODE="${4:-diff}" # diff or force
    shift 4
    local ARGS=("$@")

    local TMP_FILE="/tmp/update_script.latest"
    
    if curl -sSL -f "$UPDATE_URL" -o "$TMP_FILE"; then
        local SHOULD_UPDATE=false
        if [[ "$MODE" == "force" ]]; then
            SHOULD_UPDATE=true
        elif [[ -f "$SCRIPT_PATH" ]]; then
            if ! diff -q "$SCRIPT_PATH" "$TMP_FILE" > /dev/null 2>&1; then
                SHOULD_UPDATE=true
            fi
        else
            SHOULD_UPDATE=true
        fi

        if [[ "$SHOULD_UPDATE" == "true" ]]; then
            mv "$TMP_FILE" "$SCRIPT_PATH"
            chmod +x "$SCRIPT_PATH"
            [[ -n "$MSG" ]] && echo "✅ $MSG"

            # Ensure the path is executable by prefixing with ./ if it's a relative path
            local EXEC_PATH="$SCRIPT_PATH"
            if [[ "$EXEC_PATH" != /* && "$EXEC_PATH" != ./* ]]; then
                EXEC_PATH="./$EXEC_PATH"
            fi

            exec "$EXEC_PATH" "${ARGS[@]}"
        fi
        rm -f "$TMP_FILE"
    else
        if [[ "$MODE" == "force" ]]; then
            echo "❌ Error: Could not download script from $UPDATE_URL"
            exit 1
        fi
    fi
}

bootstrap_script() {
    local TARGET_FILE="$1"
    local URL="$2"
    shift 2
    local ARGS=("$@")

    if curl -sSL -f "$URL" -o "$TARGET_FILE"; then
        chmod +x "$TARGET_FILE"
        exec ./"$TARGET_FILE" "${ARGS[@]}"
    else
        echo "❌ Error: Could not bootstrap $TARGET_FILE from $URL"
        exit 1
    fi
}

case "$TYPE" in
    update)
        update_script "$@"
        ;;
    bootstrap)
        bootstrap_script "$@"
        ;;
    *)
        echo "Usage: update.sh <update|bootstrap> <args>"
        exit 1
        ;;
esac
