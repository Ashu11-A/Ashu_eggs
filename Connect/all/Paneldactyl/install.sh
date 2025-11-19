#!/bin/bash

export NVM_DIR=/home/container/.nvm
export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Lang/paneldactyl.conf"

curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/loadLang.sh" -o /tmp/loadLang.sh
curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/fmt.sh" -o /tmp/fmt.sh

source /tmp/loadLang.sh
source /tmp/fmt.sh

# Detecta nome da pasta do painel
if [ -d "/home/container/painel" ]; then
    PANEL_DIR="painel"
else
    PANEL_DIR="panel"
fi

if [ -d "nvm" ]; then
	source "/home/container/.nvm/nvm.sh"
fi

if [ -f /etc/os-release ]; then
    distro=$(grep ^ID= /etc/os-release | cut -d'=' -f2 | tr -d '"')
    if [ "$distro" = "alpine" ]; then
        echo "$alpine_warning"
    elif [ "$distro" = "debian" ]; then
    	if [[ ! -d ".nvm" ]]; then
            echo -e "\n \n$nvm_installing\n \n"
            mkdir -p $NVM_DIR
            curl -sSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh -o nvm.sh
            chmod a+x ./nvm.sh
            ./nvm.sh
            rm ./nvm.sh
            source "/home/container/.nvm/nvm.sh"
        fi
    
        if [[ -d ".nvm" ]]; then
            if [ ! -f "logs/nodejs_version" ]; then
                # Download manual do seletor NVM
                curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/nvmSelect.sh" -o /tmp/nvmSelect.sh
                bash /tmp/nvmSelect.sh
                rm -f /tmp/nvmSelect.sh
            fi
            source "/home/container/.nvm/nvm.sh"
            NODE_VERSION="$(cat logs/nodejs_version)"

            if [ -z "$NODE_VERSION" ]; then
                echo -e "\n \n$version_not_found\n \n"
                NODE_VERSION="18"
            fi

            nvm install v$NODE_VERSION
            nvm use v$NODE_VERSION

            export NODE_PATH=$NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
            export PATH="$PATH":/home/container/.nvm/versions/node/v$NODE_VERSION/bin
            export NVM_DIR=$NVM_DIR
            export NODE_VERSION=$NODE_VERSION

            printf "$yarn_install"
            npm install --global yarn
        fi
    fi
fi

if [ -z "${PANEL}" ]; then
    GITHUB_PACKAGE=Next-Panel/Jexactyl-BR
    FILE=panel.tar.gz
else
    if [ "${PANEL}" = "Pterodactyl" ]; then
        GITHUB_PACKAGE=pterodactyl/panel
        FILE=panel.tar.gz
    elif [ "${PANEL}" = "Jexactyl" ]; then
        GITHUB_PACKAGE=Jexactyl/Jexactyl
        FILE=panel.tar.gz
    elif [ "${PANEL}" = "Jexactyl Brasil" ]; then
        GITHUB_PACKAGE=Next-Panel/Jexactyl-BR
        FILE=panel.tar.gz
    elif [ "${PANEL}" = "Pterodactyl Brasil" ]; then
        GITHUB_PACKAGE=Next-Panel/Pterodactyl-BR
        FILE=panel.tar.gz
    elif [ "${PANEL}" != "Pterodactyl" ] && [ "${PANEL}" != "Jexactyl" ] && [ "${PANEL}" != "Jexactyl Brasil" ] && [ "${PANEL}" != "Pterodactyl Brasil" ]; then
        echo "Defaulting to: Jexactyl Brasil"
        GITHUB_PACKAGE=Next-Panel/Jexactyl-BR
        FILE=panel.tar.gz
    fi
fi

LATEST_JSON=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq -c '.[]' | head -1)
RELEASES=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq '.[]')

if [ -z "$VERSION" ] || [ "$VERSION" == "latest" ]; then
    DOWNLOAD_LINK=$(echo "$LATEST_JSON" | jq .assets | jq -r .[].browser_download_url | grep -i "$FILE")
