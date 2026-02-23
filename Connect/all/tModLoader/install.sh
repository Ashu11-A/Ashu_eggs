#!/bin/bash

mkdir -p logs

# Detect startup loop if STARTUP is set to ./install.sh
if [[ "$STARTUP" == "./install.sh" ]]; then
    ATTEMPTS_FILE="logs/attempts.conf"
    current_attempts=$(cat "$ATTEMPTS_FILE" 2>/dev/null || echo 0)

    if [[ $current_attempts -lt 2 ]]; then
        echo $((current_attempts + 1)) > "$ATTEMPTS_FILE"
        printf "Detected STARTUP as ./install.sh. Redirecting to start.sh (Attempt $((current_attempts + 1)))\n"
        curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/tModLoader/start.sh" -o start.sh
        chmod +x start.sh
        exec bash start.sh
    else
        printf "Max redirection attempts reached. Proceeding with installation...\n"
        rm -f "$ATTEMPTS_FILE"
    fi
fi

DLL_DOWNLOAD_URL="https://github.com/Ashu11-A/Ashu_eggs/releases/download/tmodloader-arm64/Steamworks.NET.dll"
STEAMWORKS_TARGET_PATH="Libraries/steamworks.net/20.1.0/lib/netstandard2.1/Steamworks.NET.dll"

# download.sh resolves the version and download link
curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/tModLoader/download.sh" -o /tmp/download.sh
# shellcheck source=/dev/null
source /tmp/download.sh

# Backup old version
if [ -f "tModLoaderServer" ]; then
    printf "Moving old files to tModLoader_OLD...\n"
    mkdir -p tModLoader_OLD
    mv ./* tModLoader_OLD/ 2>/dev/null || true
fi

printf "Downloading: %s (%s)\n" "$FILE_NAME" "$TAG_NAME"
curl -sSL "$DOWNLOAD_LINK" -o "$FILE_NAME"

printf "Extracting files...\n"
unzip -o "$FILE_NAME"
rm -f "$FILE_NAME"

# Download tModLoader-sync if available
if [ -n "$SYNC_DOWNLOAD_LINK" ]; then
    printf "Downloading: tml-sync (Latest)\n"
    curl -sSL "$SYNC_DOWNLOAD_LINK" -o "$SYNC_FILE_NAME"
    chmod +x "$SYNC_FILE_NAME"
fi

# Save version (Year.Month)
# Example: v2026.02.1.4 -> 2026.02
short_version=$(echo "$TAG_NAME" | sed 's/^v//' | cut -d. -f1,2)
echo "$short_version" > logs/tml_version.conf

mkdir -p Mods
touch ./Mods/enabled.json
touch ./banlist.txt

# Patch Steamworks
if [[ -f "$STEAMWORKS_TARGET_PATH" ]]; then
    printf "Patching Steamworks.NET.dll...\n"
    rm -f "$STEAMWORKS_TARGET_PATH"
    curl -sSL "$DLL_DOWNLOAD_URL" -o "$STEAMWORKS_TARGET_PATH"
else
    printf "Steamworks.NET.dll not found at %s. Skipping patch.\n" "$STEAMWORKS_TARGET_PATH"
fi

printf "Setting permissions...\n"
chmod -R 755 ./*
chmod +x tModLoaderServer*

printf "Cleaning up...\n"
rm -rf ".local/share/Terraria/ModLoader/Mods"
rm -f terraria-server-*.zip
rm -rf DedicatedServerUtils LaunchUtils PlatformVariantLibs tModPorter RecentGitHubCommits.txt *.bat start-* serverconfig.txt

printf "Generating configuration...\n"
curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/tModLoader/serverconfig.txt" -o serverconfig.txt

printf "Saving environment data...\n"
{
    echo "CLEAN_VERSION=\"$CLEAN_VERSION\""
    echo "DOWNLOAD_LINK=\"$DOWNLOAD_LINK\""
    echo "TAG_NAME=\"$TAG_NAME\""
    echo "FILE_NAME=\"$FILE_NAME\""
    echo "SYNC_DOWNLOAD_LINK=\"$SYNC_DOWNLOAD_LINK\""
    echo "SYNC_FILE_NAME=\"$SYNC_FILE_NAME\""
} > logs/environment-server.log

printf "Installation complete.\n"
