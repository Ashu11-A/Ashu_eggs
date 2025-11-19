#!/bin/bash

LOLCAT_BIN=$(command -v lolcat|| echo "/usr/games/lolcat")
echo "Paneldactyl" | figlet -c -f slant -t -k | $LOLCAT_BIN

rm -f start.sh
curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Paneldactyl/start.sh -o start.sh
chmod +x start.sh

curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Paneldactyl/install.sh -o /tmp/install.sh
chmod +x /tmp/install.sh

mkdir -p logs
bash /tmp/install.sh | tee logs/terminal.log
rm -f /tmp/install.sh