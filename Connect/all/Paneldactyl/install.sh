#!/bin/bash

export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Lang/paneldactyl.conf"
curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/loadLang.sh" -o /tmp/loadLang.sh
source /tmp/loadLang.sh

curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/fmt.sh" -o /tmp/fmt.sh
source /tmp/fmt.sh

curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Paneldactyl/download.sh" -o /tmp/download.sh
source /tmp/download.sh

# 3. Configuração do Artisan
if [[ "${OCC}" == "1" ]]; then
  ( cd "panel" && php "${COMMANDO_OCC}" )
  exit 0
fi

# Loop de passos do Artisan
(
  cd "panel" || exit 1
  
  if [[ ! -f ".env" ]] && [[ -f "../backups/executado" ]]; then
    last_env_backup=$(ls ../backups/.env* -t 2>/dev/null | head -1)
    [[ -n "${last_env_backup}" ]] && cp "${last_env_backup}" ".env"
  fi
  [[ ! -f ".env" ]] && cp .env.example .env

  [[ ! -f "../logs/panel_composer_installed" ]] && composer install --no-interaction --no-dev --optimize-autoloader && touch ../logs/panel_composer_installed
  [[ ! -f "../logs/panel_key_generate_installed" ]] && php artisan key:generate --force && touch ../logs/panel_key_generate_installed
  [[ ! -f "../logs/panel_setup_installed" ]] && php artisan p:environment:setup && touch ../logs/panel_setup_installed
  [[ ! -f "../logs/panel_database_installed" ]] && php artisan p:environment:database && touch ../logs/panel_database_installed
  [[ ! -f "../logs/panel_database_migrate_installed" ]] && php artisan migrate --seed --force && touch ../logs/panel_database_migrate_installed
  [[ ! -f "../logs/panel_user_installed" ]] && php artisan p:user:make && touch ../logs/panel_user_installed
)

touch ./logs/panel_installed
print_status_footer

# Limpeza e finalização
rm -rf .composer .yarn .cache .yarnrc
echo -e "\n \n${setup_completed}\n \n"

# Inicia o Launcher
curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Paneldactyl/launch.sh" -o launch.sh
chmod +x launch.sh
./launch.sh
