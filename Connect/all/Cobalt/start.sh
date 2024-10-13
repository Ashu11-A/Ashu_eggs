#!/bin/bash
mkdir -p logs

export version_egg="1.0"
export version_script="1.0"

export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/refs/heads/main/Lang/cobalt.conf"
source <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/refs/heads/main/Utils/loadLang.sh)

bash <(curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Cobalt/install.sh") | tee logs/terminal.log
