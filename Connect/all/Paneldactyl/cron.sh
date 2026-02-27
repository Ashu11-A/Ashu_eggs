#!/bin/bash

while true; do
  current_time=$(date +%H%M)
  target_time="0000"

  # Rotinas da Meia-Noite
  if [[ "${current_time}" == "${target_time}" ]]; then
    # Renovação de Jexactyl
    if [[ "${PANEL}" == "Jexactyl" ]] || [[ "${PANEL}" == "Jexactyl Brasil" ]]; then
      php "/home/container/panel/artisan" p:schedule:renewal >/dev/null 2>&1
    fi

    # Backup diário do .env
    mkdir -p backups
    cp "panel/.env" "backups/.env-$(date +%F-%Hh%Mm)"
    find ./backups/ -mindepth 1 -not -name "executado" -not -name "executed" -mtime +7 -delete
  fi

  # Executa o agendador do Laravel a cada minuto
  php "/home/container/panel/artisan" schedule:run >/dev/null 2>&1

  sleep 60
done
