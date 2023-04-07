#!/bin/bash
# Define o nome do arquivo temporário
temp_file=$(mktemp)

# Executa o comando figlet e salva a saída no arquivo temporário
figlet -c -f ./Fonts/3d.flf "Tdarr" > "$temp_file"

# Executa o comando lolcat usando o arquivo temporário como entrada
lolcat "$temp_file"

# Remove o arquivo temporário
rm "$temp_file"

echo "🟢  Iniciando Tdarr_Updater..."
nohup ./Tdarr_Updater >/dev/null 2>&1 &

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
