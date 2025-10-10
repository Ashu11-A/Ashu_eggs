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
# mais alteracões para forçar
# atualizar o cache do github

if [[ ! -f "./logs/installed" ]]; then
  curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Nextcloud/installer.sh -o installer.sh;
  chmod a+x ./installer.sh
  ./installer.sh
  rm ./installer.sh
  exit
fi

rm -rf /home/container/tmp/*

if [[ $OCC == "1" ]]; then 
  php ./nextcloud/occ ${COMMANDO_OCC}
  exit
else
  echo "⚙️ Script Version: 2.0"
  echo "🛠 Starting PHP-FPM..."
  /usr/sbin/php-fpm --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize

  echo "🛠 Starting Nginx..."
  /usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/
fi