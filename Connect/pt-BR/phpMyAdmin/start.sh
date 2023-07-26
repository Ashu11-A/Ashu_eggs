#!/bin/bash
lolcat=/usr/games/lolcat
echo -e "\n \n$(figlet -c -f slant -t -k "phpMyAdmin")\n                                         by Ashu" | $lolcat

bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/phpMyAdmin/install.sh) | tee logs/terminal.log
