#!/bin/ash

# Function to monitor the installation in the background.
monitor_installation() {
  # Wait until Nextcloud is marked as "installed".
  while ! php ./nextcloud/occ status 2> /dev/null | grep -q "installed: true"; do
    sleep 5
  done

  # Once installed, enter an infinite loop to notify the user.
  while true; do
    echo "🔔 Nextcloud has been installed! Please restart the server to apply pending cache settings and optimizations."
    sleep 5
  done
}

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

(figlet -c -f slant -t -k Nextcloud; echo "                                                    by Ashu11-A") | lolcat

# Clear temporary directory.
rm -rf /home/container/tmp/*

# Allow running OCC commands directly.
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
    echo "✅ Nextcloud is installed. Applying cache and upload settings..."
    php ./nextcloud/occ config:system:set memcache.local --value='\OC\Memcache\APCu'
    php ./nextcloud/occ config:system:set memcache.distributed --value='\OC\Memcache\Memcached'
    php ./nextcloud/occ config:system:set memcache.locking --value='\OC\Memcache\Redis'
    php ./nextcloud/occ config:system:set memcached_servers --value='[["localhost", 11211]]' --type=json
    php ./nextcloud/occ config:system:set redis host --value='localhost'
    php ./nextcloud/occ config:system:set redis port --value='6379' --type=integer

    echo "📦 Adjusting upload chunk size to 10MB..."
    php ./nextcloud/occ config:system:set --type int --value 10485760 files.chunked_upload.max_size

  else
    echo "⚠️ Nextcloud has not yet been installed via the web interface. Skipping configurations."
    echo "   Please complete the installation in your browser."
    # Start the monitor in the background to notify when the installation is complete
    monitor_installation &
  fi


  curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Nextcloud/supervisord.conf -o supervisord.conf
  curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Nextcloud/supervisor.sh -o supervisor.sh
  chmod a+x ./supervisor.sh
  ./supervisor.sh

  echo "🚀 Starting all services with supervisord..."
  supervisord -c ./supervisord.conf
fi