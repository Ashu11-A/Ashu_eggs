#!/bin/bash
mkdir -p logs

export version_egg="1.0"
export version_script_egg="1.0"

export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/refs/heads/main/Lang/cobalt.conf"
curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/lang.sh" -o /tmp/lang.sh
# shellcheck source=/dev/null
source /tmp/lang.sh

curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Cobalt/install.sh" -o /tmp/install.sh
bash /tmp/install.sh | tee logs/terminal.log
