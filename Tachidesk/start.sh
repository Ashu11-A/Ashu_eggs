#!/bin/bash
bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Tachidesk/version.sh)

echo "👀  Saiba Mais: https://github.com/Suwayomi/Tachidesk-Server"
echo "✅  Iniciando Tachidesk..."
java -Dsuwayomi.tachidesk.config.server.rootDir="./Config/" -jar ./Tachidesk-Server.jar
