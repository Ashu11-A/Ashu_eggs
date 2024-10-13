#!/bin/bash

composer_start="composer install --no-dev --optimize-autoloader"

setup_start="php artisan p:environment:setup"

database_start="php artisan p:environment:database"

migrate_start="php artisan migrate --seed --force"

user_make="user"
user_start="php artisan p:user:make"

yarn="build"
yarn_start="yarn && yarn lint --fix && yarn build && php artisan migrate && php artisan view:clear && php artisan cache:clear && php artisan route:clear"

reinstall_a="reinstall all"
reinstall_a_start="rm -rf painel && rm -rf logs/panel* && rm -rf nginx && rm -rf php-fpm"

reinstall_p="reinstall painel"
reinstall_p_start="rm -rf painel && rm -rf logs/panel*"

reinstall_n="reinstall nginx"
reinstall_n_start="rm -rf nginx"

reinstall_f="reinstall php-fpm"
reinstall_f_start="rm -rf php-fpm"

bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
normal=$(echo -en "\e[0m")
rm -rf /home/container/tmp/*
printf "
 ______                        _      _                             _ 
(_____ \                      | |    | |               _           | |
 _____) )  ____  ____    ____ | |  _ | |  ____   ____ | |_   _   _ | |
|  ____/  / _  ||  _ \  / _  )| | / || | / _  | / ___)|  _) | | | || |
| |      ( ( | || | | |( (/ / | |( (_| |( ( | |( (___ | |__ | |_| || |
|_|       \_||_||_| |_| \____)|_| \____| \_||_| \____) \___) \__  ||_|
                                                            (____/    
\n \n"
echo "🟢 Starting PHP-FPM..."
nohup /usr/sbin/php-fpm --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize >/dev/null 2>&1 &

echo "🟢 Starting Nginx..."
nohup /usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/ >/dev/null 2>&1 &
if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="on port ${SERVER_PORT}"
else
    MGM="on ${SERVER_IP}:${SERVER_PORT}"
fi
echo "🟢 Started successfully ${MGM}..."
echo "🟢 Starting panel worker..."
nohup php /home/container/painel/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3 >/dev/null 2>&1 &
echo "🟢 Starting cron..."
nohup bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/Paneldactyl/cron.sh) >/dev/null 2>&1 &

echo "📃 Available Commands: ${bold}${lightblue}composer${normal}, ${bold}${lightblue}setup${normal}, ${bold}${lightblue}database${normal}, ${bold}${lightblue}migrate${normal}, ${bold}${lightblue}user${normal}, ${bold}${lightblue}build${normal}, ${bold}${lightblue}reinstall${normal}. Use ${bold}${lightblue}help${normal} for more information..."

while read -r line; do
    if [[ "$line" == "help" ]]; then
        echo "Available Commands:"
        echo "
+-----------+---------------------------------------+
| Command   | What it Does                          |
+-----------+---------------------------------------+
| composer  | Install Composer packages             |
| setup     | Set up basic panel configurations     |
| database  | Configure the Database                |
| migrate   | Migrate the Database                  |
| user      | Create a user                         |
| build     | Build the panel with Yarn             |
| reinstall | Reinstall something or everything     |
| nodejs    | Change nodejs version on debian       |
+-----------+---------------------------------------+
"
    elif [[ "$line" == "nodejs" ]]; then
        bash <(curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/nvmSelect.sh")
        printf "\n \n✅  Command Executed\n \n"
    elif [[ "$line" == "composer" ]]; then
        Command1="${composer_start}"
        echo "Installing Composer packages: ${bold}${lightblue}${Command1}"
        eval "cd /home/container/painel && $Command1 && cd .."
        printf "\n \n✅  Command Executed\n \n"
    elif [[ "$line" == "setup" ]]; then

        Command2="${setup_start}"
        echo "Setting up panel environment: ${bold}${lightblue}${Command2}"
        eval "cd /home/container/painel && $Command2 && cd .."
        printf "\n \n✅  Command Executed\n \n"

    elif [[ "$line" == "database" ]]; then

        Command3="${database_start}"
        echo "Setting up database environment: ${bold}${lightblue}${Command3}"
        eval "cd /home/container/painel && $Command3 && cd .."
        printf "\n \n✅  Command Executed\n \n"

    elif [[ "$line" == "migrate" ]]; then

        Command4="${migrate_start}"
        echo "Migrating the database: ${bold}${lightblue}${Command4}"
        eval "cd /home/container/painel && $Command4 && cd .."
        printf "\n \n✅  Command Executed\n \n"

    elif [[ "$line" == "${user_make}" ]]; then

        Command5="${user_start}"
        echo "Creating user: ${bold}${lightblue}${Command5}"
        eval "cd /home/container/painel && $Command5 && cd .."
        printf "\n \n✅  Command Executed\n \n"

    elif [[ "$line" == "${yarn}" ]]; then

        Command6="${yarn_start}"
        echo "Building panel: ${bold}${lightblue}${Command6}"
        echo -e "\n \n⚠️  At least 2 GB of RAM are required"
        echo -e "📃  Available RAM: ${bold}${lightblue}${SERVER_MEMORY} MB\n \n"
        eval "cd /home/container/painel && $Command6 && cd .."
        printf "\n \n✅  Command Executed\n \n"

    elif [[ "$line" == "reinstall" ]]; then
        echo -e "❗️  \e[1m\e[94mThis Command requires an option, use:\n \n${bold}${lightblue}reinstall all ${normal}(reinstall panel, nginx, php-fpm)\n \n${bold}${lightblue}reinstall painel ${normal}(reinstall only the panel)\n \n${bold}${lightblue}reinstall nginx ${normal}(reinstall only nginx) \n \n${bold}${lightblue}reinstall php-fpm ${normal}(reinstall only php-fpm)"

    elif [[ "$line" == "${reinstall_a}" ]]; then

        echo "📌  Reinstalling panel, nginx, and php-fpm..."
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

        echo "📌  Reinstalling the Panel..."
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

    elif [ "$line" != "${composer}" ] || [ "$line" != "${setup}" ] || [ "$line" != "${database}" ] || [ "$line" != "${migrate}" ] || [ "$line" != "${user_make}" ] || [ "$line" != "${yarn}" ]; then
        echo "Invalid Command, what are you trying to do? Try ${bold}${lightblue}help"
    else
        echo "Script Failed."
    fi
done
