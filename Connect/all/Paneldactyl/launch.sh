#!/bin/bash

echo "Paneldactyl" | figlet -c -f slant -t -k | /usr/games/lolcat

bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
normal=$(echo -en "\e[0m")
rm -rf /home/container/tmp/*

# ---------------------------------------------------------
# Detecção Dinâmica de Binários
# ---------------------------------------------------------

# Procura pelo binário do PHP (CLI)
PHP_BIN=$(command -v php || echo "/usr/bin/php")

# Procura pelo binário do Nginx
NGINX_BIN=$(command -v nginx || echo "/usr/sbin/nginx")

# Procura pelo binário do PHP-FPM (Tenta genérico, depois versões especificas comuns, depois fallback hardcoded)
PHP_FPM_BIN=$(command -v php-fpm || command -v php-fpm83 || command -v php-fpm82 || command -v php-fpm81 || command -v php-fpm8 || echo "/usr/sbin/php-fpm")

# Verifica se foram encontrados (opcional, para debug)
if [ ! -x "$NGINX_BIN" ] || [ ! -x "$PHP_FPM_BIN" ]; then
    echo "AVISO: Binários do Nginx ou PHP-FPM não foram encontrados automaticamente."
    echo "Nginx: $NGINX_BIN | PHP-FPM: $PHP_FPM_BIN"
fi

# ---------------------------------------------------------

# Carrega tradução manualmente
export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Lang/paneldactyl.conf"
curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/loadLang.sh" -o /tmp/loadLang.sh
source /tmp/loadLang.sh
rm -f /tmp/loadLang.sh

# Detecta pasta
if [ -d "/home/container/painel" ]; then PANEL_DIR="painel"; else PANEL_DIR="panel"; fi

# Usa o PHP dinâmico nos comandos do artisan/composer se desejar,
# mas geralmente 'php' e 'composer' já estão no PATH. 
# Abaixo mantive os comandos originais, mas alterei as linhas de inicialização do serviço.

composer_start="composer install --no-dev --optimize-autoloader"
setup_start="$PHP_BIN artisan p:environment:setup"
database_start="$PHP_BIN artisan p:environment:database"
migrate_start="$PHP_BIN artisan migrate --seed --force"
user_make="user"
user_start="$PHP_BIN artisan p:user:make"
yarn="build"
yarn_start="yarn && yarn lint --fix && yarn build && $PHP_BIN artisan migrate && $PHP_BIN artisan view:clear && $PHP_BIN artisan cache:clear && $PHP_BIN artisan route:clear"

reinstall_a="reinstall all"
reinstall_a_start="rm -rf $PANEL_DIR && rm -rf logs/panel* && rm -rf nginx && rm -rf php-fpm"
reinstall_p="reinstall painel"
reinstall_p_start="rm -rf $PANEL_DIR && rm -rf logs/panel*"
reinstall_n="reinstall nginx"
reinstall_n_start="rm -rf nginx"
reinstall_f="reinstall php-fpm"
reinstall_f_start="rm -rf php-fpm"

echo "$starting_php"
# Usa a variável dinâmica PHP_FPM_BIN
nohup "$PHP_FPM_BIN" --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize >/dev/null 2>&1 &

echo "$starting_nginx"
# Usa a variável dinâmica NGINX_BIN
nohup "$NGINX_BIN" -c /home/container/nginx/nginx.conf -p /home/container/ >/dev/null 2>&1 &

if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="0.0.0.0:${SERVER_PORT}"
else
    MGM="${SERVER_IP}:${SERVER_PORT}"
fi
echo "$started_success ${MGM}..."

echo "$starting_worker"
# Usa a variável dinâmica PHP_BIN
nohup "$PHP_BIN" /home/container/$PANEL_DIR/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3 >/dev/null 2>&1 &

echo "$starting_cron"
# Baixa o cron para um arquivo persistente oculto e executa
curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Paneldactyl/cron.sh -o /home/container/.cron_runner.sh
nohup bash /home/container/.cron_runner.sh >/dev/null 2>&1 &

echo "$avail_commands ${bold}${lightblue}composer${normal}, ${bold}${lightblue}setup${normal}, ${bold}${lightblue}database${normal}, ${bold}${lightblue}migrate${normal}, ${bold}${lightblue}user${normal}, ${bold}${lightblue}build${normal}, ${bold}${lightblue}reinstall${normal}. Use ${bold}${lightblue}help${normal}..."

while read -r line; do
    if [[ "$line" == "help" ]]; then
      echo "$avail_commands"

      # --- Lógica de Tabela Dinâmica ---

      # 1. Define a largura da primeira coluna (Comandos)
      # "reinstall" é a maior palavra (9 chars), damos uma margem para 12.
      c1_width=12

      # 2. Encontra a largura necessária para a segunda coluna (Descrições)
      # Adicionamos o cabeçalho e todas as descrições em um array temporário
      desc_list=("$cmd_desc_header" "$cmd_composer" "$cmd_setup" "$cmd_database" "$cmd_migrate" "$cmd_user" "$cmd_build" "$cmd_reinstall" "$cmd_nodejs")
      
      max_len=0
      for item in "${desc_list[@]}"; do
          len=${#item}
          if (( len > max_len )); then max_len=$len; fi
      done

      # Adiciona um pouco de respiro (padding) à largura máxima encontrada
      c2_width=$((max_len + 2))

      # 3. Cria a linha separadora (+-----------+----------------...+)
      # Usa printf para criar espaços e tr para substituir por traços
      sep_line="+$(printf '%*s' "$c1_width" "" | tr ' ' '-')+$(printf '%*s' "$c2_width" "" | tr ' ' '-')+"

      # 4. Define o formato da linha para o printf
      # "| %-12s | %-Ns |\n" (alinha à esquerda com padding)
      fmt="| %-$((c1_width-1))s | %-$((c2_width-1))s |\n"

      # 5. Imprime a tabela
      echo ""
      echo "$sep_line"
      # Cabeçalho (Command | Description Header)
      printf "$fmt" " Command" " $cmd_desc_header"
      echo "$sep_line"
      
      # Linhas de comando
      printf "$fmt" " composer" " $cmd_composer"
      printf "$fmt" " setup" " $cmd_setup"
      printf "$fmt" " database" " $cmd_database"
      printf "$fmt" " migrate" " $cmd_migrate"
      printf "$fmt" " user" " $cmd_user"
      printf "$fmt" " build" " $cmd_build"
      printf "$fmt" " reinstall" " $cmd_reinstall"
      printf "$fmt" " nodejs" " $cmd_nodejs"
      
      echo "$sep_line"
      echo ""
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