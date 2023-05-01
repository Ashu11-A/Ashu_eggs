#!/bin/bash
# shellcheck source=/dev/null
source "/home/container/.nvm/nvm.sh"

VERSION="$(cat logs/nodejs_version)"

if [[ "$VERSION" == "12" ]]; then
    export vers="12.22.9"
elif [[ "$VERSION" == "14" ]]; then
    export vers="14.21.3"
elif [[ "$VERSION" == "16" ]]; then
    export vers="16.20.0"
elif [[ "$VERSION" == "18" ]]; then
    export vers="18.16.0"
elif [[ "$VERSION" == "20" ]]; then
    export vers="20.0.0"
else
    printf "\n \n🥶 Versão não encontrada, usando a versão 18\n \n"
    export vers="18.16.0"
fi

export NODE_PATH=$NVM_DIR/v$vers/versions/node/v$vers/lib/node_modules
export PATH=$PATH:$NVM_DIR/v$vers/bin:$PATH:$NVM_DIR/versions/node/v$vers/bin

$PATH

if [[ -f "logs/nodejs_version" ]]; then
    if [ -n "${vers}" ]; then
        nvm install "${vers}"
        nvm use "${vers}"
    else
        printf "\n \n⚠️  Versão não identificada, usando nvm padrão (v18).\n \n"
        nvm install "18.16.0"
        nvm use "18.16.0"
    fi
fi
