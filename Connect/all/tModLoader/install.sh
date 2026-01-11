#!/bin/bash
SERVER_DIR="/mnt/server"
GITHUB_PACKAGE="tModLoader/tModLoader"
DLL_DOWNLOAD_URL="https://github.com/Ashu11-A/Ashu_eggs/releases/download/tmodloader-arm64/Steamworks.NET.dll"
START_SCRIPT_URL="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/tModLoader/start.sh"
SELF_UPDATE_URL="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/tModLoader/install.sh"
STEAMWORKS_TARGET_PATH="Libraries/steamworks.net/20.1.0/lib/netstandard2.1/Steamworks.NET.dll"

check_self_update() {
  local temp_script="/tmp/install_update.sh"
  local current_script
  current_script=$(readlink -f "$0")

  echo "Checking for installation script updates..."
  curl -sSL "$SELF_UPDATE_URL" -o "$temp_script"

  if [ -s "$temp_script" ]; then
    local current_hash
    local new_hash
    
    current_hash=$(md5sum "$current_script" | awk '{print $1}')
    new_hash=$(md5sum "$temp_script" | awk '{print $1}')

    if [ "$current_hash" != "$new_hash" ]; then
      echo "New version found. Updating..."
      cat "$temp_script" > "$current_script"
      chmod +x "$current_script"
      rm -f "$temp_script"
      
      echo "Restarting script with the new version..."
      # O "$@" aqui garante que os argumentos originais sejam passados para o novo processo
      exec "$current_script" "$@"
    else
      echo "Script is already up to date."
      rm -f "$temp_script"
    fi
  else
    echo "Warning: Failed to download update. Proceeding with current version..."
    rm -f "$temp_script"
  fi
}

install_dependencies() {
  echo "Installing system dependencies..."
  # Instala apenas se necessário (Alpine)
  apk add --no-cache curl jq unzip file
}

get_download_url() {
  local target_version="${VERSION:-latest}"
  local releases_json
  local download_url=""

  if [ "$target_version" == "latest" ] || [ -z "$target_version" ]; then
    echo "Fetching the latest version..."
    releases_json=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq -c '.[]' | head -1)
    download_url=$(echo "$releases_json" | jq .assets | jq -r .[].browser_download_url | grep -i tmodloader.zip)
  else
    echo "Fetching specific version: $target_version"
    local all_releases
    all_releases=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq '.[]')
    
    local version_check
    version_check=$(echo "$all_releases" | jq -r --arg VER "$target_version" '. | select(.tag_name==$VER) | .tag_name')

    if [ "$target_version" == "$version_check" ]; then
      if [[ "$target_version" == v* ]]; then
        download_url=$(echo "$all_releases" | jq -r --arg VER "$target_version" '. | select(.tag_name==$VER) | .assets[].browser_download_url' | grep -i linux | grep -i zip)
      else
        download_url=$(echo "$all_releases" | jq -r --arg VER "$target_version" '. | select(.tag_name==$VER) | .assets[].browser_download_url' | grep -i tmodloader.zip)
      fi
    else
      echo "Requested version not found. Downloading the latest version instead..."
      releases_json=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq -c '.[]' | head -1)
      download_url=$(echo "$releases_json" | jq .assets | jq -r .[].browser_download_url | grep -i tmodloader.zip)
    fi
  fi

  echo "$download_url"
}

patch_steamworks() {
  echo "Patching Steamworks.NET.dll..."
  rm -f "$STEAMWORKS_TARGET_PATH"
  
  local temp_dll="Steamworks.NET.dll"
  curl -sSL "$DLL_DOWNLOAD_URL" -o "$temp_dll"
  
  mkdir -p "$(dirname "$STEAMWORKS_TARGET_PATH")"
  mv "$temp_dll" "$STEAMWORKS_TARGET_PATH"
}

generate_configs() {
  echo "Generating configuration files..."
  touch ./Mods/enabled.json
  touch ./banlist.txt

  cat <<EOF > serverconfig.txt
||----------------------------------------------------------------||
Note: To change any value go to Startup, and change there!
||----------------------------------------------------------------||
world=
worldpath=
modpath=
banlist=
port=
||----------------------------------------------------------------||
worldname=
maxplayers=
difficulty=
autocreate=
slowliquids=
seed=
motd=
||----------------------------------------------------------------||
password=
secure=
language=
EOF
}

cleanup_installation() {
  echo "Cleaning up temporary and unnecessary files..."
  rm -rf "$SERVER_DIR/.local/share/Terraria/ModLoader/Mods"
  rm -f terraria-server-*.zip
  rm -rf DedicatedServerUtils LaunchUtils PlatformVariantLibs tModPorter RecentGitHubCommits.txt *.bat *.sh serverconfig.txt
}

install_tmodloader() {
  echo "Starting installation process..."
  
  install_dependencies
  mkdir -p "$SERVER_DIR"
  cd "$SERVER_DIR" || exit

  # Backup da versão anterior
  if [ -f "tModLoaderServer" ]; then
    echo "Moving old files to tModLoader_OLD..."
    mkdir -p tModLoader_OLD
    mv ./* tModLoader_OLD/ 2>/dev/null || true
  fi

  local download_link
  download_link=$(get_download_url)
  local filename="${download_link##*/}"

  echo "Downloading: $filename"
  curl -sSL "$download_link" -o "$filename"

  echo "Extracting files..."
  unzip -o "$filename"
  rm -f "$filename"

  mkdir -p Mods
  patch_steamworks

  echo "Setting permissions..."
  chmod -R 755 ./*
  chmod +x tModLoaderServer*

  cleanup_installation
  generate_configs

  echo "Installation complete."
}

start_server() {
  echo "Preparing startup..."
  curl -sSL "$START_SCRIPT_URL" -o start.sh
  chmod +x start.sh
  ./start.sh
}

# ==============================================================================
# MAIN EXECUTION
# ==============================================================================

check_self_update "$@"

if [ -f "./tModLoader.dll" ]; then
  start_server
else
  install_tmodloader
fi