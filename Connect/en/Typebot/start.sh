#!/bin/bash
lolcat=/usr/games/lolcat
echo -e "\n \n$(figlet -c -f slant -t -k "Typebot")\n                                         by Ashu" | $lolcat

bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/Typebot/install.sh) | tee logs/terminal.log
