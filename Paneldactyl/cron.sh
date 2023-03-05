#!/bin/bash

while true
do

  if [ "${PANEL}" = "Jexactyl" ] || [ "${PANEL}" = "Jexactyl Brasil" ]; then
    HORA_CERTA='0000'
    HORA=$(date +%H%M) # captura a hora
    [ "$HORA" == "$HORA_CERTA" ] && php /home/container/painel/artisan p:schedule:renewal >> /dev/null 2>&1
  fi

  if [ "${PANEL}" = "Jexactyl" ] || [ "${PANEL}" = "Jexactyl Brasil" ] || [ "${PANEL}" = "Pterodactyl" ]; then
    HORA_CERTA='0000'
    HORA=$(date +%H%M) # captura a hora
    [ "$HORA" == "$HORA_CERTA" ] && find ./backups/ -mindepth 1 -not -name "executado" -mtime +7 -delete # executa o script desejado
  fi

  php /home/container/painel/artisan schedule:run >> /dev/null 2>&1 && /bin/bash /crontab_test.sh

  sleep 60
done
