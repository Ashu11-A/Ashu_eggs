#!/bin/ash
if [[ -f "./logs/instalado" ]]; then
    if [ "${OCC}" == "1" ]; then 
        php ./nextcloud/occ ${COMMANDO_OCC}
        exit
    else
        echo "✓ Atualizando o script install.sh"
        curl -o -s install.sh https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Nextcloud/install.sh;
        chmod a+x ./install.sh
        echo "✓ Atualizando o script start.sh"
        curl -o -s start.sh https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Nextcloud/start.sh;
        chmod a+x ./start.sh;
        ./start.sh;
    fi
else
    cd /mnt/server/
    mkdir php-fpm

    echo "**** Fazendo o download do nextcloud ****"
    rm -rf nextcloud/
    if [ "${NEXTCLOUD_RELEASE}" == "latest" ] ; then
        DOWNLOAD_LINK=$(echo -e "${NEXTCLOUD_RELEASE}.zip")
    else
        DOWNLOAD_LINK=$(echo -e "nextcloud-${NEXTCLOUD_RELEASE}.zip")
    fi
fi

echo "✓ Atualizando o script install.sh"
curl -o -s install.sh https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Nextcloud/install.sh

git clone https://github.com/finnie2006/ptero-nginx ./temp
cp -r ./temp/nginx /mnt/server/
cp -r ./temp/php-fpm /mnt/server/
rm -rf ./temp
rm -rf /mnt/server/webroot/*
mkdir logs
rm nginx/conf.d/default.conf
cd nginx/conf.d/
wget https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Nextcloud/default.conf
cd /mnt/server
cat <<EOF > ./logs/install_log.txt
Versão: $NEXTCLOUD_RELEASE
Link: https://download.nextcloud.com/server/releases/${DOWNLOAD_LINK}
Arquivo: ${DOWNLOAD_LINK}
EOF

wget https://download.nextcloud.com/server/releases/${DOWNLOAD_LINK}
unzip ${DOWNLOAD_LINK}
rm -rf ${DOWNLOAD_LINK}

chown -R nginx:nginx nextcloud && chmod -R 755 nextcloud
echo "**** Limpando ****"
rm -rf /tmp/*
echo "**** configure php and nginx for nextcloud ****" && \
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