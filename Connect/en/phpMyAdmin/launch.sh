#!/bin/bash

reinstall_a="reinstall all"
reinstall_a_start="rm -rf phpMyAdmin && rm -rf logs/panel* && rm -rf nginx && rm -rf php-fpm"

reinstall_p="reinstall phpMyAdmin"
reinstall_p_start="rm -rf phpMyAdmin && rm -rf logs/panel*"

reinstall_n="reinstall nginx"
reinstall_n_start="rm -rf nginx"

reinstall_f="reinstall php-fpm"
reinstall_f_start="rm -rf php-fpm"

bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
normal=$(echo -en "\e[0m")
rm -rf /home/container/tmp/*

echo "🟢  Starting PHP-FPM..."
nohup /usr/sbin/php-fpm81 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize >/dev/null 2>&1 &

echo "🟢  Starting Nginx..."
nohup /usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/ >/dev/null 2>&1 &
if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="on port ${SERVER_PORT}"
else
    MGM="on ${SERVER_IP}:${SERVER_PORT}"
fi
echo "🟢  Successfully initialized ${MGM}..."

echo "⚙️  Configure phpMyAdmin in phpMyAdmin/config.inc.php"
echo "🔗  https://stackoverflow.com/questions/29928109/getting-error-mysqlireal-connect-hy000-2002-no-such-file-or-directory-wh"

echo "📃  Available Commands:${bold}${lightblue}reinstall${normal}..."

while read -r line; do
    if [[ "$line" == "help" ]]; then
        echo "Available Commands:"
        echo "
+-----------+---------------------------------------+
| Command   |  What it Does                         |
+-----------+---------------------------------------+
| reinstall |  Reinstall something or everything   |
+-----------+---------------------------------------+
        "

    elif [[ "$line" == "${reinstall_a}" ]]; then

        echo "📌  Reinstalling the control panel, nginx and php-fpm..."
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

        echo "📌  Reinstalling the Control Panel..."
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

    elif [[ "$line" != "reinstall"* ]]; then
        echo "Invalid command, what are you trying to do? try ${bold}${lightblue}help"
    else
        echo "Script Failed."
    fi
done
