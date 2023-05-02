#!/bin/bash
bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Bot4All/install.sh) | tee logs/terminal.log

: <<'LIMBO'
lolcat=/usr/games/lolcat

nohup bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Bot4All/install.sh) >logs/terminal.log 2>&1 &

tail -f logs/terminal.log | $lolcat
LIMBO