#!/bin/bash
lolcat=/usr/games/lolcat
echo -e "\n \n$(figlet -c -f slant -t -k "Egg CtrlPanel")\n                                         by Ashu" | $lolcat

curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/CtrlPanel/install.sh" -o /tmp/install.sh && bash /tmp/install.sh | tee logs/terminal.log
