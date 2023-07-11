#!/bin/bash

echo "⚙️ Script Version: 1.4"

if [[ -f "./Emby/EmbyServer.dll" ]]; then
    echo "✅ Starting Emby"
    dotnet Emby/EmbyServer.dll -ffmpeg /usr/bin/ffmpeg -ffprobe /usr/bin/ffprobe
else
    echo "Emby Not Installed, this is really strange, this is a second verification."
fi
