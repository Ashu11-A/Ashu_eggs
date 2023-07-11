#!/bin/bash
AMD64="https://linux.mtasa.com/dl/multitheftauto_linux_x64.tar.gz"
ARM64="https://nightly.mtasa.com/multitheftauto_linux_arm64-1.5.9.tar.gz"
ARCH=$([ "$(uname -m)" == "x86_64" ] && echo "$AMD64" || echo "$ARM64")
if [ -f "./mta-server64" ] || [ -f "./mta-server-arm64" ]; then
    chmod -R 755 ./*
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/MTA/start.sh)
else

    curl -Lo multitheftauto_linux.tar.gz "$ARCH"
    curl -Lo mta-baseconfig.tar.gz https://linux.mtasa.com/dl/baseconfig.tar.gz
    curl -Lo mtasa-resources-latest.zip http://mirror.mtasa.com/mtasa/resources/mtasa-resources-latest.zip

    tar -xvf multitheftauto_linux.tar.gz
    cp -rf multitheftauto_linux*/* ./

    if [ -d x64 ]; then
        if [ ! -f x64/libmysqlclient.so.16 ]; then
            curl -L http://nightly.mtasa.com/files/libmysqlclient.so.16 -o x64/libmysqlclient.so.16
            chmod +x x64/libmysqlclient.so.16
        fi
        mkdir x64/modules
        curl -L https://nightly.mtasa.com/files/modules/64/mta_mysql.so -o x64/modules/mta_mysql.so
        curl -L https://nightly.mtasa.com/files/modules/64/ml_sockets.so -o x64/modules/ml_sockets.so
    fi

    if [ -d arm64 ]; then
        if [ ! -f arm64/libmysqlclient.so.16 ]; then
            curl -L http://nightly.mtasa.com/files/libmysqlclient.so.16 -o arm64/libmysqlclient.so.16
            chmod +x arm64/libmysqlclient.so.16
        fi
        mkdir arm64/modules
        curl -L https://nightly.mtasa.com/files/modules/64/mta_mysql.so -o arm64/modules/mta_mysql.so
        curl -L https://nightly.mtasa.com/files/modules/64/ml_sockets.so -o arm64/modules/ml_sockets.so
    fi

    mkdir -p mods/deathmatch/resources
    unzip -o -d mods/deathmatch/resources mtasa-resources-latest.zip

    mkdir -p /mnt/server-conf
    tar -xvf mta-baseconfig.tar.gz
    cp -rf baseconfig/* mods/deathmatch

    echo "Limpando..."

    rm -rf multitheftauto_linux.tar.gz mta-baseconfig.tar.gz mtasa-resources-latest.zip
    rm -rf multitheftauto_linux*/

    echo "script installation completed"
fi
