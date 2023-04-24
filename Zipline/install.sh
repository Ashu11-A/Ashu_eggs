#!/bin/bash
GITHUB_PACKAGE=diced/zipline
RELEASES=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq '.[]')

if [ -z "$VERSION" ] || [ "$VERSION" == "latest" ]; then
    if [ ! -d "Zipline" ]; then
        git clone --quiet https://github.com/diced/zipline Zipline
    fi
else
    VERSION_CHECK=$(echo "$RELEASES" | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .tag_name')
    if [ "$VERSION" == "$VERSION_CHECK" ]; then
        if [[ "$VERSION" == v* ]]; then
            DOWNLOAD_LINK=$(echo "$RELEASES" | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .assets[].browser_download_url' | grep -i "$VERSION" | grep -i .zip)

            mkdir Zipline
            mkdir Logs
            cat <<EOF >./Logs/log_install.txt
Versão: ${VERSION}
Link: ${DOWNLOAD_LINK}
Arquivo: ${DOWNLOAD_LINK##*/}
EOF
            (
                cd Zipline || exit
                echo -e "Executando 'curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}'"
                curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}
                echo -e "Descompactando arquivos..."
                unzip ${DOWNLOAD_LINK##*/}
                rm ${DOWNLOAD_LINK##*/}
            )
        fi
    else
        if [ ! -d "Zipline" ]; then
            git clone --quiet https://github.com/diced/zipline Zipline
        fi
    fi
fi


#if [ ! -d "Zipline" ]; then
#    git clone --quiet https://github.com/diced/zipline Zipline
#fi

fakeroot chmod 775 ./*
(
    cd Zipline || exit
    yarn install
    yarn build
    mv .env.local.example .env.local
)

if [[ -d "./Zipline/public" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Zipline/version.sh)
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Zipline/launch.sh)
else
    echo "Algo muito errado aconteceu."
fi
