#!/bin/bash
bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")

echo "🟢  Iniciando Ass..."
(
    cd Ass || exit
    touch nohup.out
    # npm start
    nohup npm start 2>&1 &
)

if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="na porta ${SERVER_PORT}"
else
    MGM="em ${SERVER_IP}:${SERVER_PORT}"
fi
echo "🟢  Interface iniciando ${MGM}..."

while read -r line; do
    if [[ "$line" == "build" ]]; then
        echo "Executando: ${bold}${lightblue}${line}"
        (
            cd Ass || exit
            eval "npm run build"
        )
        printf "\n \n✅  Comando Executado\n \n"
    elif [[ "$line" != "build" ]]; then
        echo "Comando Inválido. O que você está tentando fazer? Tente ${bold}${lightblue}build."
    else
        echo "Script Falhou."
    fi
done
