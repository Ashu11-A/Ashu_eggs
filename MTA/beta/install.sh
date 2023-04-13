#!/bin/bash
AMD64="https://nightly.mtasa.com/multitheftauto_linux_x64-1.5.9-rc-21630.tar.gz"
ARM64="https://nightly.mtasa.com/multitheftauto_linux_arm64-1.5.9-rc-21630.tar.gz"
ARCH=$([ "$(uname -m)" == "x86_64" ] && echo "$AMD64" || echo "$ARM64")
if [ -f "./mta-server64" ] || [ -f "./mta-server-arm64" ]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/MTA/start.sh)
else

    mkdir -p /mnt/server
    cd /mnt/server || exit

    if [[ -f "./mta-server64" ]]; then
        mkdir MTA_OLD
        mv ./* MTA_OLD
    else
        echo "Instalação Limpa"
    fi
    cd /tmp || exit
    curl -Lo multitheftauto_linux.tar.gz "$ARCH"
    curl -Lo mta-baseconfig.tar.gz https://linux.mtasa.com/dl/baseconfig.tar.gz
    curl -Lo mtasa-resources-latest.zip http://mirror.mtasa.com/mtasa/resources/mtasa-resources-latest.zip

    tar -xvf multitheftauto_linux.tar.gz
    cp -rf multitheftauto_linux/* /mnt/server

    if [ ! -f /mnt/server/x64/libmysqlclient.so.16 ]; then
        curl -L http://nightly.mtasa.com/files/libmysqlclient.so.16 -o /mnt/server/x64/libmysqlclient.so.16
    fi

    if [ ! -f /mnt/server/arm64/libmysqlclient.so.16 ]; then
        curl -L http://nightly.mtasa.com/files/libmysqlclient.so.16 -o /mnt/server/arm64/libmysqlclient.so.16
    fi

    mkdir -p /mnt/server/mods/deathmatch/resources
    unzip -o -d /mnt/server/mods/deathmatch/resources mtasa-resources-latest.zip

    mkdir -p /mnt/server-conf
    tar -xvf mta-baseconfig.tar.gz
    cp -rf baseconfig/* /mnt/server/mods/deathmatch

    echo "instalação do script concluído"
fi
