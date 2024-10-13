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
    mkdir -p FFmpegd
    cat <<EOF >./logs/log_install.txt
Version: ${VERSION}
Link: ${DOWNLOAD_LINK}
File: ${DOWNLOAD_LINK##/}
EOF
    (
        cd FFmpegd || exit
        echo -e "Executing 'curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}'"
        curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}
        echo -e "Extracting files..."
        tar -xvzf ${DOWNLOAD_LINK##*/}
        rm ${DOWNLOAD_LINK##*/}
    )
fi

mkdir -p Media

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
    bash <(curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/FFmpeg/version.sh")
    bash <(curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/FFmpeg/launch.sh")
else
    echo "Something went terribly wrong."
fi
