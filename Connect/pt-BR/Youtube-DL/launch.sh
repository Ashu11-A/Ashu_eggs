#!/bin/bash
export PATH=$PATH:/home/container/.local/bin
bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
normal=$(echo -en "\e[0m")

bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/Youtube-DL/version.sh)

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
    pip3  --disable-pip-version-check --no-cache-dir install -r requirements.txt >/dev/null
    pip3 install -U yt-dlp >/dev/null
    (
        cd src || exit
        nohup python -m uvicorn server:app --host 0.0.0.0 --port 4000 --no-server-header --workers 8 >/dev/null 2>&1 &
    )
)

echo "🛠 Iniciando Nginx..."
echo "✅ Inicializado com sucesso"
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
