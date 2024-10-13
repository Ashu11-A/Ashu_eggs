#!/bin/bash

if [ -d "nvm" ]; then
	source "/home/container/.nvm/nvm.sh"
fi

if [ -f /etc/os-release ]; then
    # Pega a informação da distribuição
    distro=$(grep ^ID= /etc/os-release | cut -d'=' -f2 | tr -d '"')
    
    # Verifica se é Alpine ou Debian
    if [ "$distro" = "alpine" ]; then
        echo "⚠️ You are using an alpine version, in this version it is not possible to change the nodejs version, it will only be possible if you change the docker image in the latest Egg! If you are using the debian version, you can use the nvm tool!"
    elif [ "$distro" = "debian" ]; then
    	if [[ ! -d ".nvm" ]]; then
            echo -e "\n \n⚠️  NVM not installed...\n \n"
            mkdir -p $NVM_DIR
            curl -sSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh -o nvm.sh
            chmod a+x ./nvm.sh
            ./nvm.sh
            rm ./nvm.sh
            source "/home/container/.nvm/nvm.sh"
        fi
    
        if [[ -d ".nvm" ]]; then
            if [ ! -f "logs/nodejs_version" ]; then
                bash <(curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/nvm_install.sh")
            fi
            # NVM Initialization
            source "/home/container/.nvm/nvm.sh"
            NVM_DIR=/home/container/.nvm
            NODE_VERSION="$(cat logs/nodejs_version)"

            if [ -z "$NODE_VERSION" ]; then
                echo -e "\n \n🥶 Version not found, using version 18\n \n"
                NODE_VERSION="18"
            fi

            nvm install v$NODE_VERSION
            nvm use v$NODE_VERSION

            export NODE_PATH=$NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
            export PATH="$PATH":/home/container/.nvm/versions/node/v$NODE_VERSION/bin
            export NVM_DIR=$NVM_DIR
            export NODE_VERSION=$NODE_VERSION
        fi
    fi
fi

bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
normal=$(echo -en "\e[0m")

if [ -z "${PANEL}" ]; then ## Caso a variavel ${PANEL} não existir por algum motivo desconhecido
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
    elif [ "${PANEL}" != "Pterodactyl" ] && [ "${PANEL}" != "Jexactyl" ] && [ "${PANEL}" != "Jexactyl Brasil" ] && [ "${PANEL}" != "Pterodactyl Brasil" ]; then ## Verifica se...
        echo "Por algum motivo não foi possivel detectar o Painel que será instalado, instalando por padrão: Jexactyl Brasil"
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
    if [ -d "/home/container/painel" ]; then
        printf "\n \n📄  Verificando Instalação...\n \n"
        printf "+----------+---------------------------------+\n| Tarefa   | Status                          |\n+----------+---------------------------------+"
        printf "\n| Painel   | 🟢  Instalado                    |"
    else
        cat <<EOF >./logs/log_install.txt
Versão: ${VERSION}
Git: ${GITHUB_PACKAGE}
Git_file: ${FILE}
Link: ${DOWNLOAD_LINK}
Arquivo: ${DOWNLOAD_LINK##*/}
EOF
        printf "\n \n📄  Verificando Instalação...\n \n"
        printf "+----------+---------------------------------+\n| Tarefa   | Status                          |\n+----------+---------------------------------+"
        printf "\n| Painel   | 🟡  Baixando Painel               |\n"
        curl -sSL "${DOWNLOAD_LINK}" -o "${DOWNLOAD_LINK##*/}"
        mkdir -p painel
        mv "${DOWNLOAD_LINK##*/}" painel
        (
            cd painel || exit
            echo -e "Unpacking server files"
            tar -xvzf "${DOWNLOAD_LINK##*/}"
            rm -rf "${DOWNLOAD_LINK##*/}"
            fakeroot chmod -R 755 storage/* bootstrap/cache/
            fakeroot chown -R nginx:nginx /home/container/painel/*
        )
        if [ -f "logs/panel_database_instalado" ]; then
            if [ ! -f "painel/.env" ]; then
                if [ -f "backups/executado" ]; then
                    (
                        cd painel || exit
                        composer install --no-interaction --no-dev --optimize-autoloader
                    )
                    echo "🔴  Uma irregularidade foi encontrada, restaurando .env..."
                    (
                        cd backups || exit
                        cp $(ls .env* -t | head -1) ../painel/.env
                    )
                else
                    printf "\n📢  Atenção: MEU DEUS OQUE VOCÊ FEZ😱 😱  ??\n🥶  Oque você fez: Possivelmente você apagou a pasta painel sem querer ou querendo, mas pelas minhas informações o painel já havia sido instalado  \n🫠  mano se vai ter que criar um database novo se você perdeu seu .env😨\n🔴  PARA PROSSEGUIR APAGUE OS ARQUIVO COM NOME PANEL NA PASTA LOGS PARA QUE O EGG CONSIGA INSTALAR CORRETAMENTE  🔴\n"
                    printf "\n \n📌  Apagar os arquivos panel da pasta logs? [y/N]\n \n"
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
    echo -e "\n \n📌  Usando repo do GitHub"
    if [[ ${GIT_ADDRESS} != *.git ]]; then
        GIT_ADDRESS=${GIT_ADDRESS}.git
    fi
    if [ -z "${USERNAME}" ] && [ -z "${ACCESS_TOKEN}" ]; then
        echo -e "🤫  Usando chamada de API anonimo."
    else
        GIT_ADDRESS="https://${USERNAME}:${ACCESS_TOKEN}@$(echo -e "${GIT_ADDRESS}" | cut -d/ -f3-)"
    fi
    ## pull git js bot repo
    if [ -d "/home/container/painel" ]; then
        (
            cd painel || exit
            if [ -d ".git" ]; then
                if [ -f ".git/config" ]; then
                    ORIGIN=$(git config --get remote.origin.url)
                else
                    echo -e "arquivos encontrados sem configuração de git"
                    echo -e "encerrar sem tocar nas coisas para não quebrar nada"
                    exit 10
                fi
            fi
            if [ "${ORIGIN}" == "${GIT_ADDRESS}" ]; then
                echo "📁  Puxando o mais recente do GitHub"
                git pull --quiet
                fakeroot chmod -R 755 storage/* bootstrap/cache/
                fakeroot chown -R nginx:nginx /home/container/painel/*
            fi
        )
    else
        if [ -z "${BRANCH}" ]; then
            echo -e "📋  Clonando ramo padrão"
            git clone --quiet "${GIT_ADDRESS}" ./painel
        else
            echo -e "📋  Clonando ${BRANCH}'"
            git clone --quiet --single-branch --branch "${BRANCH}" "${GIT_ADDRESS}" ./painel
        fi
        fakeroot chmod -R 755 /home/container/painel/storage/* /home/container/painel/bootstrap/cache/
        fakeroot chown -R nginx:nginx /home/container/painel/*
        touch ./painel/panel_github_instalado
        if [ -f "logs/panel_database_instalado" ]; then
            if [ ! -f "painel/.env" ]; then
                if [ -f "backups/executado" ]; then
                    (
                        cd painel || exit
                        composer install --no-interaction --no-dev --optimize-autoloader
                    )
                    echo "🔴  Uma irregularidade foi encontrada, restaurando .env..."
                    (
                        cd backups || exit
                        cp $(ls .env* -t | head -1) ../painel/.env
                    )
                else
                    printf "\n📢  Atenção: MEU DEUS OQUE VOCÊ FEZ😱 😱  ??\n🥶  Oque você fez: Possivelmente você apagou a pasta painel sem querer ou querendo, mas pelas minhas informações o painel já havia sido instalado  \n🫠  mano se vai ter que criar um database novo se você perdeu seu .env😨\n🔴  PARA PROSSEGUIR APAGUE OS ARQUIVO COM NOME PANEL NA PASTA LOGS PARA QUE O EGG CONSIGA INSTALAR CORRETAMENTE  🔴\n"
                    printf "\n \n📌  Apagar os arquivos panel da pasta logs? [y/N]\n \n"
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
    printf "\n \n📄  Verificando Instalação...\n \n"
    printf "+----------+---------------------------------+\n| Tarefa   | Status                          |\n+----------+---------------------------------+"
    printf "\n| Painel   | 🟡  Puxando arquivos             |"
fi
if [ -d "temp" ]; then ## Evita conflitos no painel pelo comando seguinte do git
    rm -rf temp
fi
git clone --quiet https://github.com/Ashu11-A/nginx ./temp ## Sim, ele sempre irá clonar o repo idenpendente de tudo
if [ -f "/home/container/nginx/nginx.conf" ]; then
    printf "\n| Nginx    | 🟢  Instalado                    |"
else
    printf "\n| Nginx    | 🟡  Baixando Nginx...            |"
    cp -r ./temp/nginx ./
    rm nginx/conf.d/default.conf
    curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/Paneldactyl/default.conf -o ./nginx/conf.d/default.conf
    sed -i \
        -e "s/listen.*/listen ${SERVER_PORT};/g" \
        nginx/conf.d/default.conf
fi
if [ -d "/home/container/php-fpm" ]; then
    printf "\n| PHP-FPM  | 🟢  Instalado                    |\n+----------+---------------------------------+\n"
else
    printf "\n| PHP-FPM  | 🟡  Baixando PHP-FPM...          |\n+----------+---------------------------------+\n"
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
    cd painel || exit
    php "${COMMANDO_OCC}"
    exit
else
    if [ -f "logs/panel_database_instalado" ]; then
        echo "| Env      | 🟢  Configurado                  |"
    else
        if [ ! -f "painel/.env" ]; then
            if [ -f "backups/executado" ]; then
                echo "| Env      | 🔴  Restaurando .env...          |"
                (
                    cd backups || exit
                    cp $(ls .env* -t | head -1) ../painel/.env
                )
            fi
            (
                cd painel || exit
                printf "\n \n⚙️  Executando: cp .env.example .env\n \n"
                cp .env.example .env
            )
        fi
    fi
    (
        cd painel || exit
        if [[ -f "../logs/panel_composer_instalado" ]]; then
            echo "| Composer | 🟢  Instalado                    |"
        else
            printf "\n \n⚙️  Executando: composer install --no-interaction --no-dev --optimize-autoloader\n \n"
            composer install --no-interaction --no-dev --optimize-autoloader
            touch ../logs/panel_composer_instalado
        fi
        if [[ -f "../logs/panel_key_generate_instalado" ]]; then
            echo "| Key      | 🟢  Gerada                       |"
        else
            printf "\n \n⚙️  Executando: php artisan key:generate --force\n \n"
            php artisan key:generate --force
            touch ../logs/panel_key_generate_instalado
        fi

        if [[ -f "../logs/panel_setup_instalado" ]]; then
            echo "| Setup    | 🟢  Configurado                  |"
        else
            printf "\n \n⚙️  Executando: php artisan p:environment:setup\n \n"
            php artisan p:environment:setup
            touch ../logs/panel_setup_instalado
            printf "\n \n📌  Executar o comando anterior novamente? [y/N]\n \n"
            read -r response
            case "$response" in
            [yY][eE][sS] | [yY])
                php artisan p:environment:setup
                ;;
            *) ;;
            esac
        fi
        if [[ -f "../logs/panel_database_instalado" ]]; then
            echo "| Database | 🟢  Configurado                  |"
        else
            printf "\n \n⚙️  Executando: php artisan p:environment:database\n \n"
            php artisan p:environment:database
            touch ../logs/panel_database_instalado
            printf "\n \n📌  Executar o comando anterior novamente? [y/N]\n \n"
            read -r response
            case "$response" in
            [yY][eE][sS] | [yY])
                php artisan p:environment:database
                ;;
            *)
                printf "\n \n⚙️  Executando: php artisan migrate --seed --force\n \n"
                ;;
            esac
        fi
        if [[ -f "../logs/panel_database_migrate_instalado" ]]; then
            echo "| Migração | 🟢  Concluído                    |"
        else
            php artisan migrate --seed --force
            touch ../logs/panel_database_migrate_instalado
            printf "\n \n📌  Executar o comando anterior novamente? [y/N]\n \n"
            read -r response
            case "$response" in
            [yY][eE][sS] | [yY])
                php artisan migrate --seed --force
                ;;
            *) ;;
            esac
        fi
        if [[ -f "../logs/panel_user_instalado" ]]; then
            echo "| Usuário  | 🟢  Criado                       |"
        else
            printf "\n \n⚙️  Executando: php artisan p:user:make\n \n"
            php artisan p:user:make
            touch ../logs/panel_user_instalado
            printf "\n \n📌  Executar o comando anterior novamente? [y/N]\n \n"
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
        echo "+----------+---------------------------------+"
        printf "\n \n📑  Verificação do Painel Concluída...\n \n"
    else
        printf "\n \n⚙️  Executando: Atribuição de permissões\n \n"
        fakeroot chown -R nginx:nginx /home/container/painel/*
        printf "\n \n⚙️  Instalação do painel concluída\n \n"
        touch ./logs/panel_instalado
    fi
fi

#Executando Limpeza
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
    echo -e "🪄  Modo Desenvolvedor Ativo"
    (
        cd "painel" || exit
        echo -e "\n \n🔒  Executando Permições das pastas storage e bootstrap/cache/\n \n"
        fakeroot chmod -R 755 storage/* bootstrap/cache/
        echo -e "\n \n🎼  Executando Composer\n \n"
        composer install --no-dev --optimize-autoloader
        echo -e "\n \n📂  Executando Migração do Banco de Dados\n \n"
        php artisan migrate --seed --force
        echo -e "\n \n📂  Executando Limpeza de Cache/View/Route\n \n"
        php artisan view:clear 
        php artisan cache:clear 
        php artisan route:clear
        echo -e "\n \n🔒  Executando Permições da pasta home painel\n \n"
        fakeroot chown -R nginx:nginx /home/container/painel/*
    )
fi

if [ -f "./painel/panel_github_instalado" ]; then
    echo -e "❗️  Você está usando um painel puxado do GitHub, será necessário executar o comando ${bold}${lightblue}build${normal}, pois o servidor irá retornar erro 500.\n \n"
fi

if [ -z "$BACKUP" ] || [ "$BACKUP" == "1" ]; then
    if [[ -f "./logs/panel_database_instalado" ]]; then
        if [ ! -d "backups" ]; then
            mkdir -p backups
        fi
        if [ ! -f "backups/executado" ]; then
            touch backups/executado
            sleep 5
        fi
        cp painel/.env backups/.env-$(date +%F-%Hh%Mm)
        echo "🟢  Backup do .env realizado!"
        echo "⚠️  Backups com mais de 1 semana serão deletados automaticamente!"
        find ./backups/ -mindepth 1 -not -name "executado" -mtime +7 -delete
    else
        echo "Database não instalado, pulando backup do .env"
    fi
else
    echo "🟠  Sistema de backups está desativado, caso perca seu .env, você não terá mais acesso ao seu Database!"
fi

if [[ -f "./logs/panel_instalado" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/Paneldactyl/version.sh)
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/Paneldactyl/launch.sh)
else
    echo "Algo muito errado aconteceu."
fi

: <<'LIMBO'
LIMBO
