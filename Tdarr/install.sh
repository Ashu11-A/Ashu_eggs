#!/bin/bash
if [[ -f "./Tdarr_Updater" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Tdarr/launch.sh)
else
    mkdir -p /mnt/server
    cd /mnt/server || exit
    ARCH=$([ "$(uname -m)" == "x86_64" ] && echo "x64" || echo "arm64")
    echo "**** install tdarr package ****" && \
    DOWNLOAD_LINK=$(echo https://f000.backblazeb2.com/file/tdarrs/versions/2.00.15/linux_$ARCH/Tdarr_Updater.zip)
    cat <<EOF >.log.txt
Link: ${DOWNLOAD_LINK}
Arquivo: ${DOWNLOAD_LINK##*/}
EOF
    curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}
    unzip ${DOWNLOAD_LINK##*/}
    #rm -rf ${DOWNLOAD_LINK##*/}
    mkdir -p Fonts
    git clone https://github.com/xero/figlet-fonts.git ./Fonts
fi
