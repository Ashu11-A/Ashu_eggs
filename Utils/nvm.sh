#!/bin/bash

export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/refs/heads/main/Lang/nvm.conf"
curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/lang.sh" -o /tmp/lang.sh
source /tmp/lang.sh

NVM_DIR="${NVM_DIR:-/home/container/.nvm}"
export NVM_VERSION="0.40.1"

# Instalação do NVM se necessário
if [[ ! -d "$NVM_DIR" ]]; then
    echo -e "\n \n$nvm_installing\n \n"
    mkdir -p "$NVM_DIR"
    curl -sSL "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" -o nvm_installer.sh
    bash ./nvm_installer.sh
    rm -f ./nvm_installer.sh
fi

# Source NVM
if [[ -f "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
else
    # Fallback
    export NVM_DIR="$NVM_DIR"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

if ! command -v nvm &> /dev/null; then
    echo "Error: NVM could not be loaded."
    exit 1
fi

mkdir -p logs

# Função para selecionar versão
select_version() {
    echo -e "\n \n$node_version_prompt\n \n"
    while read -r VERSION; do
        if [[ "$VERSION" =~ ^(12|14|16|18|20|22|24)$ ]]; then
            echo "$VERSION" > logs/nodejs_version
            printf "\n \n$saved_version_message\n \n" "$VERSION"
            printf "\n \n$change_version_message\n \n" "version"
            break
        else
            echo -e "\n \n$version_not_found\n \n"
        fi
    done
}

# Se não houver versão salva, ou se for solicitado explicitamente via argumento
if [[ ! -f "logs/nodejs_version" ]] || [[ "$1" == "--select" ]]; then
    select_version
fi

# Instala e usa a versão
NODE_VERSION=$(cat logs/nodejs_version 2>/dev/null)

if [ -z "$NODE_VERSION" ]; then
    echo -e "\n \n$unidentified_version\n \n"
    NODE_VERSION="18"
fi

nvm install "$NODE_VERSION"
nvm use "$NODE_VERSION"
