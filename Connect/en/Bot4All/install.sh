#!/bin/bash
# shellcheck source=/dev/null
bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
normal=$(echo -en "\e[0m")
lolcat=/usr/games/lolcat

export bold
export lightblue
export normal

echo -e "\n \n$(figlet -c -f slant -t -k "Bot4All")\n                                         by Ashu (BotForAll)" | $lolcat

if [ ! -d "./logs" ]; then
    mkdir ./logs
fi

if [ -z "${NVM_STATUS}" ] || [ "${NVM_STATUS}" = "1" ]; then
    if [[ -d ".nvm" ]]; then
        if [ ! -f "logs/nodejs_version" ]; then
            bash <(curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/Bot4All/nvm_install.sh")
        fi
        ######################################## NVM Initialization
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
            echo -e "\n \n🥶 Version not found, using version 18\n \n"
            NODE_VERSION="18.16.0"
        fi

        if [[ -f "logs/nodejs_version" ]]; then
            if [ -n "${NODE_VERSION}" ]; then
                nvm install "${NODE_VERSION}"
                nvm use "${NODE_VERSION}"
            else
                echo -e "\n \n⚠️  Unidentified version, using default nvm (v18).\n \n"
                nvm install "18.16.0"
                nvm use "18.16.0"
            fi
        fi

        export NODE_PATH=$NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
        export PATH="$PATH":/home/container/.nvm/versions/node/v$NODE_VERSION/bin
    ######################################## FINAL
    else
        echo -e "\n \n⚠️  NVM not installed, server needs to be reinstalled...\n \n"
    fi
fi

if [ -n "${GIT_ADDRESS}" ]; then
    echo -e "\n \n📌  Using GitHub repo\n \n"
    ## add git ending if it's not on the address
    if [[ ${GIT_ADDRESS} != *.git ]]; then
        GIT_ADDRESS=${GIT_ADDRESS}.git
    fi
    if [ -z "${USERNAME}" ] && [ -z "${ACCESS_TOKEN}" ]; then
        echo -e "\n \n🤫  Using anonymous API call.\n \n"
    else
        GIT_ADDRESS="https://${USERNAME}:${ACCESS_TOKEN}@$(echo -e ${GIT_ADDRESS} | cut -d/ -f3-)"
    fi
    ## pull git js bot repo
        echo -e "The '/home/container/' directory is not empty."
    if ls -A ./ | grep -v -E '(^\.nvm$|^logs$|^install.sh$|^\.npm$|^code$|^\..*rc$)' >/dev/null; then
        if [ -d .git ]; then
            echo -e ".git directory exists"
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
        echo -e "'/home/container/' is empty.\nCloning files from repository"
        if [ -z ${BRANCH} ]; then
            echo -e "cloning default branch"
            git clone ${GIT_ADDRESS} code
            cp -R code/* ./
            rm -rf code
        else
            echo -e "cloning ${BRANCH}'"
            git clone --single-branch --branch ${BRANCH} ${GIT_ADDRESS} code
            cp -R code/* ./
            rm -rf code
        fi
    fi
    if [[ ! -z ${NODE_PACKAGES} ]]; then
        echo "📦  Installing NodeJS packages"
        npm install ${NODE_PACKAGES}
    fi
    if [ ! -d "./node_modules" ]; then
        if [ -f ./package.json ]; then
            echo "📦  Installing NodeJS packages"
            npm install
        fi
    fi
else
    echo -e "\n \n📌  Git repository not specified, using Upload method.\n \n"
    if [[ ! -z ${NODE_PACKAGES} ]]; then
        echo "Installing NodeJS packages"
        npm install ${NODE_PACKAGES}
    fi
    if [ ! -d "./node_modules" ]; then
        if [ -f ./package.json ]; then
            npm install
        fi
    fi
fi

if [ ! -f "logs/start-conf" ]; then
    echo -e "\n \n📝  What is the startup command/file you want to use? (EX: bot.js, npm run start...) (press [ENTER]): \n \n"
    read -r START
    echo "$START" >logs/start-conf
    echo -e "\n \n👌  OK, I've saved ($START) here!\n"
    echo -e "🫵  You can change this using the command: ${bold}${lightblue}start\n \n"
fi

# Lê o conteúdo do arquivo "logs/start-conf" para a variável "start"
start="$(cat logs/start-conf)"

# Verifica se o conteúdo é um arquivo existente ou um comando npm run ou node
if [ -f "$start" ] || [[ "$start" == "npm run"* ]] || [[ "$start" == "node"* ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/Bot4All/launch.sh)
else
    echo -e "\n \n📛  Selected initialization file not found.\n"
    echo -e "❔ Do you want to change the file? [y/N]\n \n"
    read -r response
    case "$response" in
    [yY][eE][sS] | [yY])
        echo -e "\n \n📝  What is the initialization file you want to use? (e.g., bot.js, index.js...) (press [ENTER]): \n \n"
        read -r START
        echo "$START" >logs/start-conf
        echo -e "🫵  You can change this using the command: ${bold}${lightblue}start\n \n"
        ;;
    *) ;;
    esac
fi

: <<'LIMBO'
if [ ! -f "./logs/3d.flf" ]; then
    (
        cd logs || exit
        curl -sO https://raw.githubusercontent.com/xero/figlet-fonts/master/3d.flf
    )
fi
LIMBO
