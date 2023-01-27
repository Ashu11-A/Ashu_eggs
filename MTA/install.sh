#!/bin/bash
if [[ -f "./mta-server64" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/MTA/start.sh)
else

    mkdir -p /mnt/server
    cd /mnt/server

    if [[ -f "./mta-server64" ]]; then
        mkdir MTA_OLD
        mv ./* MTA_OLD
    else
        echo "Instalação Limpa"
    fi
    cd /tmp
    curl -Lo multitheftauto_linux_x64.tar.gz https://linux.mtasa.com/dl/multitheftauto_linux_x64.tar.gz
    curl -Lo mta-baseconfig.tar.gz https://linux.mtasa.com/dl/baseconfig.tar.gz
    curl -Lo mtasa-resources-latest.zip http://mirror.mtasa.com/mtasa/resources/mtasa-resources-latest.zip

    mkdir -p /mnt/server
    tar -xvf multitheftauto_linux_x64.tar.gz
    cp -rf multitheftauto_linux_x64/* /mnt/server

    if [ ! -f /mnt/server/x64/libmysqlclient.so.16 ]; then
        curl -L http://nightly.mtasa.com/files/libmysqlclient.so.16 -o /mnt/server/x64/libmysqlclient.so.16
    fi

    mkdir -p /mnt/server/mods/deathmatch/resources
    unzip -o -d /mnt/server/mods/deathmatch/resources mtasa-resources-latest.zip

    mkdir -p /mnt/server-conf
    tar -xvf mta-baseconfig.tar.gz
    cp -rf baseconfig/* /mnt/server/mods/deathmatch

    echo "instalação do script concluído"
fi
