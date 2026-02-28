#!/bin/bash

export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Lang/paneldactyl.conf"
curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/lang.sh" -o /tmp/lang.sh
source /tmp/lang.sh

php_binary=$(command -v php || echo "/usr/bin/php")
nginx_binary=$(command -v nginx || echo "/usr/sbin/nginx")
php_fpm_binary=$(command -v php-fpm || command -v php-fpm83 || command -v php-fpm82 || command -v php-fpm81 || echo "/usr/sbin/php-fpm")

mkdir -p /home/container/tmp
echo "${starting_php}"
nohup "${php_fpm_binary}" --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize >/dev/null 2>&1 &

echo "${starting_nginx}"
nohup "${nginx_binary}" -c /home/container/nginx/nginx.conf -p /home/container/ >/dev/null 2>&1 &

server_address="${SERVER_IP:-0.0.0.0}:${SERVER_PORT}"
echo "${started_success} ${server_address}..."

echo "${starting_worker}"
nohup "${php_binary}" "/home/container/panel/artisan" queue:work --queue=high,standard,low --sleep=3 --tries=3 >/dev/null 2>&1 &

echo "${starting_cron}"
curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Paneldactyl/cron.sh" -o /home/container/.cron_runner.sh
nohup bash /home/container/.cron_runner.sh >/dev/null 2>&1 &

# 2. Interface de Comandos Interativa
echo "${avail_commands} ${help_details}"

while read -r user_input; do
  case "${user_input}" in
    "help")
      curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/fmt.sh" -o /tmp/fmt.sh
      # shellcheck source=/dev/null
      source /tmp/fmt.sh
      
      declare -a rows=(
        "composer|${cmd_composer}"
        "setup|${cmd_setup}"
        "database|${cmd_database}"
        "migrate|${cmd_migrate}"
        "user|${cmd_user}"
        "build|${cmd_build}"
        "reinstall|${cmd_reinstall_options}"
      )
      print_dynamic_table "${command_column}" "${description_column}" "${rows[@]}"
      ;;

    "composer")
      ( cd "panel" && composer install --no-dev --optimize-autoloader )
      ;;

    "setup")
      ( cd "panel" && "${php_binary}" artisan p:environment:setup )
      ;;

    "database")
      ( cd "panel" && "${php_binary}" artisan p:environment:database )
      ;;

    "migrate")
      ( cd "panel" && "${php_binary}" artisan migrate --seed --force )
      ;;

    "user")
      ( cd "panel" && "${php_binary}" artisan p:user:make )
      ;;

    "build")
      echo "${ram_warning}"
      ( cd "panel" && yarn && yarn build )
      ;;

    "reinstall all")
      echo "${confirm_reinstall} (y/n)"
      read -r confirm
      if [[ "${confirm}" == "y" ]]; then
        rm -rf "panel" logs/panel* nginx php-fpm
        exit 0
      fi
      ;;

    "exit")
      exit 0
      ;;

    *)
      # Tenta executar como comando PHP se começar com php
      if [[ "${user_input}" == php* ]]; then
        cmd_to_run="${user_input/php/${php_binary}}"
        ( cd "panel" && eval "${cmd_to_run}" )
      else
        echo "${invalid_command}"
      fi
      ;;
  esac
done
