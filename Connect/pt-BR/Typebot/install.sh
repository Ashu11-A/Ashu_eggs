#!/bin/bash
GITHUB_PACKAGE=baptisteArno/typebot.io
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
if [ -d "/home/container/Typebot" ]; then
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
    if [ -z "$VERSION" ]; then
        if [ -d Typebot ]; then
            mkdir Typebot
        fi
        git clone https://github.com/$GITHUB_PACKAGE ./Typebot
    else
        curl -sSL "${DOWNLOAD_LINK}" -o "${DOWNLOAD_LINK##*/}"
        mkdir Typebot
        mv "${DOWNLOAD_LINK##*/}" Typebot
        (
            cd Typebot || exit
            echo -e "Unpacking server files"
            tar -xvzf "${DOWNLOAD_LINK##*/}"
            rm -rf "${DOWNLOAD_LINK##*/}"
        )
    fi
    (
        cd Typebot || exit
        fakeroot chmod -R 755 ./*
        fakeroot chown -R nginx:nginx /home/container/Typebot/*
    )
    if [ ! -f "Typebot/.env" ]; then
        if [ -f "backups/executado" ]; then
            echo "🔴  Uma irregularidade foi encontrada, restaurando .env..."
            (
                cd backups || exit
                cp $(ls .env* -t | head -1) ../Typebot/.env
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
if [ -d "temp" ]; then ## Evita conflitos no painel pelo comando seguinte do git
    rm -rf temp
fi
git clone --quiet https://github.com/Ashu11-A/nginx ./temp
if [ -f "/home/container/nginx/nginx.conf" ]; then
    printf "\n| Nginx    | 🟢  Instalado                    |"
else
    printf "\n| Nginx    | 🟡  Baixando Nginx...            |"
    cp -r ./temp/nginx ./
    rm nginx/conf.d/default.conf
    curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/Typebot/default.conf -o ./nginx/conf.d/default.conf
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

if [ ! -f "Typebot/.env" ]; then
    if [ -f "backups/executado" ]; then
        echo "| Env      | 🔴  Restaurando .env...          |"
        (
            cd backups || exit
            cp $(ls .env* -t | head -1) ../Typebot/.env
        )
    fi
    (
        cd Typebot || exit
        printf "\n \n⚙️  Executando: cp .env.example .env\n \n"
        cp .env.example .env
    )
fi


if [[ -f "./logs/typebot_instalado" ]]; then
    echo "+----------+---------------------------------+"
    printf "\n \n📑  Verificação do Painel Concluída...\n \n"
else
    printf "\n \n⚙️  Executando: Atribuição de permissões\n \n"
    fakeroot chown -R nginx:nginx /home/container/Typebot/*
    printf "\n \n⚙️  Instalação do painel concluída\n \n"
    touch ./logs/typebot_instalado
fi

#Executando Limpeza
if [ -d "tmp" ]; then
    rm -rf tmp/*
fi
if [ -d "temp" ]; then
    rm -rf temp
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
        cd "Typebot" || exit
        echo -e "\n \n🎼  Executando Composer...\n \n"
        composer install --no-dev --optimize-autoloader
        echo -e "\n \n🧹 Executando Limpeza...\n \n"
        php artisan view:clear && php artisan config:clear
        echo -e "\n \n🔒  Executando Permições das pastas storage e bootstrap/cache/\n \n"
        fakeroot chmod -R 755 storage/* bootstrap/cache/
        echo -e "\n \n🔒  Executando Permições da pasta Typebot...\n \n"
        fakeroot chown -R nginx:nginx /home/container/Typebot/*
    )
fi

if [ -z "$BACKUP" ] || [ "$BACKUP" == "1" ]; then
    if [ ! -d "backups" ]; then
        mkdir backups
    fi
    if [ ! -f "backups/executado" ]; then
        touch backups/executado
        sleep 5
    fi
    cp Typebot/.env backups/.env-$(date +%F-%Hh%Mm)
    echo "🟢  Backup do .env realizado!"
    echo "⚠️  Backups com mais de 1 semana serão deletados automaticamente!"
    find ./backups/ -mindepth 1 -not -name "executado" -mtime +7 -delete
else
    echo "🟠  Sistema de backups está desativado, caso perca seu .env, você não terá mais acesso ao seu Database!"
fi

if [[ -f "./logs/typebot_instalado" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/Typebot/version.sh)
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/Typebot/launch.sh)
else
    echo "Algo muito errado aconteceu."
fi

: <<'LIMBO'
LIMBO
