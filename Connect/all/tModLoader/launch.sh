#!/bin/bash
# shellcheck shell=bash

# Cores suaves usando a paleta de 256 cores do terminal
color_accent='\e[38;5;111m'  # Azul suave
color_success='\e[38;5;114m' # Verde suave
color_warning='\e[38;5;180m' # Laranja suave
color_error='\e[38;5;167m'   # Vermelho suave
color_dim='\e[38;5;242m'     # Cinza
color_reset='\e[0m'
text_bold='\e[1m'

echo ""
echo -e "${color_accent} ▍ ${text_bold}tModLoader${color_reset} ${color_dim}• Boot Manager${color_reset}"
echo ""
echo -e "   [${color_accent}1${color_reset}] Start Server ${color_dim}(Default)${color_reset}"
echo -e "   [${color_accent}2${color_reset}] Sync Mods ${color_dim}(Steam)${color_reset}"
echo ""

# Prompt de seleção minimalista
read -r -t 10 -p $'\e[38;5;111m ❯ \e[0mSelect an option [1]: ' selected_option
echo ""

if [[ "$selected_option" == "2" ]]; then
  if [ -f "./tml-sync" ]; then
    echo -e "${color_warning} ⟳ ${color_reset} Starting mod synchronization..."
    chmod +x ./tml-sync
    ./tml-sync --port "${SERVER_PORT}"
    echo -e "${color_success} ✓ ${color_reset} Synchronization complete."
  else
    echo -e "${color_error} ✗ ${color_reset} tml-sync file not found!"
  fi
  exit 0
fi

echo -e "${color_success} 🚀 ${color_reset} Starting server..."

# Prepara o comando de tempo falso se a variável estiver ativa
declare -a fake_time_command=()
if [ "${FAKETIME}" = "1" ]; then
  fake_time_command=(env "LD_PRELOAD=/usr/lib/faketime/libfaketime.so.1" "FAKETIME=$SET_DATE")
fi

# Inicia o servidor expandindo o array de forma segura
"${fake_time_command[@]}" dotnet tModLoader.dll -server "$@" -config serverconfig.txt