#!/bin/bash
bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
normal=$(echo -en "\e[0m")

export bold
export lightblue
export normal

if [ ! -d "./logs" ]; then
    mkdir ./logs
fi

if [ ! -d "./[seu_bot]" ]; then
    mkdir "./[seu_bot]"
fi

if [ ! -f "logs/nodejs_version" ]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Bot4All/nvm_install.sh)
fi

bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Bot4All/nvm_start.sh)

if [ "${USER_UPLOAD}" == "true" ] || [ "${USER_UPLOAD}" == "1" ]; then
    printf "\n \n⚙️  Modo Upload está ativo (isso irá pular a clonagem do repo do Github)\n \n"
else
    if [ -n "${GIT_ADDRESS}" ]; then
        (
            cd "./[seu_bot]" || exit
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
                echo "Instalando pacotes NodeJS"
                npm install ${NODE_PACKAGES}
            fi
            if [ -f /mnt/server/package.json ]; then
                npm install --production
            fi
        )
    else
        printf "\n \n📌  URL do repositório git não especificado, usando metodo Upload.\n \n"
        (
            cd "./[seu_bot]" || exit
            if [[ ! -z ${NODE_PACKAGES} ]]; then
                echo "Instalando pacotes NodeJS"
                npm install ${NODE_PACKAGES}
            fi
            if [ -f ./package.json ]; then
                npm install --production
            fi
        )
    fi
fi

if [ ! -f "logs/start-conf" ]; then
    printf "\n \n📝  Qual é o arquivo de inicialização que você deseja utilizar? (bot.js, index.js...) (pressione [ENTER]): \n \n"
    read START
    echo "$START" >logs/start-conf
    echo "👌  OK, salvei ($START) aqui!"
    echo "🫵  Você pode alterar isso usando o comando: ${bold}${lightblue}start"
fi

start="$(cat logs/start-conf)"

if [ -d "./[seu_bot]" ]; then
    if [[ -f "./[seu_bot]/${start}" ]]; then
        bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Bot4All/launch.sh)
    else
        printf "\n \n⚙️  Não achei o arquivo de inicialização selecionou.\n"
        printf "❔  Deseja mudar o arquivo? [y/N]\n \n"
        read -r response
        case "$response" in
        [yY][eE][sS] | [yY])
            printf "\n \n📝  Qual é o arquivo de inicialização que você deseja utilizar? (bot.js, index.js...) (pressione [ENTER]): \n \n"
            read -r START
            echo "$START" >logs/start-conf
            echo "👌  OK, salvei ($START) aqui!"
            echo "🫵  Você pode alterar isso usando o comando: ${bold}${lightblue}start"
            ;;
        *) ;;
        esac
    fi
fi
