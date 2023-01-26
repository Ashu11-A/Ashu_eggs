#!/bin/bash
if [[ -f "./jellyfin/jellyfin.dll" ]]; then
    echo "⊝ Versão do Script: 1.0"
    echo "✓ Iniciando Jellyfin"
    dotnet jellyfin/jellyfin.dll --ffmpeg /usr/lib/jellyfin-ffmpeg/ffmpeg
else
    echo "Painel Não Instalado, isso é realmente muito estranho, essa é uma segunda verificação."
fi