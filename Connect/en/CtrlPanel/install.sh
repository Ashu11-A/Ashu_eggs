#!/bin/bash
GITHUB_PACKAGE=Ctrlpanel-gg/panel
LATEST_JSON=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/tags" | jq -c '.[]' | head -1)
RELEASES=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/tags" | jq '.[]')
if [ "$VERSION" != "latest" ]; then
    VERSION_CHECK=$(echo "$RELEASES" | jq -r --arg VERSION "$VERSION" '. | select(.name==$VERSION) | .name')
    if [ "$VERSION" == "$VERSION_CHECK" ]; then
        if [[ "$VERSION" == v* ]]; then
            DOWNLOAD_LINK=$(echo "$RELEASES" | jq -r --arg VERSION "$VERSION" '. | select(.name==$VERSION) | .tarball_url')
        fi
    else
        DOWNLOAD_LINK=$(echo "$LATEST_JSON" | jq -r .[].tarball_url)
    fi
fi
if [ -z "${GIT_ADDRESS}" ]; then
    if [ -d "/home/container/controlpanel" ]; then
        printf "\n \n📄  Checking Installation...\n \n"
        printf "+----------+---------------------------------+\n| Task     | Status                          |\n+----------+---------------------------------+"
        printf "\n| Panel    | 🟢  Installed                    |"
    else
        cat <<EOF >./logs/log_install.txt
