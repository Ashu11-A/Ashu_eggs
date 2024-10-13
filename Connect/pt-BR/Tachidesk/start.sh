#!/bin/bash

if [ -d "Logs" ]; then
    mv Logs logs
fi

bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/Tachidesk/version.sh)

echo "👀  Saiba Mais: https://github.com/Suwayomi/Tachidesk-Server"
echo "✅  Iniciando Tachidesk..."
java -Dsuwayomi.tachidesk.config.server.rootDir="./Config/" -jar ./Tachidesk-Server.jar
