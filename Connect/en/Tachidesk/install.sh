#!/bin/bash
if [[ ! -f "./Tachidesk-Server.jar" ]]; then

    GITHUB_PACKAGE=Suwayomi/Tachidesk-Server
    LATEST_JSON=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases")
    if echo "$LATEST_JSON" | jq empty >/dev/null; then
        echo "Error: Invalid response from GitHub API. $LATEST_JSON"
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
        echo "Could not find the download link."
        exit 1
    fi

    mkdir -p logs

    if [ ! -f "./logs/log_install.txt" ]; then
        cat <<EOF >./logs/log_install.txt
Version: ${VERSION}
Link: ${DOWNLOAD_LINK}
File: ${DOWNLOAD_LINK##*/}
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
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/Tachidesk/start.sh)
else
    echo "Tachidesk-Server.jar not found. Reinstall the server."
fi
