#!/bin/bash
# shellcheck source=/dev/null
bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
normal=$(echo -en "\e[0m")

export bold
export lightblue
export normal

if [ ! -d "./logs" ]; then
    mkdir ./logs
fi

echo "   "
figlet -c -f slant -t -k "Bot4All"
echo "                                         by Ashu (BotForAll)"

if [ ! -d "./[seu_bot]" ]; then
    mkdir "./[seu_bot]"
fi

if [ ! -f "logs/nodejs_version" ]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Bot4All/nvm_install.sh)
fi
######################################## Inicialização do NVM
source "/home/container/.nvm/nvm.sh"
NVM_DIR=/home/container/.nvm
VERSION="$(cat logs/nodejs_version)"

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
else
    echo -e "\n \n🥶 Versão não encontrada, usando a versão 18\n \n"
    NODE_VERSION="18.16.0"
fi

if [[ -f "logs/nodejs_version" ]]; then
    if [ -n "${NODE_VERSION}" ]; then
        nvm install "${NODE_VERSION}"
        nvm use "${NODE_VERSION}"
    else
        echo -e "\n \n⚠️  Versão não identificada, usando nvm padrão (v18).\n \n"
        nvm install "18.16.0"
        nvm use "18.16.0"
    fi
fi

export NODE_PATH=$NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
export PATH="$PATH":/home/container/.nvm/versions/node/v$NODE_VERSION/bin
######################################## FINAL

if [ -n "${GIT_ADDRESS}" ]; then
    (
        cd "./[seu_bot]" || exit
        echo -e "\n \n📌  Usando repo do GitHub\n \n"
        ## add git ending if it's not on the address
        if [[ ${GIT_ADDRESS} != *.git ]]; then
            GIT_ADDRESS=${GIT_ADDRESS}.git
        fi
        if [ -z "${USERNAME}" ] && [ -z "${ACCESS_TOKEN}" ]; then
            echo -e "\n \n🤫  Usando chamada de API anonimo.\n \n"
        else
            GIT_ADDRESS="https://${USERNAME}:${ACCESS_TOKEN}@$(echo -e ${GIT_ADDRESS} | cut -d/ -f3-)"
        fi
        ## pull git js bot repo
        if [ "$(ls -A ./)" ]; then
            echo -e "O diretório '/home/container/[seu_bot]' não está vazio."
            if [ -d .git ]; then
                echo -e ".git Diretório existe"
                if [ -f .git/config ]; then
                    echo -e "loading info from git config"
                    ORIGIN=$(git config --get remote.origin.url)
                else
                    echo -e "files found with no git config"
                    echo -e "closing out without touching things to not break anything"
                fi
            fi
            if [ "${ORIGIN}" == "${GIT_ADDRESS}" ]; then
                echo "pulling latest from github"
                git pull
            fi
        else
            echo -e "'/home/container/[seu_bot]' está vazia.\nClonando de arquivos no repositório"
            if [ -z ${BRANCH} ]; then
                echo -e "cloning default branch"
                git clone ${GIT_ADDRESS} .
            else
                echo -e "cloning ${BRANCH}'"
                git clone --single-branch --branch ${BRANCH} ${GIT_ADDRESS} .
            fi
        fi
        if [[ ! -z ${NODE_PACKAGES} ]]; then
            echo "📦  Instalando pacotes NodeJS"
            npm install ${NODE_PACKAGES}
        fi

        if [ ! -d "./node_modules" ]; then
            if [ -f ./package.json ]; then
                echo "📦  Instalando pacotes NodeJS"
                npm install
            fi
        fi
    )
else
    echo -e "\n \n📌  Repositório git não especificado, usando metodo Upload.\n \n"
    (
        cd "./[seu_bot]" || exit
        if [[ ! -z ${NODE_PACKAGES} ]]; then
            echo "Instalando pacotes NodeJS"
            npm install ${NODE_PACKAGES}
        fi
        if [ ! -d "./node_modules" ]; then
            if [ -f ./package.json ]; then
                npm install
            fi
        fi
    )
fi

if [ ! -f "logs/start-conf" ]; then
    echo -e "\n \n📝  Qual é o arquivo de inicialização que você deseja utilizar? (bot.js, index.js...) (pressione [ENTER]): \n \n"
    read -r START
    echo "$START" >logs/start-conf
    echo -e "\n \n👌  OK, salvei ($START) aqui!\n"
    echo -e "🫵  Você pode alterar isso usando o comando: ${bold}${lightblue}start\n \n"
fi

start="$(cat logs/start-conf)"

if [ -d "./[seu_bot]" ]; then
    if [[ -f "./[seu_bot]/${start}" ]]; then
        bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Bot4All/launch.sh)
    else
        echo -e "\n \n📛  Não achei o arquivo de inicialização selecionado.\n"
        echo -e "❔  Deseja mudar o arquivo? [y/N]\n \n"
        read -r response
        case "$response" in
        [yY][eE][sS] | [yY])
            echo -e "\n \n📝  Qual é o arquivo de inicialização que você deseja utilizar? (bot.js, index.js...) (pressione [ENTER]): \n \n"
            read -r START
            echo "$START" >logs/start-conf
            echo -e "\n \n👌  OK, salvei ($START) aqui!\n"
            echo -e "🫵  Você pode alterar isso usando o comando: ${bold}${lightblue}start\n \n"
            ;;
        *) ;;
        esac
    fi
fi

: <<'LIMBO'
if [ ! -f "./logs/3d.flf" ]; then
    (
        cd logs || exit
        curl -sO https://raw.githubusercontent.com/xero/figlet-fonts/master/3d.flf
    )
fi
LIMBO
