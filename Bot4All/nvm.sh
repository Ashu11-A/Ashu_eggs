#!/bin/bash
# shellcheck source=/dev/null
source "/home/container/.nvm/nvm.sh"

if [ ! -f "logs/nodejs_version" ]; then
    printf "\n \n📝  Qual versão do nodejs você deseja utilizar (12, 14, 16, 18...) (pressione [ENTER]): \n \n"
    read -r VERSION
    if [[ "$VERSION" == "12" ]]; then
        version="12.22.9"
    elif [[ "$VERSION" == "14" ]]; then
        version="14.21.3"
    elif [[ "$VERSION" == "16" ]]; then
        version="16.20.0"
    elif [[ "$VERSION" == "18" ]]; then
        version="18.16.0"
    elif [[ "$VERSION" == "20" ]]; then
        version="20.0.0"
    else
        printf "🥶 Versão não encontrada, usando a versão 18\n"
        version="18.16.0"
    fi
    echo "$version" >logs/nodejs_version
    printf "👍  Blz, salvei a versão (v%s) aqui!\n" "$VERSION"
    printf "🫵  Você pode alterar a versão usando o comando: version.\n"
fi

if [[ -f "logs/nodejs_version" ]]; then

    if [ -n "${versions}" ]; then
        nvm install "${version}"
        nvm use "${version}"
    else
        printf "⚠️  Versão não identificada, usando nvm padrão (v18).\n"
        nvm install "18.16.0"
        nvm use "18.16.0"
    fi
fi
