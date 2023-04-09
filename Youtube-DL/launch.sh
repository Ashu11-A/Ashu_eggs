#!/bin/bash
rm -rf /home/container/tmp/*
echo "⚙️ Versão do Script: 1.0"
echo "🛠 Iniciando PHP-FPM..."
/usr/sbin/php-fpm81 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize

echo "🛠 Iniciando Nginx..."
echo "✅ Inicializado com sucesso"
/usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/
