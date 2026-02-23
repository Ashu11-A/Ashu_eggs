#!/bin/bash

echo "⚙️  Script version: 1.6"

# Self-update
curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/update.sh | bash -s -- update "$0" "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/tModLoader/start.sh" "Updated successfully. Re-executing..." "diff" "$@"

echo "✅ Starting tModLoader"
dotnet tModLoader.dll -server "$@" -config serverconfig.txt
