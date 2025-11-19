#!/bin/bash

lolcat=/usr/games/lolcat
bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
normal=$(echo -en "\e[0m")
rm -rf /home/container/tmp/*

# Carrega tradução manualmente
export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Lang/paneldactyl.conf"
curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/loadLang.sh" -o /tmp/loadLang.sh
source /tmp/loadLang.sh
rm -f /tmp/loadLang.sh

# Detecta pasta
if [ -d "/home/container/painel" ]; then PANEL_DIR="painel"; else PANEL_DIR="panel"; fi

composer_start="composer install --no-dev --optimize-autoloader"
setup_start="php artisan p:environment:setup"
database_start="php artisan p:environment:database"
migrate_start="php artisan migrate --seed --force"
user_make="user"
user_start="php artisan p:user:make"
yarn="build"
yarn_start="yarn && yarn lint --fix && yarn build && php artisan migrate && php artisan view:clear && php artisan cache:clear && php artisan route:clear"

reinstall_a="reinstall all"
reinstall_a_start="rm -rf $PANEL_DIR && rm -rf logs/panel* && rm -rf nginx && rm -rf php-fpm"
reinstall_p="reinstall painel"
reinstall_p_start="rm -rf $PANEL_DIR && rm -rf logs/panel*"
reinstall_n="reinstall nginx"
reinstall_n_start="rm -rf nginx"
reinstall_f="reinstall php-fpm"
reinstall_f_start="rm -rf php-fpm"

echo -e "\n \n$(figlet -c -f slant -t -k "Paneldactyl")\n                                         by Ashu" | $lolcat

echo "$starting_php"
nohup /usr/sbin/php-fpm --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize >/dev/null 2>&1 &

echo "$starting_nginx"
nohup /usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/ >/dev/null 2>&1 &

if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="0.0.0.0:${SERVER_PORT}"
else
    MGM="${SERVER_IP}:${SERVER_PORT}"
fi
echo "$started_success ${MGM}..."

echo "$starting_worker"
nohup php /home/container/$PANEL_DIR/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3 >/dev/null 2>&1 &

echo "$starting_cron"
# Baixa o cron para um arquivo persistente oculto e executa
curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Paneldactyl/cron.sh -o /home/container/.cron_runner.sh
nohup bash /home/container/.cron_runner.sh >/dev/null 2>&1 &

echo "$avail_commands ${bold}${lightblue}composer${normal}, ${bold}${lightblue}setup${normal}, ${bold}${lightblue}database${normal}, ${bold}${lightblue}migrate${normal}, ${bold}${lightblue}user${normal}, ${bold}${lightblue}build${normal}, ${bold}${lightblue}reinstall${normal}. Use ${bold}${lightblue}help${normal}..."

while read -r line; do
    if [[ "$line" == "help" ]]; then
        echo "$avail_commands"
        echo "
+-----------+---------------------------------------+
| $cmd_desc_header                          |
+-----------+---------------------------------------+
| composer  | $cmd_composer             |
| setup     | $cmd_setup     |
| database  | $cmd_database                |
| migrate   | $cmd_migrate                  |
| user      | $cmd_user                         |
| build     | $cmd_build             |
| reinstall | $cmd_reinstall     |
| nodejs    | $cmd_nodejs       |
+-----------+---------------------------------------+
"
    elif [[ "$line" == "nodejs" ]]; then
        curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/nvmSelect.sh" -o /tmp/nvmSelect.sh
        bash /tmp/nvmSelect.sh
        rm -f /tmp/nvmSelect.sh
        printf "\n \n$cmd_executed\n \n"
    elif [[ "$line" == "composer" ]]; then
        Command1="${composer_start}"
        echo "Composer: ${bold}${lightblue}${Command1}"
        eval "cd /home/container/$PANEL_DIR && $Command1 && cd .."
        printf "\n \n$cmd_executed\n \n"
    elif [[ "$line" == "setup" ]]; then
        Command2="${setup_start}"
        echo "Setup: ${bold}${lightblue}${Command2}"
        eval "cd /home/container/$PANEL_DIR && $Command2 && cd .."
        printf "\n \n$cmd_executed\n \n"
    elif [[ "$line" == "database" ]]; then
        Command3="${database_start}"
        echo "Database: ${bold}${lightblue}${Command3}"
        eval "cd /home/container/$PANEL_DIR && $Command3 && cd .."
        printf "\n \n$cmd_executed\n \n"
    elif [[ "$line" == "migrate" ]]; then
        Command4="${migrate_start}"
        echo "Migrate: ${bold}${lightblue}${Command4}"
        eval "cd /home/container/$PANEL_DIR && $Command4 && cd .."
        printf "\n \n$cmd_executed\n \n"
    elif [[ "$line" == "${user_make}" ]]; then
        Command5="${user_start}"
        echo "User: ${bold}${lightblue}${Command5}"
        eval "cd /home/container/$PANEL_DIR && $Command5 && cd .."
        printf "\n \n$cmd_executed\n \n"
    elif [[ "$line" == "${yarn}" ]]; then
        Command6="${yarn_start}"
        echo "Build: ${bold}${lightblue}${Command6}"
        echo -e "\n \n$ram_warning"
        echo -e "$ram_available ${bold}${lightblue}${SERVER_MEMORY} MB\n \n"
        eval "cd /home/container/$PANEL_DIR && $Command6 && cd .."
        printf "\n \n$cmd_executed\n \n"
    elif [[ "$line" == "reinstall" ]]; then
        echo -e "$reinstall_options"
    elif [[ "$line" == "${reinstall_a}" ]]; then
        echo "$reinstalling (All)..."
        printf "\n \n$confirm_reinstall\n \n"
        read -r response
        case "$response" in
        [yY][eE][sS] | [yY])
            ${reinstall_a_start}
            printf "\n \n$cmd_executed\n \n"
            exit
            ;;
        *)
            printf "\n \n$cmd_not_executed\n \n"
            ;;
        esac
    elif [[ "$line" == "${reinstall_p}" ]]; then
        echo "$reinstalling (Panel)..."
        printf "\n \n$confirm_reinstall\n \n"
        read -r response
        case "$response" in
        [yY][eE][sS] | [yY])
            ${reinstall_p_start}
            printf "\n \n$cmd_executed\n \n"
            exit
            ;;
        *)
            printf "\n \n$cmd_not_executed\n \n"
            ;;
        esac
    elif [[ "$line" == "${reinstall_n}" ]]; then
        echo "$reinstalling (Nginx)..."
        printf "\n \n$confirm_reinstall\n \n"
        read -r response
        case "$response" in
        [yY][eE][sS] | [yY])
            ${reinstall_n_start}
            printf "\n \n$cmd_executed\n \n"
            exit
            ;;
        *)
            printf "\n \n$cmd_not_executed\n \n"
            ;;
        esac
    elif [[ "$line" == "${reinstall_f}" ]]; then
        echo "$reinstalling (PHP-FPM)..."
        printf "\n \n$confirm_reinstall\n \n"
        read -r response
        case "$response" in
        [yY][eE][sS] | [yY])
            ${reinstall_f_start}
            printf "\n \n$cmd_executed\n \n"
            exit
            ;;
        *)
            printf "\n \n$cmd_not_executed\n \n"
            ;;
        esac
    elif [ "$line" != "${composer}" ] || [ "$line" != "${setup}" ] || [ "$line" != "${database}" ] || [ "$line" != "${migrate}" ] || [ "$line" != "${user_make}" ] || [ "$line" != "${yarn}" ]; then
        echo "$invalid_command"
    else
        echo "$script_failed"
    fi
done