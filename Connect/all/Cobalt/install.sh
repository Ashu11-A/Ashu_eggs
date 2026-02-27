#!/bin/bash

if [ ! -d "src" ]; then
	git clone https://github.com/wukko/cobalt ./Cobalt
    mv Cobalt/* ./
    mv Cobalt/.git ./
    mv Cobalt/.github ./
fi

if [ ! -f "./api/.env" ]; then
    (
        cd api || exit
        npm i
        npm run setup
    )
fi

(
    cd web || exit
    npm i
)


if [[  -f "./api/.env" && -d "api/node_modules" && -d "web/node_modules" ]]; then
    curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/version.sh" -o /tmp/version.sh && bash /tmp/version.sh
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Cobalt/launch.sh)
else
    echo "$error_install"
fi
