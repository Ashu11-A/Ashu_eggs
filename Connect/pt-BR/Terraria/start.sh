#!/bin/bash

echo "⚙️  Versão do Script: 1.6"

mkdir -p logs
echo "pt" > logs/language.conf

# Self-update (redirect to 'all')
curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/update.sh | bash -s -- update "$0" "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Terraria/start.sh" "Atualizado com sucesso. Reiniciando..." "force" "$@"
