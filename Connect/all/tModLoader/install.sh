#!/bin/bash

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

get_download_url() {
  local target_version="${VERSION:-latest}"
  local releases_json
  local download_url=""

  if [ "$target_version" == "latest" ] || [ -z "$target_version" ]; then
    echo "Fetching the latest version..." >&2
    releases_json=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases/latest")
    download_url=$(echo "$releases_json" | jq -r '.assets[] | select(.name | test("tModLoader.zip"; "i")) | .browser_download_url')
  else
    echo "Fetching specific version: $target_version" >&2
    
    # MUDANÇA PRINCIPAL: Busca direta pelo endpoint de TAGS
    # Isso evita o problema de paginação (limite de 30 itens) da API
    local specific_release_json
    specific_release_json=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases/tags/$target_version")
    
    # Verifica se o ID do release existe no retorno (se não existir, a tag é inválida/não encontrada)
    local release_id
    release_id=$(echo "$specific_release_json" | jq -r .id)

    if [ "$release_id" != "null" ]; then
      # Lógica de seleção de arquivo
      if [[ "$target_version" == v* ]]; then
        # Tenta encontrar versão específica Linux, se não, pega o zip padrão
        download_url=$(echo "$specific_release_json" | jq -r '.assets[] | select(.name | test("linux.*zip|tmodloader.zip"; "i")) | .browser_download_url' | head -1)
      else
        download_url=$(echo "$specific_release_json" | jq -r '.assets[] | select(.name | test("tModLoader.zip"; "i")) | .browser_download_url')
      fi
    else
      echo "Requested version not found via API. Downloading the latest version instead..." >&2
      releases_json=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases/latest")
      download_url=$(echo "$releases_json" | jq -r '.assets[] | select(.name | test("tModLoader.zip"; "i")) | .browser_download_url')
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
  rm -rf ".local/share/Terraria/ModLoader/Mods"
  rm -f terraria-server-*.zip
  rm -rf DedicatedServerUtils LaunchUtils PlatformVariantLibs tModPorter RecentGitHubCommits.txt *.bat start-* serverconfig.txt
}

install_tmodloader() {
  echo "Starting installation process..."

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