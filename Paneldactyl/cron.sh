#!/bin/bash
while :
do
  php /home/container/painel/artisan schedule:run >> /dev/null 2>&1 && /bin/bash /crontab_test.sh
  sleep 60
done
if [ "${PANEL}" = "Jexactyl" ] || [ "${PANEL}" = "Jexactyl Brasil" ]; then
    HORA_CERTA='1200'

    while :
    do
    HORA=$(date +%H%M) # captura a hora
    [ "$HORA" == "$HORA_CERTA" ] && executa_script.sh && break# executa o script desejado
    sleep 60 # espera um minuto pra tentar verificar novamente
    done
fi
 