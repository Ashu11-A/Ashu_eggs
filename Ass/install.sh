#!/bin/bash
GITHUB_PACKAGE=tycrek/ass
RELEASES=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq '.[]')

if [ -z "$VERSION" ] || [ "$VERSION" == "latest" ]; then
    if [ ! -d "Ass" ]; then
        git clone --quiet https://github.com/$GITHUB_PACKAGE Ass
    fi
else
    VERSION_CHECK=$(echo "$RELEASES" | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .tag_name')
    if [ "$VERSION" == "$VERSION_CHECK" ]; then
        if [[ "$VERSION" == v* ]]; then
            DOWNLOAD_LINK=$(echo "$RELEASES" | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .assets[].browser_download_url' | grep -i "$VERSION" | grep -i .zip)

            mkdir Ass
            mkdir Logs
            cat <<EOF >./Logs/log_install.txt
Versão: ${VERSION}
Link: ${DOWNLOAD_LINK}
Arquivo: ${DOWNLOAD_LINK##*/}
EOF
            (
                cd Ass || exit
                echo -e "Executando 'curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}'"
                curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}
                echo -e "Descompactando arquivos..."
                unzip ${DOWNLOAD_LINK##*/}
                rm ${DOWNLOAD_LINK##*/}
            )
        fi
    else
        if [ ! -d "Ass" ]; then
            git clone --quiet https://github.com/$GITHUB_PACKAGE Ass
        fi
    fi
fi


fakeroot chmod 775 ./*

if [ ! -f "./Logs/instalado" ]; then
    (
        cd Ass || exit
        npm i --save-dev
        
        touch ../Logs/instalado
    )
fi


if [[ -d "./Ass/public" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Ass/version.sh)
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Ass/launch.sh)
else
    echo "Algo muito errado aconteceu."
fi
