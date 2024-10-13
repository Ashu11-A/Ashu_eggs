#!/bin/bash
if [ ! -d "src" ]; then
	git clone https://github.com/wukko/cobalt ./Cobalt
    mv Cobalt/* ./
    mv Cobalt/.git ./
    mv Cobalt/.github ./
fi

if [ ! -f "./.env" ]; then
    npm run setup
fi


if [[  -f "./.env" && -d "node_modules" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/Cobalt/version.sh)
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/Cobalt/launch.sh)
else
    echo "Algo muito errado aconteceu."
fi
