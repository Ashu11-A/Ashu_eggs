#!/bin/bash
bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")

echo "🟢  Iniciando servidor..."
(
    cd ffmpeg-commander || exit
    touch nohup.out
    nohup npm run serve 2>&1 &
)

if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="na porta ${SERVER_PORT}"
else
    MGM="em ${SERVER_IP}:${SERVER_PORT}"
fi
echo "🟢  Interface auxiliar iniciando ${MGM}..."
echo "🔎  A interface é apenas para você copiar o comando que ele ira gerar a partir das suas configurações, coloque seus arquivos de video na pasta Media, e após isso cole o comando aqui de um simples [ENTER]."

while read -r line; do
    if [[ "$line" == *"ffmpeg"* ]]; then
        echo "Executando: ${bold}${lightblue}${line}"
        eval "cd Media && $line"
        printf "\n \n✅  Comando Executado\n \n"
    elif [[ "$line" != *"ffmpeg"* ]]; then
        echo "Comando Inválido. O que você está tentando fazer? Tente algo com ${bold}${lightblue}ffmpeg."
    else
        echo "Script Falhou."
    fi
done
