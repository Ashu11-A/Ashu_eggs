#!/bin/bash

if [ -d "Logs" ]; then
    mv Logs logs
fi

bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/Tachidesk/version.sh)

echo "👀  More info: https://github.com/Suwayomi/Tachidesk-Server"
echo "✅  Starting Tachidesk..."
java -Dsuwayomi.tachidesk.config.server.rootDir="./Config/" -jar ./Tachidesk-Server.jar
