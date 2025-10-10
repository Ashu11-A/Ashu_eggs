#!/bin/ash

if [ ! -d logs ]; then
  mkdir -p logs
fi
if [ ! -d tmp ]; then
  mkdir -p tmp
fi
if [[ -f "./logs/instalado" ]]; then
  touch ./logs/installed
fi

if [[ ! -f "./logs/installed" ]]; then
  curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Nextcloud/installer.sh -o installer.sh;
  chmod a+x ./installer.sh
  ./installer.sh
  rm ./installer.sh
  exit
fi

# Limpa diretório temporário.
rm -rf /home/container/tmp/*

# Permite executar comandos OCC diretamente.
if [[ $OCC == "1" ]]; then 
  php ./nextcloud/occ ${COMMANDO_OCC}
  exit
else
  echo "⚙️ Script Version: 2.1"

  echo "📤 Configuring upload limits (16GB)"
  cat > ./nextcloud/.user.ini << EOL
always_populate_raw_post_data=-1
default_charset='UTF-8'
output_buffering=0

php_value upload_max_filesize 16G
php_value post_max_size 16G
php_value max_input_time 3600
php_value max_execution_time 3600
EOL

  echo "🔎 Checking the installation status of Nextcloud..."
  if php ./nextcloud/occ status | grep -q "installed: true"; then
    echo "✅ Nextcloud is installed. Applying cache settings..."
    php ./nextcloud/occ config:system:set memcache.local --value='\OC\Memcache\APCu'
    php ./nextcloud/occ config:system:set memcache.distributed --value='\OC\Memcache\Memcached'
    php ./nextcloud/occ config:system:set memcache.locking --value='\OC\Memcache\Redis'
    php ./nextcloud/occ config:system:set memcached_servers --value='[["localhost", 11211]]' --type=json
    php ./nextcloud/occ config:system:set redis host --value='localhost'
    php ./nextcloud/occ config:system:set redis port --value='6379' --type=integer
  else
    echo "⚠️ Nextcloud has not yet been installed via the web interface. Skipping cache configuration."
    echo "   Please complete the installation in your browser and then restart the container so that the cache is configured."
  fi

  echo "✨ Starting Redis Server..."
  redis-server --daemonize yes

  echo "✨ Starting Memcached..."
  memcached -d -u nobody

  echo "✨ Starting PHP-FPM..."
  /usr/sbin/php-fpm --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize

  echo "✨ Starting Nginx..."
  /usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/
fi