#!/bin/bash

BASE_DIR="/mnt/server"
[[ -d "/home/container" ]] && BASE_DIR="/home/container"

cd "$BASE_DIR" || exit 1
mkdir -p php-fpm logs

echo "⚙️ Setting up environment..."

# Determine download link
if [[ "${NEXTCLOUD_RELEASE}" == "latest" ]] ; then
  DOWNLOAD_LINK="latest.zip"
else
  DOWNLOAD_LINK="nextcloud-${NEXTCLOUD_RELEASE}.zip"
fi

# Clone Nginx/PHP configs
echo "🔎 Downloading Nginx/PHP configs..."
git clone --quiet https://github.com/finnie2006/ptero-nginx ./temp
cp -r ./temp/nginx "$BASE_DIR"/
cp -r ./temp/php-fpm "$BASE_DIR"/
rm -rf ./temp
rm -rf "$BASE_DIR"/webroot/*

# Custom Nginx config
echo "🔧 Applying custom Nginx config..."
(
  cd nginx/conf.d/ || exit
  rm -f default.conf nextcloud.conf
  wget -q https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Nextcloud/default.conf
)

# Log installation info
cat <<EOF > ./logs/install_log.txt
Version: $NEXTCLOUD_RELEASE
Link: https://download.nextcloud.com/server/releases/${DOWNLOAD_LINK}
File: ${DOWNLOAD_LINK}
EOF

# Download and Extract Nextcloud
echo "📦 Fetching Nextcloud ${NEXTCLOUD_RELEASE}..."
wget -q --show-progress https://download.nextcloud.com/server/releases/${DOWNLOAD_LINK}
echo "📦 Unpacking files..."
unzip -q -o "${DOWNLOAD_LINK}"
rm -f "${DOWNLOAD_LINK}"

# Post-install configurations
echo "🔧 Configuring PHP modules..."
echo "extension=\"smbclient.so\"" > php-fpm/conf.d/00_smbclient.ini
echo 'apc.enable_cli=1' >> php-fpm/conf.d/apcu.ini

echo "🔧 Adjusting permissions..."
# chown -R nginx:nginx nextcloud 2>/dev/null || true
chmod -R 755 nextcloud

echo "🧹 Removing temporary files..."
rm -rf /tmp/*
echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> php-fpm/php-fpm.conf

touch ./logs/installed
echo "✅ Installation script finished."