#!/bin/bash
if [[ -f "./wings" ]]; then
    ./wings --config ./config.yml
else
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Wings/install.sh) | tee logs/terminal.log
fi