else
    VERSION_CHECK=$(echo "$RELEASES" | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .tag_name')
    if [ "$VERSION" == "$VERSION_CHECK" ]; then
        if [[ "$VERSION" == v* ]]; then
            DOWNLOAD_LINK=$(echo "$RELEASES" | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .assets[].browser_download_url' | grep -i "$FILE")
        fi
    else
        DOWNLOAD_LINK=$(echo "$LATEST_JSON" | jq .assets | jq -r .[].browser_download_url | grep -i "$FILE")
    fi
fi

if [ -z "${GIT_ADDRESS}" ]; then
    if [ -d "/home/container/$PANEL_DIR" ]; then
        printf "\n \n$check_install\n \n"
        print_status_header "$task_column" "$status_column"
        print_status_row "Panel" "$panel_installed"
    else
        cat <<EOF >./logs/log_install.txt
Version: ${VERSION}
Git: ${GITHUB_PACKAGE}
Git_file: ${FILE}
Link: ${DOWNLOAD_LINK}
File: ${DOWNLOAD_LINK##/}
EOF
        printf "\n \n$check_install\n \n"
        print_status_header "$task_column" "$status_column"
        print_status_row "Panel" "$panel_downloading"

        curl -sSL "${DOWNLOAD_LINK}" -o "${DOWNLOAD_LINK##*/}"
        mkdir -p $PANEL_DIR
        mv "${DOWNLOAD_LINK##*/}" $PANEL_DIR
        (
            cd $PANEL_DIR || exit
            echo -e "$unpacking"
            tar -xvzf "${DOWNLOAD_LINK##*/}"
            rm -rf "${DOWNLOAD_LINK##*/}"

            printf "\n \n$setup_permission\n \n"
            fakeroot chmod -R 755 storage/* bootstrap/cache/
        )
        if [ -f "logs/panel_database_instalado" ]; then
            if [ ! -f "$PANEL_DIR/.env" ]; then
                if [ -f "backups/executado" ] || [ -f "backups/executed" ]; then
                    (
                        cd $PANEL_DIR || exit
                        composer install --no-interaction --no-dev --optimize-autoloader
                    )
                    echo "$irregularity_restoring"
                    (
                        cd backups || exit
                        cp $(ls .env* -t | head -1) ../$PANEL_DIR/.env
                    )
                else
                    printf "\n$alert_delete_files\n"
                    printf "\n \n$ask_delete_logs\n \n"
                    read -r response
                    case "$response" in
                    [yY][eE][sS] | [yY])
                        rm -rf logs/panel*
                        ;;
                    *) ;;
                    esac
                fi
            fi
        fi
    fi
else
    # MODO GIT
    echo -e "\n \n$using_github_repo"
    if [[ ${GIT_ADDRESS} != *.git ]]; then
        GIT_ADDRESS=${GIT_ADDRESS}.git
    fi
    if [ -z "${USERNAME}" ] && [ -z "${ACCESS_TOKEN}" ]; then
        echo -e "🤫  Using anonymous API call."
    else
        GIT_ADDRESS="https://${USERNAME}:${ACCESS_TOKEN}@$(echo -e "${GIT_ADDRESS}" | cut -d/ -f3-)"
    fi
    
    if [ -d "/home/container/$PANEL_DIR" ]; then
        (
            cd $PANEL_DIR || exit
            if [ -d ".git" ]; then
                if [ -f ".git/config" ]; then
                    ORIGIN=$(git config --get remote.origin.url)
                else
                    exit 10
                fi
            fi
            if [ "${ORIGIN}" == "${GIT_ADDRESS}" ]; then
                echo "📁  Pulling latest from GitHub"
                git pull --quiet

                printf "\n \n$setup_permission\n \n"
                fakeroot chmod -R 755 storage/* bootstrap/cache/
            fi
        )
    else
        if [ -z "${BRANCH}" ]; then
            echo -e "📋  Cloning default branch"
            git clone --quiet "${GIT_ADDRESS}" ./$PANEL_DIR
        else
            echo -e "📋  Cloning ${BRANCH}'"
            git clone --quiet --single-branch --branch "${BRANCH}" "${GIT_ADDRESS}" ./$PANEL_DIR
        fi
        printf "\n \n$setup_permission\n \n"
        fakeroot chmod -R 755 /home/container/$PANEL_DIR/storage/* /home/container/$PANEL_DIR/bootstrap/cache/

        touch ./$PANEL_DIR/panel_github_instalado
        
        if [ -f "logs/panel_database_instalado" ] && [ ! -f "$PANEL_DIR/.env" ]; then
             echo "Checking recovery..."
        fi
    fi
    printf "\n \n$check_install\n \n"
    print_status_header "$task_column" "$status_column"
    print_status_row "Panel" "$pulling_files"
fi

if [ -d "temp" ]; then
    rm -rf temp
fi

git clone --quiet https://github.com/Ashu11-A/nginx ./temp

if [ -f "/home/container/nginx/nginx.conf" ]; then
    print_status_row "Nginx" "$panel_installed"
else
    print_status_row "Nginx" "$nginx_downloading"
    
    cp -r ./temp/nginx ./
    rm nginx/conf.d/default.conf
    curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Paneldactyl/default.conf -o ./nginx/conf.d/default.conf
    
    sed -i "s|root /home/container/panel/public|root /home/container/$PANEL_DIR/public|g" nginx/conf.d/default.conf
    
    sed -i \
        -e "s/listen.*/listen ${SERVER_PORT};/g" \
        nginx/conf.d/default.conf
fi

if [ -d "/home/container/php-fpm" ]; then
    print_status_row "PHP-FPM" "$panel_installed"
    print_status_footer
else
    print_status_row "PHP-FPM" "$php_downloading"
    print_status_footer

    cp -r ./temp/php-fpm ./
    echo "extension=\"smbclient.so\"" >php-fpm/conf.d/00_smbclient.ini
    echo 'apc.enable_cli=1' >>php-fpm/conf.d/apcu.ini
    sed -i \
        -e 's/;opcache.enable.*=.*/opcache.enable=1/g' \
        -e 's/;opcache.interned_strings_buffer.*=.*/opcache.interned_strings_buffer=16/g' \
        -e 's/;opcache.max_accelerated_files.*=.*/opcache.max_accelerated_files=10000/g' \
        -e 's/;opcache.memory_consumption.*=.*/opcache.memory_consumption=128/g' \
        -e 's/;opcache.save_comments.*=.*/opcache.save_comments=1/g' \
        -e 's/;opcache.revalidate_freq.*=.*/opcache.revalidate_freq=1/g' \
        -e 's/;always_populate_raw_post_data.*=.*/always_populate_raw_post_data=-1/g' \
        -e 's/memory_limit.*=.*128M/memory_limit=512M/g' \
        -e 's/max_execution_time.*=.*30/max_execution_time=120/g' \
        -e 's/upload_max_filesize.*=.*2M/upload_max_filesize=1024M/g' \
        -e 's/post_max_size.*=.*8M/post_max_size=1024M/g' \
        -e 's/output_buffering.*=.*/output_buffering=0/g' \
        php-fpm/php.ini
    sed -i \
        '/opcache.enable=1/a opcache.enable_cli=1' \
        php-fpm/php.ini
    echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >>php-fpm/php-fpm.conf
fi
cp -r ./temp/logs ./

if [ "${OCC}" == "1" ]; then
    cd $PANEL_DIR || exit
    php "${COMMANDO_OCC}"
    exit
else
    if [ -f "logs/panel_database_instalado" ]; then
        print_status_row "Env" "🟢  Configured"
    else
        if [ ! -f "$PANEL_DIR/.env" ]; then
            if [ -f "backups/executado" ] || [ -f "backups/executed" ]; then
                print_status_row "Env" "$env_restoring"
                (
                    cd backups || exit
                    cp $(ls .env* -t | head -1) ../$PANEL_DIR/.env
                )
            fi
            (
                cd $PANEL_DIR || exit
                printf "\n \n$executing cp .env.example .env\n \n"
                cp .env.example .env
            )
        fi
    fi
    (
        cd $PANEL_DIR || exit
        if [[ -f "../logs/panel_composer_instalado" ]]; then
            print_status_row "Composer" "$panel_installed"
        else
            printf "\n \n$executing composer install --no-interaction --no-dev --optimize-autoloader\n \n"
            composer install --no-interaction --no-dev --optimize-autoloader
            touch ../logs/panel_composer_instalado
        fi
        if [[ -f "../logs/panel_key_generate_instalado" ]]; then
            print_status_row "Key" "🟢  Generated"
        else
            printf "\n \n$executing php artisan key:generate --force\n \n"
            php artisan key:generate --force
            touch ../logs/panel_key_generate_instalado
        fi

        if [[ -f "../logs/panel_setup_instalado" ]]; then
             print_status_row "Setup" "🟢  Configured"
        else
            printf "\n \n$executing php artisan p:environment:setup\n \n"
            php artisan p:environment:setup
            touch ../logs/panel_setup_instalado
            printf "\n \n$ask_run_again\n \n"
            read -r response
            case "$response" in
            [yY][eE][sS] | [yY])
                php artisan p:environment:setup
                ;;
            *) ;;
            esac
        fi
        if [[ -f "../logs/panel_database_instalado" ]]; then
            print_status_row "Database" "🟢  Configured"
        else
            printf "\n \n$executing php artisan p:environment:database\n \n"
            php artisan p:environment:database
            touch ../logs/panel_database_instalado
            printf "\n \n$ask_run_again\n \n"
            read -r response
            case "$response" in
            [yY][eE][sS] | [yY])
                php artisan p:environment:database
                ;;
            *)
                printf "\n \n$executing php artisan migrate --seed --force\n \n"
                ;;
            esac
        fi
        if [[ -f "../logs/panel_database_migrate_instalado" ]]; then
            print_status_row "Migration" "🟢  Concluído/Done"
        else
            php artisan migrate --seed --force
            touch ../logs/panel_database_migrate_instalado
            printf "\n \n$ask_run_again\n \n"
            read -r response
            case "$response" in
            [yY][eE][sS] | [yY])
                php artisan migrate --seed --force
                ;;
            *) ;;
            esac
        fi
        if [[ -f "../logs/panel_user_instalado" ]]; then
            print_status_row "User" "🟢  Created/Criado"
        else
            printf "\n \n$executing php artisan p:user:make\n \n"
            php artisan p:user:make
            touch ../logs/panel_user_instalado
            printf "\n \n$ask_run_again\n \n"
            read -r response
            case "$response" in
            [yY][eE][sS] | [yY])
                php artisan p:user:make
                ;;
            *) ;;
            esac
        fi
    )
    if [[ -f "./logs/panel_instalado" ]]; then
        # Fecha a tabela final
        print_status_footer
        printf "\n \n$setup_completed\n \n"
    else
        printf "\n \n$setup_done\n \n"
        touch ./logs/panel_instalado
    fi
