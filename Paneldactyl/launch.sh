#!/bin/bash
rm -rf /home/container/tmp/*
printf "\n \n
 ______                        _      _                             _ 
(_____ \                      | |    | |               _           | |
 _____) )  ____  ____    ____ | |  _ | |  ____   ____ | |_   _   _ | |
|  ____/  / _  ||  _ \  / _  )| | / || | / _  | / ___)|  _) | | | || |
| |      ( ( | || | | |( (/ / | |( (_| |( ( | |( (___ | |__ | |_| || |
|_|       \_||_||_| |_| \____)|_| \____| \_||_| \____) \___) \__  ||_|
                                                            (____/    
\n \n"
echo "⚙️ Versão do Script: 1.1"
echo "🛠 Iniciando PHP-FPM..."
/usr/sbin/php-fpm81 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize

echo "🛠 Iniciando Nginx..."
echo "✅ Inicializado com sucesso"
nohup /usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/ &
php /home/container/painel/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3
