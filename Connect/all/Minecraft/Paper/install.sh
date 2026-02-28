#!/bin/bash

curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Minecraft/Paper/download.sh" -o /tmp/download.sh
source /tmp/download.sh

cat <<EOF >logs/run.log
${version}: ${CLEAN_VERSION}
${link}: ${DOWNLOAD_LINK:-}
${file}: ${FILE_NAME:-}
EOF

if [ -f "${SERVER_JARFILE}" ]; then
    printf "%s\n" "$backup_existing"
    mv "${SERVER_JARFILE}" "${SERVER_JARFILE}.old"
fi

printf "%s\n" "$running_download"
curl -sSL -o "${SERVER_JARFILE}" "${DOWNLOAD_LINK}"

# Configuração Inicial e Otimizações
if [ ! -f server.properties ]; then
    printf "%s\n" "$downloading_config"
    
    curl -sSL -o server.properties https://raw.githubusercontent.com/parkervcp/eggs/master/minecraft/java/server.properties
    curl -sSL -o spigot.yml https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Minecraft/Paper/config/spigot.yml
    curl -sSL -o bukkit.yml https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Minecraft/Paper/config/bukkit.yml
    
    mkdir -p config
    curl -sSL -o config/paper-world-defaults.yml https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Minecraft/Paper/config/paper-world-defaults.yml
fi

chmod +x "${SERVER_JARFILE}"
printf "%s\n" "$installation_complete"
