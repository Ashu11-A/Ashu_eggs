#!/bin/bash

composer_start="composer install --no-dev --optimize-autoloader"

reinstall_a="reinstall all"
reinstall_a_start="rm -rf controlpanel && rm -rf logs/panel* && rm -rf nginx && rm -rf php-fpm"

migrate_start="php artisan migrate --seed --force"

clear="php artisan view:clear && php artisan config:clear"

reinstall_p="reinstall controlpanel"
reinstall_p_start="rm -rf controlpanel && rm -rf logs/panel*"

reinstall_n="reinstall nginx"
reinstall_n_start="rm -rf nginx"

reinstall_f="reinstall php-fpm"
reinstall_f_start="rm -rf php-fpm"

bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
normal=$(echo -en "\e[0m")
rm -rf /home/container/tmp/*

echo "🟢  Starting PHP-FPM..."
nohup /usr/sbin/php-fpm8.1 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize >/dev/null 2>&1 &

echo "🟢  Starting Nginx..."
nohup /usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/ >/dev/null 2>&1 &
if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="on port ${SERVER_PORT}"
else
    MGM="on ${SERVER_IP}:${SERVER_PORT}"
fi
echo "🟢  Successfully initialized ${MGM}..."
echo "🟢  Starting controlpanel worker..."
nohup php /home/container/controlpanel/artisan queue:work --sleep=3 --tries=3 >/dev/null 2>&1 &
echo "🟢  Starting cron..."
nohup bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/CtrlPanel/cron.sh) >/dev/null 2>&1 &

echo "📃  Available Commands: ${bold}${lightblue}composer${normal}, ${bold}${lightblue}clear${normal}, ${bold}${lightblue}mysql ${bold}${lightblue}migrate${normal}, ${bold}${lightblue}reinstall${normal}. Use ${bold}${lightblue}help${normal} to learn more..."

while read -r line; do
    if [[ "$line" == "help" ]]; then
        echo "Available Commands:"
        echo "
+-----------+---------------------------------------+
| Command   |  What it Does                         |
+-----------+---------------------------------------+
| composer  |  Install Composer packages            |
| mysql     |  Can execute any MySQL command...     |
| migrate   |  Database migration                   |
| reinstall |  Reinstall something or everything   |
+-----------+---------------------------------------+
        "
    elif [[ "$line" == "composer" ]]; then

        echo "Installing Composer packages: ${bold}${lightblue}${composer_start}"
        eval "cd /home/container/controlpanel && rm -rf /var/www/controlpanel/vendor && $composer_start && cd .."
        printf "\n \n✅  Command Executed\n \n"

    elif [[ "$line" == "reinstall" ]]; then
        echo -e "❗️  \e[1m\e[94mThis Command needs an option use:\n \n${bold}${lightblue}reinstall all ${normal}(reinstall the controlpanel, nginx, php-fpm)\n \n${bold}${lightblue}reinstall controlpanel ${normal}(reinstall only the controlpanel)\n \n${bold}${lightblue}reinstall nginx ${normal}(reinstall only the nginx) \n \n${bold}${lightblue}reinstall php-fpm ${normal}(reinstall only the php-fpm)"

    elif [[ "$line" == "migrate" ]]; then

        echo "Migrating database: ${bold}${lightblue}${migrate_start}"
        eval "cd /home/container/controlpanel && $migrate_start && cd .."
        printf "\n \n✅  Command Executed\n \n"

    elif [[ "$line" == "clear" ]]; then

        echo "Clearing cache: ${bold}${lightblue}${clear}"
        eval "cd /home/container/controlpanel && $clear && cd .."
        printf "\n \n✅  Command Executed\n \n"

    elif [[ "$line" == "mysql"* ]]; then

        echo "Executing: ${bold}${lightblue}${line}"
        eval "cd /home/container/controlpanel && $line && cd .."
        printf "\n \n✅  Command Executed\n \n"

    elif [[ "$line" == "${reinstall_a}" ]]; then

        echo "📌  Reinstalling the controlpanel, nginx and php-fpm..."
        printf "\n \n⚠️  Are you sure you want to Reinstall? [y/N]\n \n"
        read -r response
        case "$response" in
        [yY][eE][sS] | [yY])
            ${reinstall_a_start}
            printf "\n \n✅  Command Executed\n \n"
            exit
            ;;
        *)
            printf "\n \n❌  Command Not Executed\n \n"
            ;;
        esac

    elif [[ "$line" == "${reinstall_p}" ]]; then

        echo "📌  Reinstalling the Controlpanel..."
        printf "\n \n⚠️  Are you sure you want to Reinstall? [y/N]\n \n"
        read -r response
        case "$response" in
        [yY][eE][sS] | [yY])
            ${reinstall_p_start}
            printf "\n \n✅  Command Executed\n \n"
            exit
            ;;
        *)
            printf "\n \n❌  Command Not Executed\n \n"
            ;;
        esac

    elif [[ "$line" == "${reinstall_n}" ]]; then

        echo "📌  Reinstalling Nginx..."
        printf "\n \n⚠️  Are you sure you want to Reinstall? [y/N]\n \n"
        read -r response
        case "$response" in
        [yY][eE][sS] | [yY])
            ${reinstall_n_start}
            printf "\n \n✅  Command Executed\n \n"
            exit
            ;;
        *)
            printf "\n \n❌  Command Not Executed\n \n"
            ;;
        esac

    elif [[ "$line" == "${reinstall_f}" ]]; then

        echo "📌  Reinstalling PHP-FPM..."
        printf "\n \n⚠️  Are you sure you want to Reinstall? [y/N]\n \n"
        read -r response
        case "$response" in
        [yY][eE][sS] | [yY])
            ${reinstall_f_start}
            printf "\n \n✅  Command Executed\n \n"
            exit
            ;;
        *)
            printf "\n \n❌  Command Not Executed\n \n"
            ;;
        esac

    elif [ "$line" != "composer" ] || [[ "$line" != "reinstall"* ]]; then
        echo "Invalid command, what are you trying to do? try ${bold}${lightblue}help"
    else
        echo "Script Failed."
    fi
done
