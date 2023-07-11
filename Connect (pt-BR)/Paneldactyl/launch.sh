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
echo "🟢  Iniciando PHP-FPM..."
nohup /usr/sbin/php-fpm81 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize >/dev/null 2>&1 &

echo "🟢  Iniciando Nginx..."
nohup /usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/ >/dev/null 2>&1 &
if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="na porta ${SERVER_PORT}"
else
    MGM="em ${SERVER_IP}:${SERVER_PORT}"
fi
echo "🟢  Inicializado com sucesso ${MGM}..."
echo "🟢  Iniciando worker do painel.."
nohup php /home/container/painel/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3 >/dev/null 2>&1 &
echo "🟢  Iniciando cron..."
nohup bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Paneldactyl/cron.sh) >/dev/null 2>&1 &

echo "📃  Comandos Disponíveis: ${bold}${lightblue}composer${normal}, ${bold}${lightblue}setup${normal}, ${bold}${lightblue}database${normal}, ${bold}${lightblue}migrate${normal}, ${bold}${lightblue}user${normal}, ${bold}${lightblue}build${normal}, ${bold}${lightblue}reinstall${normal}. Use ${bold}${lightblue}help${normal} para saber mais..."

while read -r line; do
    if [[ "$line" == "help" ]]; then
        echo "Comandos Disponíveis:"
        echo "
+-----------+---------------------------------------+
| Comando   |  O que Faz                            |
+-----------+---------------------------------------+
| composer  |  Instalar pacotes do Composer         |
| setup     |  Configurações basicas do Painel      |
| database  |  Configurar Banco de Dados            |
| migrate   |  Migração de banco de dados           |
| user      |  Criar usuário                        |
| build     |  Builda o painel com Yarn             |
| reinstall |  Reinstala algo ou tudo               |
+-----------+---------------------------------------+
        "
    elif [[ "$line" == "composer" ]]; then

        Comando1="${composer_start}"
        echo "Instalando pacotes do Composer: ${bold}${lightblue}${Comando1}"
        eval "cd /home/container/painel && $Comando1 && cd .."
        printf "\n \n✅  Comando Executado\n \n"
    elif [[ "$line" == "setup" ]]; then

        Comando2="${setup_start}"
        echo "Configurando ambiente do painel: ${bold}${lightblue}${Comando2}"
        eval "cd /home/container/painel && $Comando2 && cd .."
        printf "\n \n✅  Comando Executado\n \n"

    elif [[ "$line" == "database" ]]; then

        Comando3="${database_start}"
        echo "Configurando ambiente do painel: ${bold}${lightblue}${Comando3}"
        eval "cd /home/container/painel && $Comando3 && cd .."
        printf "\n \n✅  Comando Executado\n \n"

    elif [[ "$line" == "migrate" ]]; then

        Comando4="${migrate_start}"
        echo "Migrando banco de dados: ${bold}${lightblue}${Comando4}"
        eval "cd /home/container/painel && $Comando4 && cd .."
        printf "\n \n✅  Comando Executado\n \n"

    elif [[ "$line" == "${user_make}" ]]; then

        Comando5="${user_start}"
        echo "Criando usuário: ${bold}${lightblue}${Comando5}"
        eval "cd /home/container/painel && $Comando5 && cd .."
        printf "\n \n✅  Comando Executado\n \n"

    elif [[ "$line" == "${yarn}" ]]; then

        Comando6="${yarn_start}"
        echo "Buildando painel: ${bold}${lightblue}${Comando6}"
        echo -e "\n \n⚠️  São necessários no mínimo 2 GB de memória RAM"
        echo -e "📃  Memoria RAM disponivel: ${bold}${lightblue}${SERVER_MEMORY} MB\n \n"
        eval "cd /home/container/painel && $Comando6 && cd .."
        printf "\n \n✅  Comando Executado\n \n"

    elif [[ "$line" == "reinstall" ]]; then
        echo -e "❗️  \e[1m\e[94mEsse Comando necessita de uma opção use:\n \n${bold}${lightblue}reinstall all ${normal}(reinstala o painel, nginx, php-fpm)\n \n${bold}${lightblue}reinstall painel ${normal}(reinstala somente o painel)\n \n${bold}${lightblue}reinstall nginx ${normal}(reinstala somente o nginx) \n \n${bold}${lightblue}reinstall php-fpm ${normal}(reinstala somente o php-fpm)"

    elif [[ "$line" == "${reinstall_a}" ]]; then

        echo "📌  Reinstalando o painel, nginx e php-fpm..."
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

        echo "📌  Reinstalando o Painel..."
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

    elif [ "$line" != "${composer}" ] || [ "$line" != "${setup}" ] || [ "$line" != "${database}" ] || [ "$line" != "${migrate}" ] || [ "$line" != "${user_make}" ] || [ "$line" != "${yarn}" ]; then
        echo "Comando Invalido, oque vocẽ está tentando fazer? tente ${bold}${lightblue}help"
    else
        echo "Script Falhou."
    fi
done
