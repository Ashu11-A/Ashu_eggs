#!/bin/bash
if [ -f "./start.sh" ]; then
    rm ./start.sh
fi

curl -sO https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Bot4All/start.sh
chmod +x start.sh
./start.sh

