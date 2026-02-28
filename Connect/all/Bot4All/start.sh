#!/bin/bash

export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Lang/bot4all.conf"
source <(curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/lang.sh")

curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Bot4All/install.sh" -o /tmp/install.sh && bash /tmp/install.sh
