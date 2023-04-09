#!/bin/bash
if [[ -f "./logs/instalado" ]]; then
    echo "✓ Atualizando o script start.sh"
    curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Youtube-DL/start.sh -o start.sh
    chmod a+x ./start.sh
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Youtube-DL/launch.sh)
else
    cd /mnt/server/ || exit
    mkdir php-fpm
    ## Instalando Nginx
    git clone https://github.com/finnie2006/ptero-nginx ./temp
    cp -r ./temp/nginx /mnt/server/
    cp -r ./temp/php-fpm /mnt/server/
    rm -rf ./temp
    rm -rf /mnt/server/webroot/*
    ##################

    ## Instalando youtube-dl-web
    git clone https://github.com/xxcodianxx/youtube-dl-web
    ##################

    if [ -d logs ]; then
        echo "Pasta logs já existe, pulando..."
    else
        mkdir logs
    fi
    ## configurando Nginx
    (
        cd nginx/conf.d/ || exit
        rm default.conf
        wget https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Youtube-DL/default.conf
    )
    #####################

    chown -R nginx:nginx nextcloud && chmod -R 755 nextcloud
    echo "**** Limpando ****"
    rm -rf /tmp/*
    echo "**** configure php and nginx for nextcloud ****" &&
        echo "extension="smbclient.so"" >php-fpm/conf.d/00_smbclient.ini &&
        echo 'apc.enable_cli=1' >>php-fpm/conf.d/apcu.ini &&
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
            php-fpm/php.ini &&
        sed -i \
            '/opcache.enable=1/a opcache.enable_cli=1' \
            php-fpm/php.ini &&
        echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >>php-fpm/php-fpm.conf
    touch ./logs/instalado
    mkdir tmp
fi
