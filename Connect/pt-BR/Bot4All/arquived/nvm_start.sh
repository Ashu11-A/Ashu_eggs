#!/bin/bash
# shellcheck source=/dev/null
source "/home/container/.nvm/nvm.sh"

NVM_DIR=/home/container/.nvm
VERSION="$(cat logs/nodejs_version)"

if [[ "$VERSION" == "12" ]]; then
    export NODE_VERSION="12.22.9"
elif [[ "$VERSION" == "14" ]]; then
    export NODE_VERSION="14.21.3"
elif [[ "$VERSION" == "16" ]]; then
    export NODE_VERSION="16.20.0"
elif [[ "$VERSION" == "18" ]]; then
    export NODE_VERSION="18.16.0"
elif [[ "$VERSION" == "20" ]]; then
    export NODE_VERSION="20.0.0"
else
    printf "\n \n🥶 Versão não encontrada, usando a versão 18\n \n"
    export NODE_VERSION="18.16.0"
fi

export NODE_PATH=$NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
export PATH="$PATH":/home/container/.nvm/versions/node/v$NODE_VERSION/bin

if [[ -f "logs/nodejs_version" ]]; then
    if [ -n "${NODE_VERSION}" ]; then
        nvm install "${NODE_VERSION}"
        nvm use "${NODE_VERSION}"
        node -v
    else
        printf "\n \n⚠️  Versão não identificada, usando nvm padrão (v18).\n \n"
        nvm install "18.16.0"
        nvm use "18.16.0"
        node -v
    fi
fi