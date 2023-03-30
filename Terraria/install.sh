#!/bin/bash
# shellcheck shell=dash

if [ -f "./TerrariaServer.exe" ]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Terraria/launch.sh)
else

    apk add --no-cache --upgrade curl wget file unzip zip

    mkdir -p /mnt/server/
    cd /mnt/server/ || exit
    mkdir logs

    DOWNLOAD_LINK=invalid
    if [ "${TERRARIA_VERSION}" = "latest" ] || [ "${TERRARIA_VERSION}" = "" ]; then
        DOWNLOAD_LINK=$(curl -sSL https://terraria.fandom.com/wiki/Server#Downloads | grep '>Terraria Server ' | grep -Eoi '<a [^>]+>' | grep -Eo 'href=\"[^\\\"]+\"' | grep -Eo '(http|https):\/\/[^\"]+' | tail -1 | cut -d'?' -f1)
    else
        CLEAN_VERSION=$(echo ${TERRARIA_VERSION} | sed 's/\.//g')
        printf "Downloading terraria server files"
        DOWNLOAD_LINK=$(curl -sSL https://terraria.fandom.com/wiki/Server#Downloads | grep '>Terraria Server ' | grep -Eoi '<a [^>]+>' | grep -Eo 'href=\"[^\\\"]+\"' | grep -Eo '(http|https):\/\/[^\"]+' | grep "${CLEAN_VERSION}" | cut -d'?' -f1)
    fi
    ## this is a simple script to validate a download url actaully exists
    if [ ! -z "${DOWNLOAD_LINK}" ]; then
        if curl --output /dev/null --silent --head --fail ${DOWNLOAD_LINK}; then
            printf "link is valid."
        else
            printf "link is invalid closing out"
            exit 2
        fi
    fi
    if [ "${TERRARIA_VERSION}" = "1.4.4" ] || [ "${TERRARIA_VERSION}" = "144" ]; then
        CLEAN_VERSION=$(echo ${DOWNLOAD_LINK##*/} | cut -d'-' -f3 | cut -d'.' -f1)
        cat <<EOF >logs/log.txt
Atenção, essa versão há um erro GRAVE!!!
Versão: ${TERRARIA_VERSION}
Link: https://terraria.org/api/download/pc-dedicated-server/terraria-server-144.zip
Arquivo: terraria-server-144.zip
Versão Limpa: 144
EOF
        printf "wget https://terraria.org/api/download/pc-dedicated-server/terraria-server-144.zip"
        wget https://terraria.org/api/download/pc-dedicated-server/terraria-server-144.zip
        printf "Unpacking server files"
        unzip -o terraria-server-144.zip
        cp -R 144/Linux/* ./
    else
        CLEAN_VERSION=$(echo ${DOWNLOAD_LINK##*/} | cut -d'-' -f3 | cut -d'.' -f1)
        cat <<EOF >logs/log.txt
Versão: ${CLEAN_VERSION}
Link: ${DOWNLOAD_LINK}
Arquivo: ${DOWNLOAD_LINK##*/}
Versão Limpa: ${CLEAN_VERSION}
EOF
        printf "running 'curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}'"
        curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}
        printf "Unpacking server files"
        unzip -o ${DOWNLOAD_LINK##*/}
        cp -R ${CLEAN_VERSION}/Linux/* ./
        mkdir saves
        mkdir saves/Worlds
    fi
    chmod +x TerrariaServer.bin.x86_64
    chmod +x TerrariaServer.exe
    touch banlist.txt
    printf "Cleaning up extra files."
    rm System*
    rm monoconfig
    rm Mono*
    rm mscorlib.dll
    rm serverconfig.txt
    rm ${DOWNLOAD_LINK##*/}
    rm -r ${CLEAN_VERSION}
    printf "Generating config file"
    cat <<EOF >serverconfig.txt
||----------------------------------------------------------------||
Note: To change any value go to Startup, and change there!
Notas: Para alterar qualquer valor va para Startup, e altere la!
||----------------------------------------------------------------||
world=
worldpath=
modpath=
banlist=
port=
||----------------------------------------------------------------||
worldname=
maxplayers=
difficulty=
autocreate=
slowliquids=
npcstream=
seed=
motd=
||----------------------------------------------------------------||
password=
secure=
language=
EOF

    printf "Install complete"

fi
