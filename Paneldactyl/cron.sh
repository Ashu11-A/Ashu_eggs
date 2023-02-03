#!/bin/bash
while :
do
  if [ "${PANEL}" = "Jexactyl" ] || [ "${PANEL}" = "Jexactyl Brasil" ]; then
    HORA_CERTA='0000'
    HORA=$(date +%H%M) # captura a hora
    [ "$HORA" == "$HORA_CERTA" ] && php /var/www/jexactyl/artisan p:schedule:renewal >> /dev/null 2>&1 # executa o script desejado
  fi
  
  php /home/container/painel/artisan schedule:run >> /dev/null 2>&1 && /bin/bash /crontab_test.sh
  sleep 60
done