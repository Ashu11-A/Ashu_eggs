#!/bin/bash

mkdir -p logs

rm -f start.sh
curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Paneldactyl/start.sh -o start.sh

curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Paneldactyl/install.sh -o /tmp/install.sh
bash /tmp/install.sh | tee logs/terminal.log
rm -f /tmp/install.sh