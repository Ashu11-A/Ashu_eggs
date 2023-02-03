#!/bin/bash
rm -rf /home/container/tmp/*
printf "
 ______                        _      _                             _ 
(_____ \                      | |    | |               _           | |
 _____) )  ____  ____    ____ | |  _ | |  ____   ____ | |_   _   _ | |
|  ____/  / _  ||  _ \  / _  )| | / || | / _  | / ___)|  _) | | | || |
| |      ( ( | || | | |( (/ / | |( (_| |( ( | |( (___ | |__ | |_| || |
|_|       \_||_||_| |_| \____)|_| \____| \_||_| \____) \___) \__  ||_|
                                                            (____/    
\n \n"
echo "⚙️  Versão do Script: 1.2"
echo "🟢  Iniciando PHP-FPM..."
/usr/sbin/php-fpm81 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize

echo "🟢  Iniciando Nginx..."
nohup /usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/ >/dev/null 2>&1 &
echo "🟢  Iniciando worker do painel"
nohup php /home/container/painel/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3 >/dev/null 2>&1 &
echo "🟢  Iniciando cron"
nohup bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Paneldactyl/cron.sh) >/dev/null 2>&1 &
if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="na porta ${SERVER_PORT}"
else
    MGM="em ${SERVER_IP}:${SERVER_PORT}"
fi
echo "🟢  Inicializado com sucesso ${MGM}"
