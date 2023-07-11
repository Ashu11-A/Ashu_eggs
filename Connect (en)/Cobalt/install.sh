#!/bin/bash
if [ ! -d "src" ]; then
    git clone https://github.com/wukko/cobalt ./Cobalt
    (
        cd Cobalt || exit
        git checkout fa4e418e36
    )
    git clone
    mv Cobalt/* ./
    mv Cobalt/.git ./
    mv Cobalt/.github ./
fi

if [ ! -f "./.env" ]; then
    npm run setup
fi

if [[ -f "./.env" && -d "node_modules" ]]; then
    bash <(curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect%20(en)/Cobalt/version.sh")
    bash <(curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect%20(en)/Cobalt/launch.sh")
else
    echo "Something went very wrong."
fi
