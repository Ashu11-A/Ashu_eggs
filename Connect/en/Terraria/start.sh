#!/bin/bash

echo "⚙️  Script version: 1.6"

mkdir -p logs
echo "en" > logs/language.conf

# Self-update (redirect to 'all')
curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/update.sh | bash -s -- update "$0" "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Terraria/start.sh" "Updated successfully. Re-executing..." "force" "$@"
