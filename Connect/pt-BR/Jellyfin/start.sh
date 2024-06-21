#!/bin/bash
echo "⚙️  Versão do Script: 2.0"
if [[ -f "./jellyfin/jellyfin.dll" ]]; then
    echo "🟢  Iniciando Nginx..."
    nohup /usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/ 2>&1 &

    echo "✅ Iniciando Jellyfin"
    dotnet jellyfin/jellyfin.dll --ffmpeg /usr/lib/jellyfin-ffmpeg/ffmpeg
else
    echo "Jellyfin Não Instalado, isso é realmente muito estranho, essa é uma segunda verificação."
fi
