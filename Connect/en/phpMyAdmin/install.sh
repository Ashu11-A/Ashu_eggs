#!/bin/bash
if [ -d "/home/container/phpMyAdmin" ]; then
    printf "\n \n📄  Checking Installation...\n \n"
    printf "+------------+--------------------------------+\n| Task       | Status                         |\n+------------+--------------------------------+"
    printf "\n| phpMyAdmin | 🟢  Installed                   |"
else
    printf "\n \n📄  Checking Installation...\n \n"
    printf "+------------+--------------------------------+\n| Task       | Status                         |\n+------------+--------------------------------+"
    printf "\n| phpMyAdmin | 🟡  Downloading phpMyAdmin      |\n"

    wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-english.tar.gz
    mkdir phpMyAdmin
    echo -e "Unpacking server files"
    tar xvzf phpMyAdmin-latest-english.tar.gz
    mv phpMyAdmin-*-english/* phpMyAdmin
    rm -rf phpMyAdmin-*-english.tar.gz
    rm -rf phpMyAdmin-*-english
    (
        cd phpMyAdmin || exit
        cp config.sample.inc.php config.inc.php
    )
    fakeroot chmod -R 755 ./*
fi

if [ -d "temp" ]; then ## Avoids conflicts in the panel by the following git command
    rm -rf temp
fi

git clone --quiet https://github.com/Ashu11-A/nginx ./temp ## Yes, it will always clone the repo regardless of everything
if [ -f "/home/container/nginx/nginx.conf" ]; then
    printf "\n| Nginx      | 🟢  Installed                    |"
else
    printf "\n| Nginx      | 🟡  Downloading Nginx...         |"
    cp -r ./temp/nginx ./
    rm nginx/conf.d/default.conf
    curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/phpMyAdmin/default.conf -o ./nginx/conf.d/default.conf
    sed -i \
        -e "s/listen.*/listen ${SERVER_PORT};/g" \
        nginx/conf.d/default.conf
fi
if [ -d "/home/container/php-fpm" ]; then
    printf "\n| PHP-FPM    | 🟢  Installed                    |\n+------------+--------------------------------+\n"
else
    printf "\n| PHP-FPM    | 🟡  Downloading PHP-FPM...       |\n+------------+--------------------------------+\n"
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

if [[ -f "./logs/phpMyAdmin_installed" ]]; then
    printf "\n \n📑  Panel Verification Completed...\n \n"
else
    printf "\n \n⚙️  Running: Assigning permissions\n \n"
    fakeroot chown -R nginx:nginx ./*
    printf "\n \n⚙️  Panel installation completed\n \n"
    touch ./logs/phpMyAdmin_installed
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

if [[ -f "./logs/phpMyAdmin_installed" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/phpMyAdmin/version.sh)
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/phpMyAdmin/launch.sh)
else
    echo "Something very wrong happened."
fi

: <<'LIMBO'
LIMBO
