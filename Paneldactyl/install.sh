#!/bin/ash
if [[ -f "./logs/instalado" ]]; then
    if [ "${OCC}" == "1" ]; then 
        cd painel 
        php ${COMMANDO_OCC}
        exit
    else
        if [[ -f "./logs/instalado_database" ]]; then
            echo "✓ Atualizando o script install.sh"
            curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Paneldactyl/install.sh -o install.sh;
            chmod a+x ./install.sh
            echo "✓ Atualizando o script start.sh"
            curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Paneldactyl/start.sh -o start.sh;
            chmod a+x ./start.sh;
            ./start.sh;
        else
            cd painel
            cp .env.example .env
            composer install --no-interaction --no-dev --optimize-autoloader
            php artisan key:generate --force
            php artisan p:environment:setup
            php artisan p:environment:database
            php artisan migrate --seed --force
            php artisan p:user:make
            cd ..
            fakeroot chown -R nginx:nginx /home/container/painel/*
            touch ./logs/instalado_database
        fi
    fi
else
    cd /mnt/server/
    mkdir php-fpm

    echo "**** Fazendo o download do painel ****"

    GITHUB_PACKAGE=Jexactyl-Brasil/Jexactyl-Brasil
    LATEST_JSON=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq -c '.[]' | head -1)
    RELEASES=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq '.[]')

    if [ -z "$VERSION" ] || [ "$VERSION" == "latest" ]; then
        echo -e "Baixando a versão mais recente por causa de um erro"
        DOWNLOAD_LINK=$(echo $LATEST_JSON | jq .assets | jq -r .[].browser_download_url | grep -i panel.tar.gz)
    else
    VERSION_CHECK=$(echo $RELEASES | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .tag_name')
        if [ "$VERSION" == "$VERSION_CHECK" ]; then
            if [[ "$VERSION" == v* ]]; then
                DOWNLOAD_LINK=$(echo $RELEASES | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .assets[].browser_download_url' | grep -i panel.tar.gz)
            fi
        else
            echo -e "Baixando a versão mais recente por causa de um erro"
            DOWNLOAD_LINK=$(echo $LATEST_JSON | jq .assets | jq -r .[].browser_download_url | grep -i panel.tar.gz)
        fi
    fi

    echo "✓ Atualizando o script install.sh"
    curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Paneldactyl/install.sh -o install.sh

    git clone https://github.com/finnie2006/ptero-nginx ./temp
    cp -r ./temp/nginx /mnt/server/
    cp -r ./temp/php-fpm /mnt/server/
    rm -rf ./temp
    rm -rf /mnt/server/webroot/*
    mkdir logs
    rm nginx/conf.d/default.conf
    cd nginx/conf.d/
    wget https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Paneldactyl/default.conf
    cd /mnt/server
    cat <<EOF > ./logs/log_install.txt
Versão: ${VERSION}
Link: ${DOWNLOAD_LINK}
Arquivo: ${DOWNLOAD_LINK##*/}
EOF

    echo -e "running 'curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}'"
    curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}
    echo -e "Unpacking server files"
    mkdir painel
    mv ${DOWNLOAD_LINK##*/} painel
    cd painel
    tar -xvzf ${DOWNLOAD_LINK##*/}
    rm -rf ${DOWNLOAD_LINK##*/}
    chmod -R 755 storage/* bootstrap/cache/
    chown -R nginx:nginx /home/container/painel/*
    cd ..
    echo "**** Limpando ****"
    rm -rf /tmp/*
    echo "**** configure php and nginx for panels ****" && \
    echo "extension="smbclient.so"" > php-fpm/conf.d/00_smbclient.ini && \
    echo 'apc.enable_cli=1' >> php-fpm/conf.d/apcu.ini && \
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
    php-fpm/php.ini && \
    sed -i \
    '/opcache.enable=1/a opcache.enable_cli=1' \
    php-fpm/php.ini && \
    echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> php-fpm/php-fpm.conf
    touch ./logs/instalado
    mkdir tmp
fi