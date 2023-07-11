#!/bin/bash
echo "⚙️ Script Version: 1.2"
if [[ -f "./jellyfin/jellyfin.dll" ]]; then
    echo "✅ Starting Jellyfin"
    dotnet jellyfin/jellyfin.dll --ffmpeg /usr/lib/jellyfin-ffmpeg/ffmpeg
else
    echo "Panel Not Installed, this is really odd, this is a second verification."
fi
