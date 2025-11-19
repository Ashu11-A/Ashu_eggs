#!/bin/bash

# Detecta pasta
if [ -d "/home/container/painel" ]; then PANEL_DIR="painel"; else PANEL_DIR="panel"; fi

while true
do
  HORA_CERTA='0000'
  HORA=$(date +%H%M)

  if [ "${PANEL}" = "Jexactyl" ] || [ "${PANEL}" = "Jexactyl Brasil" ]; then
     if [ "$HORA" == "$HORA_CERTA" ]; then
       php /home/container/$PANEL_DIR/artisan p:schedule:renewal >> /dev/null 2>&1
     fi
  fi

    if [ "$HORA" == "$HORA_CERTA" ]; then
      cp $PANEL_DIR/.env backups/.env-$(date +%F-%Hh%Mm)
      find ./backups/ -mindepth 1 -not -name "executado" -not -name "executed" -mtime +7 -delete
    fi

  php /home/container/$PANEL_DIR/artisan schedule:run >> /dev/null 2>&1 && /bin/bash /crontab_test.sh

  sleep 60
done