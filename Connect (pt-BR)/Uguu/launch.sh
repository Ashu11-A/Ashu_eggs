#!/bin/bash
bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Uguu/version.sh)

echo "🟢  Instalando frontend..."
if [ ! -d "Uguu/dist/public" ]; then
    (
        cd Uguu || exit
        npm install
        make
        make install
    )
fi

echo "🟢  Iniciando Postgres (Database)..."
nohup postgres -D /home/container/DB/ >/dev/null 2>&1 &

echo "🟢  Iniciando PHP-FPM..."
nohup /usr/sbin/php-fpm81 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize >/dev/null 2>&1 &

echo "🟢  Iniciando Nginx..."
echo "✅  Inicializado com sucesso"
nohup /usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/ 2>&1 &

echo "📃  Comandos Disponíveis: ${bold}${lightblue}yt-dlp ${normal}[your code]..."

while read -r line; do
    if [[ "$line" == *"yt-dlp"* ]]; then
        echo "Executando: ${bold}${lightblue}${line}"
        (
            cd "[your files]" || exit
            eval "$line"
        )
        printf "\n \n✅  Comando Executado\n \n"
    elif [[ "$line" != *"yt-dlp"* ]]; then
        echo "Comando Inválido. O que você está tentando fazer? Tente algo com ${bold}${lightblue}yt-dlp."
    else
        echo "Script Falhou."
    fi
done
