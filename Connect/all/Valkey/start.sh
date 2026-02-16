#!/bin/bash

mkdir -p logs
if [[ ! -f "logs/language.conf" ]]; then
    echo "en" > logs/language.conf
fi

export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Lang/valkey.conf"
curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/loadLang.sh -o /tmp/loadLang.sh
source /tmp/loadLang.sh

if [[ -f "valkey.conf" ]]; then
    curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Valkey/launch.sh -o launch.sh
    bash launch.sh
else
    curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Valkey/install.sh -o install.sh
    bash install.sh | tee logs/terminal.log
fi
