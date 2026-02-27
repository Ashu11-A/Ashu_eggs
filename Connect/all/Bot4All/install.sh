#!/bin/bash
# shellcheck source=/dev/null
bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
normal=$(echo -en "\e[0m")
lolcat=/usr/games/lolcat

export bold
export lightblue
export normal

echo -e "\n \n$(figlet -c -f slant -t -k $title)\n$by_ashu" | $lolcat

if [ ! -d "./logs" ]; then
    mkdir -p ./logs
fi

if [ -z "$NVM_STATUS" ] || [ "$NVM_STATUS" = "1" ]; then
    if [ -f /etc/os-release ]; then
        # Pega a informação da distribuição
        distro=$(grep ^ID= /etc/os-release | cut -d'=' -f2 | tr -d '"')
        
        # Verifica se é Alpine ou Debian
        if [ "$distro" = "alpine" ]; then
            echo "$nvm_alpine"
        elif [ "$distro" = "debian" ]; then
            curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/nvm.sh" -o /tmp/nvm.sh && bash /tmp/nvm.sh

            # NVM Initialization
            source "/home/container/.nvm/nvm.sh"
            NVM_DIR=/home/container/.nvm
            NODE_VERSION="$(cat logs/nodejs_version)"

            export NODE_PATH=$NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
            export PATH="$PATH":/home/container/.nvm/versions/node/v$NODE_VERSION/bin
            export NVM_DIR=$NVM_DIR
            export NODE_VERSION=$NODE_VERSION
        fi
    fi
fi

if [ -n "$GIT_ADDRESS" ]; then
    echo -e "\n \n$using_github_repo\n \n"
    ## add git ending if it's not on the address
    if [[ $GIT_ADDRESS != *.git ]]; then
        GIT_ADDRESS=${GIT_ADDRESS}.git
    fi
    if [ -z "$USERNAME" ] && [ -z "$ACCESS_TOKEN" ]; then
        echo -e "\n \n$using_anonymous_api\n \n"
    else
        GIT_ADDRESS="https://${USERNAME}:${ACCESS_TOKEN}@$(echo -e $GIT_ADDRESS | cut -d/ -f3-)"
    fi
    ## pull git js bot repo
    if ls -A ./ | grep -v -E '(^\.nvm$|^logs$|^install.sh$|^\.npm$|^code$|^\..*rc$)' >/dev/null; then
        echo -e "$directory_not_empty"
        if [ -d .git ]; then
            echo -e "$git_directory_exists"
            if [ -f .git/config ]; then
                echo -e "$loading_git_info"
                ORIGIN=$(git config --get remote.origin.url)
            else
                echo -e "$file_without_config_git"
                echo -e "$closing_without_touching"
            fi
        fi
        if [ "$ORIGIN" == "$GIT_ADDRESS" ]; then
            echo "$git_address_is_origin"
            git pull
        fi
    else
        echo -e "$container_empty"
        if [ -z $BRANCH ]; then
            echo -e "$cloning_default_branch"
            git clone $GIT_ADDRESS code
            cp -R code/* ./
            rm -rf code
        else
            printf "$cloning_branch\n" "$BRANCH"
            git clone --single-branch --branch $BRANCH $GIT_ADDRESS code
            cp -R code/* ./
            rm -rf code
        fi
    fi
    if [[ ! -z $NODE_PACKAGES ]]; then
        echo "$installing_node_packages"
        npm install $NODE_PACKAGES
    fi

    if [ ! -d "./node_modules" ]; then
        if [ -f "./package.json" ]; then
            echo "$installing_node_packages"
            npm install
        fi
    fi
else
    echo -e "\n \n$repo_not_specified\n \n"
    if [[ ! -z $NODE_PACKAGES ]]; then
        echo "$installing_node_packages"
        npm install $NODE_PACKAGES
    fi
    if [ ! -d "./node_modules" ]; then
        if [ -f "./package.json" ]; then
            npm install
        fi
    fi
fi

if [ ! -f "logs/start-conf" ]; then
    echo -e "\n \n$start_command_prompt\n \n"
    read -r START
    echo "$START" >logs/start-conf
    printf "$saved_start_command\n" "($START)"
    printf "$change_start_command\n" "start"
fi

# Lê o conteúdo do arquivo "logs/start-conf" para a variável "start"
start="$(cat logs/start-conf)"

# Verifica se o conteúdo é um arquivo existente ou um comando npm run ou node
if [ -f "$start" ] || [[ "$start" == "npm run"* ]] || [[ "$start" == "node"* ]]; then
    curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Bot4All/launch.sh" -o /tmp/launch.sh && bash /tmp/launch.sh
else
    echo -e "\n \n$start_file_not_found\n"
    echo -e "$change_start_command_prompt\n \n"
    read -r response
    case "$response" in
    [yY][eE][sS] | [yY])
        echo -e "\n \n$start_command_prompt\n \n"
        read -r START
        echo "$START" >logs/start-conf
        printf "$saved_start_command\n" "($START)"
        printf "$change_start_command\n" "start"
        ;;
    *) ;;
    esac
fi