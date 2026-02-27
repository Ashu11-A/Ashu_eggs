#!/bin/bash
echo -e "\n \n$(figlet -c -f slant -t -k "phpMyAdmin")\n                                         by Ashu" | lolcat

curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/phpMyAdmin/install.sh" -o /tmp/install.sh
bash /tmp/install.sh | tee logs/terminal.log
