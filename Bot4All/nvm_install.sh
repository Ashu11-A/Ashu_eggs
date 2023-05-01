#!/bin/bash
# shellcheck source=/dev/null
source "/home/container/.nvm/nvm.sh"

echo -e "\n \n📝  Qual versão do nodejs você deseja utilizar (12, 14, 16, 18, 20) (pressione [ENTER]): \n \n"
while read -r VERSION; do

    if [[ "$VERSION" =~ ^(12|14|16|18|20)$ ]]; then
        if [[ "$VERSION" == "12" ]]; then
            NODE_VERSION="12.22.9"
        elif [[ "$VERSION" == "14" ]]; then
            NODE_VERSION="14.21.3"
        elif [[ "$VERSION" == "16" ]]; then
            NODE_VERSION="16.20.0"
        elif [[ "$VERSION" == "18" ]]; then
            NODE_VERSION="18.16.0"
        elif [[ "$VERSION" == "20" ]]; then
            NODE_VERSION="20.0.0"
        fi
        echo "$VERSION" >logs/nodejs_version
        echo -e "\n \n👍  Blz, salvei a versão (v%s) aqui!\n \n" "$VERSION"
        echo -e "\n \n🫵  Você pode alterar a versão usando o comando: ${bold}${lightblue}version.\n \n"

        if [[ -f "logs/nodejs_version" ]]; then
            echo "${NODE_VERSION}"
            if [ -n "${NODE_VERSION}" ]; then
                nvm install "${NODE_VERSION}"
                nvm use "${NODE_VERSION}"
                exit
            else
                echo -e "\n \n⚠️  Versão não identificada, usando nvm padrão (v18).\n \n"
                nvm install "18.16.0"
                nvm use "18.16.0"
                exit
            fi
        fi
        break
    else
        echo -e "\n \n🥶  Versão não encontrada, somente as versões: 12, 14, 16, 18, 20 estão disponiveis\n \n"
    fi
done