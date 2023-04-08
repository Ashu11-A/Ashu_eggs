#!/bin/bash
echo "🟢  Iniciando servidor..."
nohup npm run serve 2>&1 &
if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="na porta ${SERVER_PORT}"
else
    MGM="em ${SERVER_IP}:${SERVER_PORT}"
fi
echo "🟢  Interface auxiliar inicializada com sucesso ${MGM}..."

while read -r line; do
    if [[ "$line" == "ffmpeg" ]]; then

        Comando1="${composer_start}"
        echo "Instalando pacotes do Composer: ${bold}${lightblue}${Comando1}"
        eval "cd /home/container/painel && $Comando1 && cd .."
        printf "\n \n✅  Comando Executado\n \n"

    elif [ "$line" != "${composer}" ] || [ "$line" != "${setup}" ] || [ "$line" != "${database}" ] || [ "$line" != "${migrate}" ] || [ "$line" != "${user_make}" ] || [ "$line" != "${yarn}" ]; then
        echo "Comando Invalido, oque vocẽ está tentando fazer? tente ${bold}${lightblue}help"
    else
        echo "Script Falhou."
    fi
done
