#!/bin/bash
export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Lang/jellyfin.conf"

BASE_DIR="/mnt/server"
[[ -d "/home/container" ]] && BASE_DIR="/home/container"
cd "$BASE_DIR" || exit 1
mkdir -p logs
[[ -f "logs/language.conf" ]] || echo "en" > logs/language.conf
source <(curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/lang.sh") || true
set -a

bash <(curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Jellyfin/install.sh) || exit 1
bash <(curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Jellyfin/launch.sh)
