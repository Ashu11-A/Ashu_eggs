#!/bin/ash

BASE_DIR="/mnt/server"

if [ -d "/home/container" ]; then
  BASE_DIR="/home/container"
fi

cd "$BASE_DIR"
mkdir -p php-fpm

if [ "${NEXTCLOUD_RELEASE}" == "latest" ] ; then
  DOWNLOAD_LINK=$(echo -e "${NEXTCLOUD_RELEASE}.zip")
else
  DOWNLOAD_LINK=$(echo -e "nextcloud-${NEXTCLOUD_RELEASE}.zip")
fi

cd "$BASE_DIR"

git clone https://github.com/finnie2006/ptero-nginx ./temp
cp -r ./temp/nginx "$BASE_DIR"/
cp -r ./temp/php-fpm "$BASE_DIR"/
rm -rf ./temp
rm -rf "$BASE_DIR"/webroot/*

(
  cd nginx/conf.d/
  rm default.conf
  rm nextcloud.conf
  wget https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Nextcloud/default.conf
)

cat <<EOF > ./logs/install_log.txt
Version: $NEXTCLOUD_RELEASE
Link: https://download.nextcloud.com/server/releases/${DOWNLOAD_LINK}
File: ${DOWNLOAD_LINK}
EOF

echo "**** Downloading Nextcloud ****"
wget https://download.nextcloud.com/server/releases/${DOWNLOAD_LINK}
unzip -o ${DOWNLOAD_LINK}
rm -rf ${DOWNLOAD_LINK}

echo "**** configure php and nginx for nextcloud ****"
echo "extension=\"smbclient.so\"" > php-fpm/conf.d/00_smbclient.ini
echo 'apc.enable_cli=1' >> php-fpm/conf.d/apcu.ini
chown -R nginx:nginx nextcloud && chmod -R 755 nextcloud
echo "**** Cleaning up ****"
rm -rf /tmp/*
sed -i \
  -e 's/^memory_limit\s*=.*/memory_limit = 1024M/' \
  -e 's/^upload_max_filesize\s*=.*/upload_max_filesize = 16G/' \
  -e 's/^post_max_size\s*=.*/post_max_size = 16G/' \
  -e 's/^date\.timezone\s*=.*/date.timezone = America\/New_York/' \
  -e 's/^output_buffering\s*=.*/output_buffering = Off/' \
  -e 's/^opcache\.enable\s*=.*/opcache.enable=1/' \
  -e 's/^opcache\.interned_strings_buffer\s*=.*/opcache.interned_strings_buffer=64/' \
  -e 's/^opcache\.max_accelerated_files\s*=.*/opcache.max_accelerated_files=100000/' \
  -e 's/^opcache\.memory_consumption\s*=.*/opcache.memory_consumption=256/' \
  -e 's/^opcache\.save_comments\s*=.*/opcache.save_comments=1/' \
  -e 's/^opcache\.revalidate_freq\s*=.*/opcache.revalidate_freq=1/' \
  -e 's/^opcache\.validate_timestamps\s*=.*/opcache.validate_timestamps=0/' \
  php-fpm/php.ini

echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> php-fpm/php-fpm.conf
touch ./logs/installed