fi

# Limpeza e Backup (Sem alterações de lógica, apenas removendo formatação manual antiga se houver)
if [ -d "tmp" ]; then rm -rf tmp/*; fi
if [ -d "temp" ]; then rm -rf temp; fi
if [ -d ".composer" ]; then rm -rf .composer; fi
if [ -d ".yarn" ]; then rm -rf .yarn; fi
if [ -d ".cache" ]; then rm -rf .cache; fi
if [ -f ".yarnrc" ]; then rm -rf .yarnrc; fi

if [ "${DEVELOPER}" = "1" ]; then
    echo -e "$developer_mode"
    (
        cd "$PANEL_DIR" || exit

        printf "\n \n$setup_permission\n \n"
        fakeroot chmod -R 755 storage/* bootstrap/cache/
        composer install --no-dev --optimize-autoloader
        php artisan migrate --seed --force
        php artisan view:clear 
        php artisan cache:clear 
        php artisan route:clear
    )
fi

if [ -f "./$PANEL_DIR/panel_github_instalado" ]; then
    echo -e "$github_build_warn\n \n"
fi

if [ -z "$BACKUP" ] || [ "$BACKUP" == "1" ]; then
    if [[ -f "./logs/panel_database_instalado" ]]; then
        if [ ! -d "backups" ]; then mkdir -p backups; fi
        if [ ! -f "backups/executado" ] && [ ! -f "backups/executed" ]; then
            touch backups/executado
            sleep 5
        fi
        cp $PANEL_DIR/.env backups/.env-$(date +%F-%Hh%Mm)
        echo "$backup_done"
        echo "$backup_old_deleted"
        find ./backups/ -mindepth 1 -not -name "executado" -not -name "executed" -mtime +7 -delete
    else
        echo "$backup_skipped"
    fi
else
    echo "$backup_disabled"
fi

if [[ -f "./logs/panel_instalado" ]]; then
    # Baixa e Executa Version Check
    curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Paneldactyl/version.sh -o /tmp/version_check.sh
    bash /tmp/version_check.sh
    rm -f /tmp/version_check.sh

    # Baixa e Executa o Launcher
    curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Paneldactyl/launch.sh -o /tmp/launch.sh
    bash /tmp/launch.sh
    rm -f /tmp/launch.sh
else
    echo "$something_wrong"
fi