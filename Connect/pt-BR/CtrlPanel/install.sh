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
        printf "\n \n📄  Verificando Instalação...\n \n"
        printf "+----------+---------------------------------+\n| Tarefa   | Status                          |\n+----------+---------------------------------+"
        printf "\n| Painel   | 🟢  Instalado                    |"
    else
        cat <<EOF >./logs/log_install.txt
Versão: ${VERSION}
Git: ${GITHUB_PACKAGE}
Link: ${DOWNLOAD_LINK}
Arquivo: ${DOWNLOAD_LINK##*/}
EOF
        printf "\n \n📄  Verificando Instalação...\n \n"
        printf "+----------+---------------------------------+\n| Tarefa   | Status                          |\n+----------+---------------------------------+"
        printf "\n| Painel   | 🟡  Baixando Painel               |\n"
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
            if [ -f "backups/executado" ]; then
                (
                    cd controlpanel || exit
                    composer install --no-dev --optimize-autoloader
                )
                echo "🔴  Uma irregularidade foi encontrada, restaurando .env..."
                (
                    cd backups || exit
                    cp $(ls .env* -t | head -1) ../controlpanel/.env
                )
            else
                printf "\n📢  Atenção: MEU DEUS OQUE VOCÊ FEZ😱 😱  ??\n🥶  Oque você fez: Possivelmente você apagou a pasta controlpanel sem querer ou querendo, mas pelas minhas informações o painel já havia sido instalado  \n🫠  mano se vai ter que criar um database novo se você perdeu seu .env😨\n🔴  PARA PROSSEGUIR APAGUE OS ARQUIVO COM NOME PANEL NA PASTA LOGS PARA QUE O EGG CONSIGA INSTALAR CORRETAMENTE  🔴\n"
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
    if [ -d "/home/container/controlpanel" ]; then
        (
            cd controlpanel || exit
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
                fakeroot chown -R nginx:nginx /home/container/controlpanel/*
            fi
        )
    else
        if [ -z "${BRANCH}" ]; then
            echo -e "📋  Clonando ramo padrão"
            git clone --quiet "${GIT_ADDRESS}" ./controlpanel
        else
            echo -e "📋  Clonando ${BRANCH}'"
            git clone --quiet --single-branch --branch "${BRANCH}" "${GIT_ADDRESS}" ./controlpanel
        fi
        fakeroot chmod -R 755 /home/container/controlpanel/storage/* /home/container/controlpanel/bootstrap/cache/
        fakeroot chown -R nginx:nginx /home/container/controlpanel/*
        touch ./controlpanel/ctrlpanel_github_instalado
        if [ ! -f "controlpanel/.env" ]; then
            if [ -f "backups/executado" ]; then
                (
                    cd controlpanel || exit
                    composer install --no-interaction --no-dev --optimize-autoloader
                )
                echo "🔴  Uma irregularidade foi encontrada, restaurando .env..."
                (
                    cd backups || exit
                    cp $(ls .env* -t | head -1) ../controlpanel/.env
                )
            else
                printf "\n📢  Atenção: MEU DEUS OQUE VOCÊ FEZ😱 😱  ??\n🥶  Oque você fez: Possivelmente você apagou a pasta controlpanel sem querer ou querendo, mas pelas minhas informações o painel já havia sido instalado  \n🫠  mano se vai ter que criar um database novo se você perdeu seu .env😨\n🔴  PARA PROSSEGUIR APAGUE OS ARQUIVO COM NOME PANEL NA PASTA LOGS PARA QUE O EGG CONSIGA INSTALAR CORRETAMENTE  🔴\n"
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
    curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/CtrlPanel/default.conf -o ./nginx/conf.d/default.conf
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

if [ -f "logs/ctrlpanel_database_instalado" ]; then
    echo "| Env      | 🟢  Configurado                  |"
else
    if [ ! -f "controlpanel/.env" ]; then
        if [ -f "backups/executado" ]; then
            echo "| Env      | 🔴  Restaurando .env...          |"
            (
                cd backups || exit
                cp $(ls .env* -t | head -1) ../controlpanel/.env
            )
        fi
        (
            cd controlpanel || exit
            printf "\n \n⚙️  Executando: cp .env.example .env\n \n"
            cp .env.example .env
        )
    fi
fi

if [[ -f "logs/ctrlpanel_composer_instalado" ]]; then
    echo "| Composer | 🟢  Instalado                    |"
else
    (
        cd controlpanel || exit
        printf "\n \n⚙️  Executando: composer install --no-dev --optimize-autoloader\n \n"
        composer install --no-dev --optimize-autoloader
        touch ../logs/ctrlpanel_composer_instalado
    )
fi

if [[ -f "./logs/ctrlpanel_instalado" ]]; then
    echo "+----------+---------------------------------+"
    printf "\n \n📑  Verificação do Painel Concluída...\n \n"
else
    printf "\n \n⚙️  Executando: Atribuição de permissões\n \n"
    fakeroot chown -R nginx:nginx /home/container/controlpanel/*
    printf "\n \n⚙️  Instalação do painel concluída\n \n"
    touch ./logs/ctrlpanel_instalado
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
        cd "controlpanel" || exit
        echo -e "\n \n🎼  Executando Composer\n \n"
        composer install --no-dev --optimize-autoloader
        echo -e "\n \n🔒  Executando Permições das pastas storage e bootstrap/cache/\n \n"
        fakeroot chmod -R 755 storage/* bootstrap/cache/
        echo -e "\n \n🔒  Executando Permições da pasta home controlpanel\n \n"
        fakeroot chown -R nginx:nginx /home/container/controlpanel/*
    )
fi

if [ -f "./controlpanel/ctrlpanel_github_instalado" ]; then
    echo -e "❗️  Você está usando um painel puxado do GitHub\n \n"
fi

if [ -z "$BACKUP" ] || [ "$BACKUP" == "1" ]; then
    if [[ -f "./logs/ctrlpanel_database_instalado" ]]; then
        if [ ! -d "backups" ]; then
            mkdir backups
        fi
        if [ ! -f "backups/executado" ]; then
            touch backups/executado
            sleep 5
        fi
        cp controlpanel/.env backups/.env-$(date +%F-%Hh%Mm)
        echo "🟢  Backup do .env realizado!"
        echo "⚠️  Backups com mais de 1 semana serão deletados automaticamente!"
        find ./backups/ -mindepth 1 -not -name "executado" -mtime +7 -delete
    else
        echo "Database não instalado, pulando backup do .env"
    fi
else
    echo "🟠  Sistema de backups está desativado, caso perca seu .env, você não terá mais acesso ao seu Database!"
fi

if [[ -f "./logs/ctrlpanel_instalado" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/CtrlPanel/version.sh)
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/CtrlPanel/launch.sh)
else
    echo "Algo muito errado aconteceu."
fi

: <<'LIMBO'
LIMBO
