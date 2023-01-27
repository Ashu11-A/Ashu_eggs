#!/bin/bash
if [[ -f "./tModLoader.dll" ]]; then
    echo "⚙️ Versão do Script: 1.3"
    echo "✅ Iniciando tModLoader"
    dotnet tModLoader.dll -server "$@" -config serverconfig.txt
else
    echo "tModLoader Não Instalado, isso é realmente muito estranho, essa é uma segunda verificação."
fi