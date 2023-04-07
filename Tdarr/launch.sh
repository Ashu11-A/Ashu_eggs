#!/bin/bash
rm -rf /home/container/tmp/*
figlet -c -f ./Fonts/3d.flf "Tdarr" | lolcat

echo "🟢  Iniciando Tdarr_Server..."
nohup ./Tdarr_Server/Tdarr_Server >/dev/null 2>&1 &

echo "🟢  Iniciando Tdarr_Node..."
nohup ./Tdarr_Node/Tdarr_Node >/dev/null 2>&1 &
if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="na porta ${SERVER_PORT}"
else
    MGM="em ${SERVER_IP}:${SERVER_PORT}"
fi
echo "🟢  Inicializado com sucesso ${MGM}..."