Version: ${VERSION}
Git: ${GITHUB_PACKAGE}
Link: ${DOWNLOAD_LINK}
File: ${DOWNLOAD_LINK##*/}
EOF
        printf "\n \n📄  Checking Installation...\n \n"
        printf "+----------+---------------------------------+\n| Task     | Status                          |\n+----------+---------------------------------+"
        printf "\n| Panel    | 🟡  Downloading Panel             |\n"
        if [ -z "$VERSION" ] || [ "$VERSION" == "latest" ]; then
            if [ -d controlpanel ]; then
                mkdir controlpanel
            fi
            git clone https://github.com/Ctrlpanel-gg/panel ./controlpanel
        else
            curl -sSL "${DOWNLOAD_LINK}" -o "${DOWNLOAD_LINK##*/}"
            mkdir controlpanel
            mv "${DOWNLOAD_LINK##*/}" controlpanel
            (
                cd controlpanel || exit
                echo -e "Unpacking server files"
                tar -xvzf "${DOWNLOAD_LINK##*/}"
                rm -rf "${DOWNLOAD_LINK##*/}"
            )
        fi
        (
            cd controlpanel || exit
            fakeroot chmod -R 755 storage/* bootstrap/cache/
            fakeroot chown -R nginx:nginx /home/container/controlpanel/*
        )
        if [ ! -f "controlpanel/.env" ]; then
            if [ -f "backups/executed" ]; then
                (
                    cd controlpanel || exit
                    composer install --no-dev --optimize-autoloader
                )
                echo "🔴  An irregularity was found, restoring .env..."
                (
                    cd backups || exit
                    cp $(ls .env* -t | head -1) ../controlpanel/.env
                )
            else
                printf "\n📢  Attention: MY GOD WHAT DID YOU DO😱 😱  ??\n🥶  What you did: Possibly you accidentally or intentionally deleted the controlpanel folder, but from my information the panel had already been installed  \n🫠  man you will have to create a new database if you lost your .env😨\n🔴  TO PROCEED DELETE THE FILES WITH NAME PANEL IN THE LOGS FOLDER SO THAT THE EGG CAN INSTALL CORRECTLY  🔴\n"
                printf "\n \n📌  Delete the panel files from the logs folder? [y/N]\n \n"
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
else
    echo -e "\n \n📌  Using GitHub repo"
    if [[ ${GIT_ADDRESS} != *.git ]]; then
        GIT_ADDRESS=${GIT_ADDRESS}.git
    fi
    if [ -z "${USERNAME}" ] && [ -z "${ACCESS_TOKEN}" ]; then
        echo -e "🤫  Using anonymous API call."
    else
        GIT_ADDRESS="https://${USERNAME}:${ACCESS_TOKEN}@$(echo -e "${GIT_ADDRESS}" | cut -d/ -f3-)"
    fi
    ## pull git js bot repo
if [ -d "/home/container/controlpanel" ]; then
    (
        cd controlpanel || exit
        if [ -d ".git" ]; then
            if [ -f ".git/config" ]; then
                ORIGIN=$(git config --get remote.origin.url)
            else
                echo -e "files found without git configuration"
                echo -e "terminate without touching things so as not to break anything"
                exit 10
            fi
        fi
        if [ "${ORIGIN}" == "${GIT_ADDRESS}" ]; then
            echo "📁  Pulling the latest from GitHub"
            git pull --quiet
            fakeroot chmod -R 755 storage/* bootstrap/cache/
            fakeroot chown -R nginx:nginx /home/container/controlpanel/*
        fi
    )
else
    if [ -z "${BRANCH}" ]; then
        echo -e "📋  Cloning default branch"
        git clone --quiet "${GIT_ADDRESS}" ./controlpanel
    else
        echo -e "📋  Cloning ${BRANCH}'"
        git clone --quiet --single-branch --branch "${BRANCH}" "${GIT_ADDRESS}" ./controlpanel
    fi
    fakeroot chmod -R 755 /home/container/controlpanel/storage/* /home/container/controlpanel/bootstrap/cache/
    fakeroot chown -R nginx:nginx /home/container/controlpanel/*
    touch ./controlpanel/ctrlpanel_github_installed
    if [ ! -f "controlpanel/.env" ]; then
        if [ -f "backups/executed" ]; then
            (
                cd controlpanel || exit
                composer install --no-interaction --no-dev --optimize-autoloader
            )
            echo "🔴  An irregularity was found, restoring .env..."
            (
                cd backups || exit
                cp $(ls .env* -t | head -1) ../controlpanel/.env
            )
        else
            printf "\n📢  Attention: MY GOD WHAT DID YOU DO😱 😱  ??\n🥶  What you did: Possibly you accidentally or intentionally deleted the controlpanel folder, but from my information the panel had already been installed  \n🫠  man you will have to create a new database if you lost your .env😨\n🔴  TO PROCEED DELETE THE FILES WITH NAME PANEL IN THE LOGS FOLDER SO THAT THE EGG CAN INSTALL CORRECTLY  🔴\n"
            printf "\n \n📌  Delete the panel files from the logs folder? [y/N]\n \n"
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
printf "\n \n📄  Checking Installation...\n \n"
printf "+----------+---------------------------------+\n| Task     | Status                          |\n+----------+---------------------------------+"
printf "\n| Panel    | 🟡  Pulling files                |"
fi
if [ -d "temp" ]; then ## Avoid conflicts in the panel by the following git command
    rm -rf temp
fi
git clone --quiet https://github.com/Ashu11-A/nginx ./temp ## Yes, it will always clone the repo regardless of everything
if [ -f "/home/container/nginx/nginx.conf" ]; then
    printf "\n| Nginx    | 🟢  Installed                    |"
else
    printf "\n| Nginx    | 🟡  Downloading Nginx...            |"
    cp -r ./temp/nginx ./
    rm nginx/conf.d/default.conf
    curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/CtrlPanel/default.conf -o ./nginx/conf.d/default.conf
    sed -i \
        -e "s/listen.*/listen ${SERVER_PORT};/g" \
        nginx/conf.d/default.conf
fi
if [ -d "/home/container/php-fpm" ]; then
    printf "\n| PHP-FPM  | 🟢  Installed                    |\n+----------+---------------------------------+\n"
else
    printf "\n| PHP-FPM  | 🟡  Downloading PHP-FPM...          |\n+----------+---------------------------------+\n"
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

if [ ! -f "controlpanel/.env" ]; then
    if [ -f "backups/executed" ]; then
        echo "| Env      | 🔴  Restoring .env...          |"
        (
            cd backups || exit
            cp $(ls .env* -t | head -1) ../controlpanel/.env
        )
    fi
    (
        cd controlpanel || exit
        printf "\n \n⚙️  Running: cp .env.example .env\n \n"
        cp .env.example .env
    )
fi

if [[ -f "logs/ctrlpanel_composer_installed" ]]; then
    echo "| Composer | 🟢  Installed                    |"
else
    (
        cd controlpanel || exit
        printf "\n \n⚙️  Running: composer install --no-dev --optimize-autoloader\n \n"
        composer install --no-dev --optimize-autoloader
        touch ../logs/ctrlpanel_composer_installed
    )
fi

if [[ -f "./logs/ctrlpanel_installed" ]]; then
    echo "+----------+---------------------------------+"
    printf "\n \n📑  Panel Verification Completed...\n \n"
else
    printf "\n \n⚙️  Running: Assigning permissions\n \n"
    fakeroot chown -R nginx:nginx /home/container/controlpanel/*
    printf "\n \n⚙️  Panel installation completed\n \n"
    touch ./logs/ctrlpanel_installed
fi

#Running Cleanup
if [ -d "tmp" ]; then
    rm -rf tmp/*
fi
if [ -d "temp" ]; then
    rm -rf temp
fi
if [ -d ".composer" ]; then
    rm -rf .composer
fi
if [ -d ".yarn" ]; then
    rm -rf .yarn
fi
if [ -d ".cache" ]; then
    rm -rf .cache
fi
if [ -f ".yarnrc" ]; then
    rm -rf .yarnrc
fi

if [ "${DEVELOPER}" = "1" ]; then
    echo -e "🪄  Developer Mode Active"
    (
        cd "controlpanel" || exit
        echo -e "\n \n🎼  Running Composer...\n \n"
        composer install --no-dev --optimize-autoloader
        echo -e "\n \n🧹 Running Cleanup...\n \n"
        php artisan view:clear && php artisan config:clear
        echo -e "\n \n🔒  Running Permissions for storage and bootstrap/cache/ folders\n \n"
        fakeroot chmod -R 755 storage/* bootstrap/cache/
        echo -e "\n \n🔒  Running Permissions for controlpanel folder...\n \n"
        fakeroot chown -R nginx:nginx /home/container/controlpanel/*
    )
fi

if [ -f "./controlpanel/ctrlpanel_github_installed" ]; then
    echo -e "❗️  You are using a panel pulled from GitHub\n \n"
fi

if [ -z "$BACKUP" ] || [ "$BACKUP" == "1" ]; then
    if [ ! -d "backups" ]; then
        mkdir backups
    fi
    if [ ! -f "backups/executed" ]; then
        touch backups/executed
        sleep 5
    fi
    cp controlpanel/.env backups/.env-$(date +%F-%Hh%Mm)
    echo "🟢  .env backup performed!"
    echo "⚠️  Backups older than 1 week will be automatically deleted!"
    find ./backups/ -mindepth 1 -not -name "executed" -mtime +7 -delete
else
    echo "🟠  Backup system is disabled, if you lose your .env, you will no longer have access to your Database!"
fi

if [[ -f "./logs/ctrlpanel_installed" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/CtrlPanel/version.sh)
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/CtrlPanel/launch.sh)
else
    echo "Something very wrong happened."
fi

: <<'LIMBO'
LIMBO
