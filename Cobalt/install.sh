#!/bin/bash
if [ ! -d "src" ]; then
    git clone https://github.com/wukko/cobalt .
fi

if [ ! -f "./.env" ]; then
    npm run setup
fi


if [[  -f "./.env" && -d "node_modules" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Cobalt/version.sh)
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Cobalt/launch.sh)
else
    echo "Algo muito errado aconteceu."
fi
