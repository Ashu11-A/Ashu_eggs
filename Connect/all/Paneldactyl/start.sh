#!/bin/bash

export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Lang/paneldactyl.conf"
curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/loadLang.sh" -o /tmp/loadLang.sh
source /tmp/loadLang.sh

echo "${start_banner_name}" | figlet -c -f slant -t -k | lolcat

curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/update.sh" | bash -s -- update "start.sh" "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Paneldactyl/start.sh" "${start_update_message}" "diff"

curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/fmt.sh" -o /tmp/fmt.sh
source /tmp/fmt.sh

curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Paneldactyl/migration.sh" -o /tmp/migration.sh
bash /tmp/migration.sh

if [[ -f "logs/panel_installed" ]] && [[ -d "/home/container/panel" ]]; then
  # Se instalado, verifica a versão e inicia o executor
  export version_egg="1.3"
  export version_script_egg="4.0-Universal"
  curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/version.sh" -o /tmp/version.sh
  bash /tmp/version.sh
  
  curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Paneldactyl/launch.sh" -o launch.sh
  chmod +x launch.sh
  ./launch.sh
else
  curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Paneldactyl/install.sh" -o install.sh
  chmod +x install.sh
  ./install.sh | tee logs/terminal.log
fi
