#!/bin/ash

if [ -d "Logs" ]; then
    mv Logs logs
fi

rm -rf /home/container/tmp/*
echo "⚙️ Versão do Script: 1.9"
echo "🛠 Iniciando PHP-FPM..."
/usr/sbin/php-fpm --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize

echo "🛠 Iniciando Nginx..."
echo "✅ Inicializado com sucesso"
/usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/
