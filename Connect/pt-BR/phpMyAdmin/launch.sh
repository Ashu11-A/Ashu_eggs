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

echo "🟢  Iniciando PHP-FPM..."
nohup /usr/sbin/php-fpm7 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize >/dev/null 2>&1 &

echo "🟢  Iniciando Nginx..."
nohup /usr/sbin/nginx -c /home/container/nginx/nginx.conf -p /home/container/ >/dev/null 2>&1 &
if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="na porta ${SERVER_PORT}"
else
    MGM="em ${SERVER_IP}:${SERVER_PORT}"
fi
echo "🟢  Inicializado com sucesso ${MGM}..."

echo "⚙️  Configure o phpMyAdmin em phpMyAdmin/config.inc.php"
echo "🔗  https://stackoverflow.com/questions/29928109/getting-error-mysqlireal-connect-hy000-2002-no-such-file-or-directory-wh"

echo "📃  Comandos Disponíveis:${bold}${lightblue}reinstall${normal}..."

while read -r line; do
    if [[ "$line" == "help" ]]; then
        echo "Comandos Disponíveis:"
        echo "
+-----------+---------------------------------------+
| Comando   |  O que Faz                            |
+-----------+---------------------------------------+
| reinstall |  Reinstala algo ou tudo               |
+-----------+---------------------------------------+
        "

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

    elif [[ "$line" != "reinstall"* ]]; then
        echo "Comando Invalido, oque vocẽ está tentando fazer? tente ${bold}${lightblue}help"
    else
        echo "Script Falhou."
    fi
done
