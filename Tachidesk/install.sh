#!/bin/bash
if [[ -f "./Tachidesk-Server.jar" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Tachidesk/start.sh)
else
    mkdir -p /mnt/server
    cd /mnt/server || exit

    GITHUB_PACKAGE=Suwayomi/Tachidesk-Server
    LATEST_JSON=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq -c '.[]' | head -1)
    RELEASES=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq '.[]')

    if [ -z "$VERSION" ] || [ "$VERSION" == "latest" ]; then
        echo -e "defaulting to latest release"
        DOWNLOAD_LINK=$(echo $LATEST_JSON | jq .assets | jq -r .[].browser_download_url | grep -i Tachidesk | grep -i jar)
    else
        VERSION_CHECK=$(echo $RELEASES | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .tag_name')
        if [ "$VERSION" == "$VERSION_CHECK" ]; then
            DOWNLOAD_LINK=$(echo $RELEASES | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .assets[].browser_download_url' | grep -i Tachidesk | grep -i jar)
        else
            echo -e "defaulting to latest release"
            DOWNLOAD_LINK=$(echo $LATEST_JSON | jq .assets | jq -r .[].browser_download_url | grep -i Tachidesk | grep -i jar)
        fi
    fi

    mkdir Logs

    cat <<EOF >./Logs/log_install.txt
Versão: ${VERSION}
Link: ${DOWNLOAD_LINK}
Arquivo: ${DOWNLOAD_LINK##*/}
EOF

    echo -e "running 'curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}'"
    curl -sSL ${DOWNLOAD_LINK} -o Tachidesk-Server.jar
    mkdir Config
    (
        cd Config
        curl -sSL https://raw.githubusercontent.com/Suwayomi/Tachidesk-Server/master/server/src/main/resources/server-reference.conf -o server.conf

    )

    echo -e "Instalação Completa"
    exit 0
fi
