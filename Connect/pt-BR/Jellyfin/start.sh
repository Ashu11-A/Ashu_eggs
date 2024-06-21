#!/bin/bash
echo "⚙️  Versão do Script: 2.0"
if [[ -f "./jellyfin/jellyfin.dll" ]]; then
    echo "✅ Iniciando Jellyfin"
    dotnet jellyfin/jellyfin.dll --ffmpeg /usr/lib/jellyfin-ffmpeg/ffmpeg
else
    echo "Painel Não Instalado, isso é realmente muito estranho, essa é uma segunda verificação."
fi
