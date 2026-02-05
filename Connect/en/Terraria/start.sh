#!/bin/bash

# Self-updating script: This script's sole purpose is to update itself from the master start.sh
# and then re-execute the updated script. The actual server logic is in the master script.

SELF_PATH_EXE="$(realpath "$0")"
START_SH_URL="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Terraria/start.sh"
LATEST_SCRIPT="/tmp/start.sh.latest" # Use a temporary file

echo "Attempting to update start.sh from master repository..."

# Attempt to download the latest version of the master start.sh
# The -f flag ensures that if the download fails (e.g., 404 error), curl will exit with an error code.
if curl -s -f "$START_SH_URL" -o "$LATEST_SCRIPT"; then
    # Replace current script with the new one
    mv "$LATEST_SCRIPT" "$SELF_PATH_EXE"
    chmod +x "$SELF_PATH_EXE" # Ensure it's executable
    echo "start.sh updated successfully. Re-executing..."
else
    echo "Error: Could not download master start.sh from $START_SH_URL."
    echo "Proceeding with the current script (which might be outdated or failed to update)."
    rm -f "$LATEST_SCRIPT" # Clean up temporary file
fi

# In either case (update successful or failed), we re-execute.
# If update was successful, this runs the *newly downloaded* script.
# If update failed, this runs the *current* script, which is all it can do.
exec "$SELF_PATH_EXE" "$@"