#!/bin/bash
if [ -f "./install.sh" ]; then
    rm ./install.sh
fi

curl -sO "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect%20(en)/Bot4All/install.sh"
chmod +x install.sh
./install.sh

