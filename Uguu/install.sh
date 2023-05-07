#!/bin/bash
bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
normal=$(echo -en "\e[0m")

export bold
export lightblue
export normal

if [ ! -d Logs ]; then
    mkdir Logs
fi

## Instalando Postgres
if [ ! -f "./Logs/database_instalado" ]; then
    if [ "$PWD" = "/mnt/server/" ]; then
        # Comandos a serem executados se estiver na pasta /mnt/server/
        # Server Files: /mnt/server
        apt update
        apt upgrade -y
        apt install -y curl wget unzip git tar ca-certificates jq fuse figlet lolcat
        adduser -D -h /home/container container
        chown -R container: /mnt/server/
        su container -c 'initdb -D /mnt/server/DB/ -A md5 -U "$PGUSER" --pwfile=<(echo "$PGPASSWORD")'
        mkdir -p /mnt/server/DB/run/
        ## Add default "allow from all" auth rule to pg_hba
        if ! grep -q "# Custom rules" "/mnt/server/DB/pg_hba.conf"; then
            echo -e "# Custom rules\nhost all all 0.0.0.0/0 md5" >>"/mnt/server/DB/pg_hba.conf"
        fi
        touch ./Logs/database_instalado
    else
        # Comandos a serem executados se NÃO estiver na pasta /mnt/server/
        echo "📢  ATENÇÃO: Não tenho acesso root, então não posso instalar o Database, reinstale o Egg!"
    fi
fi

lolcat=/usr/games/lolcat
echo -e "\n \n$(figlet -c -f slant -t -k "Uguu")\n                                         by Ashu" | $lolcat

## Instalando Nginx
if [ ! -d "./nginx" ]; then
    git clone https://github.com/Ashu11-A/nginx ./temp
    cp -r ./temp/nginx ./
    rm -rf ./temp
    rm -rf ./webroot/*
fi

## Instalando Uguu
if [ ! -d "Uguu" ]; then
    git clone https://github.com/nokonoko/Uguu Uguu
    (
        cd Uguu || exit
        rm -rf .git .gitignore README.md
    )
fi

## Criando arquivos necessarios...
if [ ! -d "Uguu/dist" ]; then
    mkdir Uguu/dist
fi
if [ ! -d "DB" ]; then
    mkdir DB
fi
if [ ! -d "files" ]; then
    mkdir files
fi
if [ ! -d "[your files]" ]; then
    mkdir "[your files]"
fi

## configurando Nginx
if [ ! -f "./Logs/config_nginx" ]; then
    (
        cd nginx/conf.d/ || exit
        rm default.conf
        wget https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Uguu/default.conf
        touch ../../Logs/config_nginx
    )
fi

fakeroot chown -R nginx:nginx Uguu && chmod -R 755 Uguu

if [ ! -f "./Logs/instalado" ]; then
    echo "**** Limpando ****"
    rm -rf /tmp/*
    echo "**** configure php and nginx for Uguu ****" &&
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
    touch ./Logs/instalado
fi

if [ ! -d "./tmp" ]; then
    mkdir tmp
fi

if [[ -d "./Uguu" ]]; then
    #Executando Limpeza
    rm -rf tmp/* temp .composer .yarn .cache .yarnrc

    echo "✓ Atualizando o script start.sh"
    curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Uguu/start.sh -o start.sh
    chmod a+x ./start.sh
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Uguu/launch.sh)
else
    echo "Algo muito errado aconteceu..."
fi
