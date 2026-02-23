#!/bin/bash

mkdir -p logs
echo "pt" > logs/language.conf

# Bootstrap start.sh from master
curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/update.sh | bash -s -- bootstrap "start.sh" "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Terraria/start.sh" "$@"
