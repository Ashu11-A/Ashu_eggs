#!/bin/bash

curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/update.sh | bash -s -- update "$0" "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Stress/start.sh" "Updated successfully. Re-executing..." "diff" "$@"

export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Lang/stress.conf"
curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/lang.sh" -o /tmp/lang.sh
source /tmp/lang.sh

printf "${script_version}\n" "1.2"
echo "$updating"

curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Stress/launch.sh" -o launch.sh
exec bash launch.sh
