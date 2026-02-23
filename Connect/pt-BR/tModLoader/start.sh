#!/bin/bash

echo "⚙️  Versão do Script: 1.6"

# Self-update
curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/update.sh | bash -s -- update "$0" "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/tModLoader/start.sh" "Atualizado com sucesso. Reiniciando..." "diff" "$@"

echo "✅ Iniciando tModLoader"
dotnet tModLoader.dll -server "$@" -config serverconfig.txt
