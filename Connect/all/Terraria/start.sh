#!/bin/bash

export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Lang/terraria.conf"
curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/loadLang.sh" -o /tmp/loadLang.sh
source /tmp/loadLang.sh

if [ -f "./TerrariaServer.exe" ]; then
    curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Terraria/launch.sh" -o launch.sh
    bash launch.sh
else
    curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Terraria/install.sh" -o install.sh
    bash install.sh | tee logs/terminal.log
fi