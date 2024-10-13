#!/bin/bash
if [[ ! -f "./Tachidesk-Server.jar" ]]; then

    GITHUB_PACKAGE=Suwayomi/Tachidesk-Server
    LATEST_JSON=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases")
    if echo "$LATEST_JSON" | jq empty >/dev/null; then
        echo "Erro: resposta inválida da API do GitHub. $LATEST_JSON"
        exit 1
    fi

    LATEST_JSON=$(echo "$LATEST_JSON" | jq -c '.[]' | head -1)
    RELEASES=$(echo "$LATEST_JSON" | jq '.assets')
    if [ -z "$VERSION" ] || [ "$VERSION" == "latest" ]; then
        echo -e "defaulting to latest release"
        DOWNLOAD_LINK=$(echo "$RELEASES" | jq -r '.[] | select(.name | test("Tachidesk.*jar$"; "i")).browser_download_url')
    else
        VERSION_CHECK=$(echo "$LATEST_JSON" | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .tag_name')
        if [ "$VERSION" == "$VERSION_CHECK" ]; then
            DOWNLOAD_LINK=$(echo "$RELEASES" | jq -r --arg VERSION "$VERSION" '.[] | select(.name | test("Tachidesk.*jar$"; "i")).browser_download_url')
        else
            echo -e "defaulting to latest release"
            DOWNLOAD_LINK=$(echo "$RELEASES" | jq -r '.[] | select(.name | test("Tachidesk.*jar$"; "i")).browser_download_url')
        fi
    fi

    if [ -z "$DOWNLOAD_LINK" ]; then
        echo "Não foi possível encontrar o link de download."
        exit 1
    fi

    mkdir -p Logs

    if [ ! -f "./Logs/log_install.txt" ]; then
        cat <<EOF >./Logs/log_install.txt
Versão: ${VERSION}
Link: ${DOWNLOAD_LINK}
Arquivo: ${DOWNLOAD_LINK##*/}
EOF
    fi

    echo -e "running 'curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}'"
    curl -sSL "$DOWNLOAD_LINK" -o "${DOWNLOAD_LINK##*/}"
fi

if [ ! -d "./Config" ]; then
    mkdir -p Config
fi

if [ ! -f "./Config/server.conf" ]; then
    (
        cd Config || exit
        curl -sSL https://raw.githubusercontent.com/Suwayomi/Tachidesk-Server/master/server/src/main/resources/server-reference.conf -o server.conf

    )
fi

if [[ -f "./Tachidesk-Server.jar" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/Tachidesk/start.sh)
else
    echo "Tachidesk-Server.jar não encontrado. Reinstale o servidor."
fi
