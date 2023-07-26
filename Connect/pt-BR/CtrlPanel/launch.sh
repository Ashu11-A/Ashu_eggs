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

echo "🟢  Iniciando PHP-FPM..."
nohup /usr/sbin/php-fpm8.1 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize >/dev/null 2>&1 &

echo "🟢  Iniciando Nginx..."
nohup /usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/ >/dev/null 2>&1 &
if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="na porta ${SERVER_PORT}"
else
    MGM="em ${SERVER_IP}:${SERVER_PORT}"
fi
echo "🟢  Inicializado com sucesso ${MGM}..."
echo "🟢  Iniciando worker do controlpanel..."
nohup php /home/container/controlpanel/artisan queue:work --sleep=3 --tries=3 >/dev/null 2>&1 &
echo "🟢  Iniciando cron..."
nohup bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/CtrlPanel/cron.sh) >/dev/null 2>&1 &

echo "📃  Comandos Disponíveis: ${bold}${lightblue}composer${normal}, ${bold}${lightblue}clear${normal}, ${bold}${lightblue}mysql ${bold}${lightblue}migrate${normal}, ${bold}${lightblue}reinstall${normal}. Use ${bold}${lightblue}help${normal} para saber mais..."

while read -r line; do
    if [[ "$line" == "help" ]]; then
        echo "Comandos Disponíveis:"
        echo "
+-----------+---------------------------------------+
| Comando   |  O que Faz                            |
+-----------+---------------------------------------+
| composer  |  Instalar pacotes do Composer         |
| mysql     |  Pode executar qualquer comando do... |
| migrate   |  Migração de banco de dados           |
| reinstall |  Reinstala algo ou tudo               |
+-----------+---------------------------------------+
        "
    elif [[ "$line" == "composer" ]]; then

        echo "Instalando pacotes do Composer: ${bold}${lightblue}${composer_start}"
        eval "cd /home/container/controlpanel && rm -rf /var/www/controlpanel/vendor && $composer_start && cd .."
        printf "\n \n✅  Comando Executado\n \n"

    elif [[ "$line" == "reinstall" ]]; then
        echo -e "❗️  \e[1m\e[94mEsse Comando necessita de uma opção use:\n \n${bold}${lightblue}reinstall all ${normal}(reinstala o controlpanel, nginx, php-fpm)\n \n${bold}${lightblue}reinstall controlpanel ${normal}(reinstala somente o controlpanel)\n \n${bold}${lightblue}reinstall nginx ${normal}(reinstala somente o nginx) \n \n${bold}${lightblue}reinstall php-fpm ${normal}(reinstala somente o php-fpm)"

    elif [[ "$line" == "migrate" ]]; then

        echo "Migrando banco de dados: ${bold}${lightblue}${migrate_start}"
        eval "cd /home/container/controlpanel && $migrate_start && cd .."
        printf "\n \n✅  Comando Executado\n \n"

    elif [[ "$line" == "clear" ]]; then

        echo "Limpando cache: ${bold}${lightblue}${clear}"
        eval "cd /home/container/controlpanel && $clear && cd .."
        printf "\n \n✅  Comando Executado\n \n"

    elif [[ "$line" == "mysql"* ]]; then

        echo "Executando: ${bold}${lightblue}${line}"
        eval "cd /home/container/controlpanel && $line && cd .."
        printf "\n \n✅  Comando Executado\n \n"

    elif [[ "$line" == "${reinstall_a}" ]]; then

        echo "📌  Reinstalando o controlpanel, nginx e php-fpm..."
        printf "\n \n⚠️  Tem certeza que deseja Reinstalar? [y/N]\n \n"
        read -r response
        case "$response" in
        [yY][eE][sS] | [yY])
            ${reinstall_a_start}
            printf "\n \n✅  Comando Executado\n \n"
            exit
            ;;
        *)
            printf "\n \n❌  Comando Não Executado\n \n"
            ;;
        esac

    elif [[ "$line" == "${reinstall_p}" ]]; then

        echo "📌  Reinstalando o Controlpanel..."
        printf "\n \n⚠️  Tem certeza que deseja Reinstalar? [y/N]\n \n"
        read -r response
        case "$response" in
        [yY][eE][sS] | [yY])
            ${reinstall_p_start}
            printf "\n \n✅  Comando Executado\n \n"
            exit
            ;;
        *)
            printf "\n \n❌  Comando Não Executado\n \n"
            ;;
        esac

    elif [[ "$line" == "${reinstall_n}" ]]; then

        echo "📌  Reinstalando o Nginx..."
        printf "\n \n⚠️  Tem certeza que deseja Reinstalar? [y/N]\n \n"
        read -r response
        case "$response" in
        [yY][eE][sS] | [yY])
            ${reinstall_n_start}
            printf "\n \n✅  Comando Executado\n \n"
            exit
            ;;
        *)
            printf "\n \n❌  Comando Não Executado\n \n"
            ;;
        esac

    elif [[ "$line" == "${reinstall_f}" ]]; then

        echo "📌  Reinstalando o PHP-FPM..."
        printf "\n \n⚠️  Tem certeza que deseja Reinstalar? [y/N]\n \n"
        read -r response
        case "$response" in
        [yY][eE][sS] | [yY])
            ${reinstall_f_start}
            printf "\n \n✅  Comando Executado\n \n"
            exit
            ;;
        *)
            printf "\n \n❌  Comando Não Executado\n \n"
            ;;
        esac

    elif [ "$line" != "composer" ] || [[ "$line" != "reinstall"* ]]; then
        echo "Comando Invalido, oque vocẽ está tentando fazer? tente ${bold}${lightblue}help"
    else
        echo "Script Falhou."
    fi
done
