#!/bin/ash

# Function to monitor the installation in the background.
monitor_installation () {
  while ! php ./nextcloud/occ status 2> /dev/null | grep -q "installed: true"; do
    sleep 5
  done

  while true; do
    echo "🔔 Nextcloud installed! Restart to optimize."
    sleep 10
  done
}

# Setup environment
mkdir -p logs tmp
touch logs/nextcloud.log

# Migration/Compatibility check
if [ -f "./logs/instalado" ]; then
  mv "./logs/instalado" "./logs/installed"
fi

# Initial Installation
if [ ! -f "./logs/installed" ]; then
    echo "⚙️ Starting Nextcloud Installation..."
    curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/update.sh | ash -s -- bootstrap "installer.sh" "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Nextcloud/installer.sh"
    echo "✅ Installation Finished."
    exit
fi

# Visual Header
{ figlet -c -f slant -t -k Nextcloud; echo "                                                    by Ashu11-A"; } | lolcat   

# Clear temporary directory.
rm -rf /home/container/tmp/*

# Handle OCC Commands
if [ "$OCC" = "1" ]; then  
    echo "🚀 Running OCC command: php ./nextcloud/occ ${COMMANDO_OCC}"
    php ./nextcloud/occ "${COMMANDO_OCC}"
    exit
fi

echo "⚙️ Script Version: 2.3"
echo "🔎 Scanning Nextcloud status..."

if php ./nextcloud/occ status | grep -q "installed: true"; then
    echo "✅ Applying cache & optimizations..."
    php ./nextcloud/occ config:system:set memcache.local --value='\OC\Memcache\APCu'
    php ./nextcloud/occ config:system:set memcache.distributed --value='\OC\Memcache\Memcached'
    php ./nextcloud/occ config:system:set memcache.locking --value='\OC\Memcache\Redis'
    php ./nextcloud/occ config:system:set memcached_servers --value='[["localhost", 11211]]' --type=json
    php ./nextcloud/occ config:system:set redis host --value='localhost'
    php ./nextcloud/occ config:system:set redis port --value='6379' --type=integer
    echo "📦 Setting chunk size to 10MB..."
    php ./nextcloud/occ config:system:set --type int --value 10485760 files.chunked_upload.max_size
else
    echo "⚠️ Not installed via web. Skipping config."
    monitor_installation &
fi

# Service Configuration Optimization
echo "🔧 Optimizing service configs for unified logging..."
if [ -f "/home/container/nginx/nginx.conf" ]; then
    sed -i 's#^\s*access_log\s*.*#access_log /dev/stdout;#' "/home/container/nginx/nginx.conf"
    sed -i 's#^\s*error_log\s*.*#error_log /dev/stderr;#' "/home/container/nginx/nginx.conf"
fi
if [ -f "/home/container/php-fpm/php-fpm.conf" ]; then
    sed -i 's#^;*daemonize\s*=\s*yes#daemonize = no#' "/home/container/php-fpm/php-fpm.conf"
    sed -i 's#^error_log\s*=\s*.*#error_log = /proc/self/fd/2#' "/home/container/php-fpm/php-fpm.conf"
fi
if [ -f "/home/container/php-fpm/fpm.pool.d/www.conf" ]; then
    sed -i 's#^;*catch_workers_output\s*=\s*.*#catch_workers_output = yes#' "/home/container/php-fpm/fpm.pool.d/www.conf"
fi

# Start unified log output
tail -f logs/nextcloud.log &

echo "🚀 Launching all services with Supervisord..."
curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Nextcloud/supervisord.conf -o supervisord.conf
exec supervisord -c ./supervisord.conf