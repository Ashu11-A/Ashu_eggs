#!/bin/bash

echo "⚙️  Script version: 1.6"

# Self-update
curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/update.sh | bash -s -- update "$0" "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/tModLoader/start.sh" "Updated successfully. Re-executing..." "diff" "$@"

mkdir -p logs

if [ -f "./tModLoader.dll" ]; then
    curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/tModLoader/launch.sh" -o launch.sh
    bash launch.sh "$@"
else
    curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/tModLoader/install.sh" -o install.sh
    bash install.sh | tee logs/terminal.log
fi
