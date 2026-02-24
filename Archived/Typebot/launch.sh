#!/bin/bash
rm -rf /home/container/tmp/*

# echo "🟢  Iniciando PHP-FPM..."
# nohup /usr/sbin/php-fpm8.1 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize >/dev/null 2>&1 &

# echo "🟢  Iniciando Nginx..."
# nohup /usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/ >/dev/null 2>&1 &
if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="na porta ${SERVER_PORT}"
else
    MGM="em ${SERVER_IP}:${SERVER_PORT}"
fi
echo "🟢  Inicializado com sucesso ${MGM}..."
(
    cd apps/builder || exit
    pnpm start
    pnpm start -p "${SERVER_PORT}"
)
