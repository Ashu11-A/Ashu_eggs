#!/bin/bash

if [ ! -d "./logs" ]; then
    mkdir ./logs
fi

if [ "${USER_UPLOAD}" == "true" ] || [ "${USER_UPLOAD}" == "1" ]; then
    printf "\n \n⚙️  Modo Upload está ativo (isso irá pular a clonagem do repo do Github)\n \n"
else
    if [ -n "${GIT_ADDRESS}" ]; then
        if [ ! -d "./Bot - Repo" ]; then
            mkdir "./Bot - Repo"
        fi
        (
            cd "./Bot - Repo" || exit
            printf "\n \n📌  Usando repo do GitHub\n \n"
            ## add git ending if it's not on the address
            if [[ ${GIT_ADDRESS} != *.git ]]; then
                GIT_ADDRESS=${GIT_ADDRESS}.git
            fi
            if [ -z "${USERNAME}" ] && [ -z "${ACCESS_TOKEN}" ]; then
                printf "\n \n🤫  Usando chamada de API anonimo.\n \n"
            else
                GIT_ADDRESS="https://${USERNAME}:${ACCESS_TOKEN}@$(echo -e ${GIT_ADDRESS} | cut -d/ -f3-)"
            fi
            ## pull git js bot repo
            if [ "$(ls -A ./)" ]; then
                echo -e "O diretório '/home/container/Bot - Repo' não está vazio."
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
                echo -e "'/home/container/Bot - Repo' está vazia.\nClonando de arquivos no repositório"
                if [ -z ${BRANCH} ]; then
                    echo -e "cloning default branch"
                    git clone ${GIT_ADDRESS} .
                else
                    echo -e "cloning ${BRANCH}'"
                    git clone --single-branch --branch ${BRANCH} ${GIT_ADDRESS} .
                fi
            fi
            if [[ ! -z ${NODE_PACKAGES} ]]; then
                echo "Instalando pacotes NodeJS"
                /usr/local/bin/npm install ${NODE_PACKAGES}
            fi
            if [ -f /mnt/server/package.json ]; then
                /usr/local/bin/npm install --production
            fi
        )
    else
        printf "\n \n📌  URL do repositório git não encontrado, usando metodo Upload.\n \n"

        if [[ ! -z ${NODE_PACKAGES} ]]; then
            echo "Instalando pacotes NodeJS"
            /usr/local/bin/npm install ${NODE_PACKAGES}
        fi
        if [ -f /mnt/server/package.json ]; then
            /usr/local/bin/npm install --production
        fi
    fi
fi

if [ ! -f "logs/start-conf" ]; then
    printf "\n \n📝  Qual é o arquivo de inicialização que você deseja utilizar? (bot.js, index.js...) (pressione [ENTER]): \n \n"
    read START
    echo "$START" >logs/start-conf
    echo "👌  OK, salvei ($START) aqui!"
    echo "🫵  Você pode alterar isso usando o comando: ${bold}${lightblue}start"
fi

if [ -n "${GIT_ADDRESS}" ]; then
    if [ -d "./Bot - Repo" ]; then
        if [[ -f "./Bot - Repo/${BOT_JS_FILE}" ]]; then
            bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Bot4All/launch.sh)
        fi
    else
        printf "\n \n📌  Especifique o arquivo para o bot inicar, eu não o encontrei!\n \n"
    fi
else
    if [[ -f "./${BOT_JS_FILE}" ]]; then
        bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Bot4All/launch.sh)
    else
        printf "\n \n📌  Especifique o arquivo para o bot inicar, eu não o encontrei!\n \n"
    fi
fi
