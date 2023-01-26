#!/bin/bash
if [[ -f "./Emby/EmbyServer.dll" ]]; then
    echo "⚙️ Versão do Script: 1.3"
    echo "✅ Iniciando Emby"
    dotnet Emby/EmbyServer.dll -ffmpeg /usr/bin/ffmpeg -ffprobe /usr/bin/ffprobe
else
    echo "Painel Não Instalado, isso é realmente muito estranho, essa é uma segunda verificação."
fi