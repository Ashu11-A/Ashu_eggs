#!/bin/bash
# shellcheck source=/dev/null
export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/refs/heads/main/Lang/nvm.conf"
source <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/refs/heads/main/Utils/loadLang.sh)
source "/home/container/.nvm/nvm.sh"

mkdir -p logs
# Exibe a mensagem de escolha da versão do Node.js
echo -e "\n \n$node_version_prompt\n \n"

# Lê a entrada do usuário para a versão do Node.js
while read -r VERSION; do
    if [[ "$VERSION" =~ ^(12|14|16|18|20)$ ]]; then
        NODE_VERSION="$VERSION"

        # Salva a versão no arquivo de logs
        echo "$VERSION" > logs/nodejs_version

        printf "\n \n$saved_version_message\n \n" "$VERSION" # Exibe mensagem de versão salva usando printf com %s
        printf "\n \n$change_version_message\n \n" "version" # Exibe a mensagem sobre como mudar a versão usando printf com %s

        # Verifica se o arquivo de versão existe e usa o NVM
        if [[ -f "logs/nodejs_version" ]]; then
            echo "$NODE_VERSION"
            if [ -n "$NODE_VERSION" ]; then
                nvm install "$NODE_VERSION"
                nvm use "$NODE_VERSION"
                exit
            else
                # Exibe a mensagem de versão não identificada
                echo -e "\n \n$unidentified_version\n \n"
                nvm install 18
                nvm use 18
                exit
            fi
        fi
        break
    else
        # Exibe a mensagem de versão não encontrada
        echo -e "\n \n$version_not_found\n \n"
    fi
done