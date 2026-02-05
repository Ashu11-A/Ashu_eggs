#!/bin/bash
# shellcheck shell=dash

mkdir -p /mnt/server/
cd /mnt/server/ || exit
mkdir -p logs

apk add --no-cache curl wget file unzip zip jq

# download.sh: primary = GitHub release + checksum; fallback = wiki
curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Terraria/download.sh" -o /tmp/download.sh
# shellcheck source=/dev/null
source /tmp/download.sh

cat <<EOF >logs/run.log
${version}: ${CLEAN_VERSION}
${link}: ${WIKI_DOWNLOAD_LINK:-}
${file}: ${FILE_NAME:-}
${clean_version}: ${CLEAN_VERSION}
EOF

printf "%s\n" "$unpacking"
if [ "$DOWNLOAD_SOURCE" = "github" ] && [ -n "$FILE_NAME" ]; then
    tar -xzf "$FILE_NAME"
    rm -f "$FILE_NAME"
else
    # Wiki fallback: zip with version folder
    unzip -o "$FILE_NAME"

    EXTRACTED_ROOT_DIR=""
    # Attempt to derive the extracted directory name from FILE_NAME
    # This regex looks for a version number (can include dots) between '-' and '.zip'
    if [[ "$FILE_NAME" =~ -([0-9\.]+[0-9])\.zip$ ]]; then
        VERSION_FROM_FILENAME="${BASH_REMATCH[1]}"
        # Try dot-separated version (e.g., 1.4.5.4)
        if [ -d "${VERSION_FROM_FILENAME}/Linux" ]; then
            EXTRACTED_ROOT_DIR="${VERSION_FROM_FILENAME}"
        # Try dot-less version (e.g., 1454)
        elif [ -d "$(echo "${VERSION_FROM_FILENAME}" | sed 's/\.//g')/Linux" ]; then
            EXTRACTED_ROOT_DIR="$(echo "${VERSION_FROM_FILENAME}" | sed 's/\.//g')"
        fi
    fi

    # If not found yet, or regex failed, try to find the single top-level directory created by unzip
    if [ -z "$EXTRACTED_ROOT_DIR" ]; then
        # List directories in current location, find the newest one (likely the extracted one)
        # Or look for a common pattern "X.Y.Z.W" or "XYZW"
        # Since 'unzip' creates a single directory like '1454/' or '1.4.5.4/', we can usually find it.
        # This uses find to get the first (and hopefully only) directory created.
        TOP_LEVEL_DIR=$(find . -maxdepth 1 -mindepth 1 -type d -print -quit)
        if [ -n "$TOP_LEVEL_DIR" ]; then
            EXTRACTED_ROOT_DIR=$(basename "$TOP_LEVEL_DIR")
        fi
    fi

    if [ -z "$EXTRACTED_ROOT_DIR" ]; then
        echo "Error: Could not determine the Terraria server root directory after unzipping '$FILE_NAME'."
        echo "Please check the contents of the zip file and the script logic."
        exit 1 # Exit with error
    fi
    
    cp -rf "${EXTRACTED_ROOT_DIR}/Linux"/* ./
    rm -rf "${EXTRACTED_ROOT_DIR}"
    rm -f "$FILE_NAME"
fi

mkdir -p saves saves/Worlds # Ensure saves directories exist
chmod +x TerrariaServer.exe 2>/dev/null || true
touch banlist.txt

printf "%s\n" "$cleaning_up"
rm -f System* Mono* mscorlib.dll serverconfig.txt TerrariaServer.bin.x86_64 TerrariaServer

printf "%s\n" "$generating_config"
curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Terraria/serverconfig.txt" -o serverconfig.txt

printf "%s\n" "$install_complete"