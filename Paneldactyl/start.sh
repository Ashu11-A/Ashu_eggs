#!/bin/bash
rm -rf /home/container/tmp/*
echo "
__________                         .__       .___                  __           .__   
\______   \_____     ____    ____  |  |    __| _/_____     ____  _/  |_  ___.__.|  |  
 |     ___/\__  \   /    \ _/ __ \ |  |   / __ | \__  \  _/ ___\ \   __\<   |  ||  |  
 |    |     / __ \_|   |  \\  ___/ |  |__/ /_/ |  / __ \_\  \___  |  |   \___  ||  |__
 |____|    (____  /|___|  / \___  >|____/\____ | (____  / \___  > |__|   / ____||____/
                \/      \/      \/            \/      \/      \/         \/           
"
echo "⚙️ Versão do Script: 1.1"
echo "🛠 Iniciando PHP-FPM..."
/usr/sbin/php-fpm81 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize

echo "🛠 Iniciando Nginx..."
echo "✅ Inicializado com sucesso"
nohup /usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/ &
php /home/container/painel/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3
