#!/bin/bash
rm -rf /home/container/tmp/*
echo "⚙️ Versão do Script: 1.0"
echo "🛠 Instalando frontend..."
(
    cd youtube-dl-web/frontend || exit
    if [ ! -d "./build" ]; then
        yarn install
        yarn build
    fi
)
echo "🛠 Instalando server..."
(
    cd youtube-dl-web/server || exit
    pip3  --disable-pip-version-check --no-cache-dir install -r requirements.txt
    pip3 install -U yt-dlp
    (
        cd src || exit
        nohup python -m uvicorn server:app --host 0.0.0.0 --port 4000 --no-server-header --workers 8 2>&1 &
    )
)
echo "🛠 Iniciando PHP-FPM..."
/usr/sbin/php-fpm81 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize

echo "🛠 Iniciando Nginx..."
echo "✅ Inicializado com sucesso"
/usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/
