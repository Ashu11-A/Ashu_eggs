#!/bin/bash
GITHUB_PACKAGE=alfg/ffmpegd
LATEST_JSON=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq -c '.[]' | head -1)
ARCH=$([ "$(uname -m)" == "x86_64" ] && echo "amd64" || echo "arm64")
VERSION=latest

if [ "${ARCH}" == "arm64" ]; then
    if [ "$VERSION" == "latest" ]; then
        echo -e "defaulting to latest release"
        DOWNLOAD_LINK=$(echo $LATEST_JSON | jq .assets | jq -r .[].browser_download_url | grep -i Linux | grep -i arm64)
    fi
else
    if [ "$VERSION" == "latest" ]; then
        echo -e "defaulting to latest release"
        DOWNLOAD_LINK=$(echo $LATEST_JSON | jq .assets | jq -r .[].browser_download_url | grep -i Linux | grep -i amd64)
    fi
fi

if [ ! -d "FFmpegd" ]; then
    mkdir FFmpegd
    cat <<EOF >./logs/log_install.txt
Versão: ${VERSION}
Link: ${DOWNLOAD_LINK}
Arquivo: ${DOWNLOAD_LINK##*/}
EOF
    (
        cd FFmpegd || exit
        echo -e "Executando 'curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}'"
        curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}
        echo -e "Descompactando arquivos..."
        tar -xvzf ${DOWNLOAD_LINK##*/}
        rm ${DOWNLOAD_LINK##*/}
    )

fi

if [ ! -d Media ]; then
    mkdir Media
fi

if [ ! -d "FFmpeg-Commander" ]; then
    git clone --quiet https://github.com/Ashu11-A/ffmpeg-commander-Egg FFmpeg-Commander
fi
fakeroot chmod 775 ./*
(
    cd FFmpeg-Commander || exit
    npm install
    npm audit fix
)

if [[ -d "./FFmpeg-Commander/public" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/FFmpeg/version.sh)
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/FFmpeg/launch.sh)
else
    echo "Algo muito errado aconteceu."
fi
