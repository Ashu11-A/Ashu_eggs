#!/bin/bash

curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Paneldactyl/install.sh -o /tmp/install_redirect.sh
bash /tmp/install_redirect.sh | tee logs/terminal.log
rm -f /tmp/install_redirect.sh