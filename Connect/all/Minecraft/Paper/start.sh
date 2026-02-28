#!/bin/bash

bold="\e[1m"
lightblue="\e[94m"
normal="\e[0m"

curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/update.sh | bash -s -- update "$0" "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Minecraft/Paper/start.sh" "Updated successfully. Re-executing..." "diff" "$@"

export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Lang/paper.conf"
curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/lang.sh" -o /tmp/lang.sh
source /tmp/lang.sh

if [ -f "${SERVER_JARFILE}" ]; then
    echo -e "${bold}${lightblue}${starting_paper}${normal}"
    curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Minecraft/Paper/launch.sh" -o launch.sh
    bash launch.sh "$@"
else
    echo -e "${bold}${lightblue}${jar_not_found}${normal}"
    curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Minecraft/Paper/install.sh" -o install.sh
    bash install.sh | tee logs/terminal.log
fi
