#!/bin/bash

## Instalando Nginx
if [ ! -d "./nginx" ] || [ ! -d "./php-fpm" ]; then
git clone https://github.com/finnie2006/ptero-nginx ./temp
cp -r ./temp/nginx ./
cp -r ./temp/php-fpm ./
rm -rf ./temp
rm -rf ./webroot/*
fi

## Instalando youtube-dl-web
if [ ! -d "youtube-dl-web" ]; then
git clone https://github.com/xxcodianxx/youtube-dl-web
    (
        cd youtube-dl-web || exit
        rm -rf .git .github images nginx .gitignore docker-compose.yml LICENSE README.md
    )
fi

if [ ! -d "[your files]" ]; then
    mkdir "[your files]"
fi

if [ ! -d logs ]; then
    mkdir logs
fi
## configurando Nginx
if [ ! -f "./logs/config_nginx" ]; then
(
    cd nginx/conf.d/ || exit
    rm default.conf
    wget https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Youtube-DL/default.conf
    touch ../../logs/config_nginx
)
fi

fakeroot chown -R nginx:nginx youtube-dl-web && chmod -R 755 youtube-dl-web

if [ ! -f "./logs/instalado" ]; then
echo "**** Limpando ****"
rm -rf /tmp/*
echo "**** configure php and nginx for youtube-dl-web ****" &&
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
fi

if [ ! -d "./tmp" ]; then
    mkdir tmp
fi


if [[ -d "./youtube-dl-web/frontend/build" ]]; then
    #Executando Limpeza
    rm -rf tmp/* temp .composer .yarn .cache .yarnrc

    echo "✓ Atualizando o script start.sh"
    curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Youtube-DL/start.sh -o start.sh
    chmod a+x ./start.sh
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Youtube-DL/launch.sh)
else
    echo "Algo muito errado aconteceu..."
fi
