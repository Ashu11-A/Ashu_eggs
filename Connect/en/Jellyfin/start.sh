#!/bin/bash
echo "⚙️ Script Version: 2.2"
if [[ -f "./jellyfin/jellyfin.dll" ]]; then
	echo "🔏  Setting file permissions"
	chmod 777 -R ./*
    echo "🟢  Starting Nginx..."
    nohup /usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/ 2>&1 &

    echo "✅  Starting Jellyfin"
    dotnet jellyfin/jellyfin.dll --ffmpeg /usr/lib/jellyfin-ffmpeg/ffmpeg
else
    echo "Jellyfin Not Installed, this is really odd, this is a second verification."
fi
