#!/bin/bash

echo "⚙️  Versão do Script: 1.4"

if [[ -f "./Emby/EmbyServer.dll" ]]; then
    echo "✅  Iniciando Emby"
    dotnet Emby/EmbyServer.dll -ffmpeg /usr/bin/ffmpeg -ffprobe /usr/bin/ffprobe
else
    echo "Emby Não Instalado, isso é realmente muito estranho, essa é uma segunda verificação."
fi
