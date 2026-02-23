#!/bin/bash
# shellcheck shell=bash

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}================================================${NC}"
echo -e "${CYAN}          tModLoader - Boot Menu                ${NC}"
echo -e "${CYAN}================================================${NC}"
echo -e " [1] ${GREEN}Start Server (Default)${NC}"
echo -e " [2] ${YELLOW}Sync Mods (Steam)${NC}"
echo -e "${CYAN}------------------------------------------------${NC}"
read -r -t 10 -p " Select an option [1]: " OPTION
echo -e "${CYAN}------------------------------------------------${NC}"

if [[ "$OPTION" == "2" ]]; then
    if [ -f "./tml-sync" ]; then
        echo -e "${YELLOW}🔄 Starting mod synchronization...${NC}"
        chmod +x ./tml-sync
        ./tml-sync
        echo -e "${GREEN}✅ Synchronization complete.${NC}"
    else
        echo -e "${RED}❌ tml-sync file not found!${NC}"
    fi
    exit 0
fi

echo -e "${GREEN}🚀 Starting server...${NC}"

declare -a fake_time_cmd=()
if [ "${FAKETIME}" = "1" ]; then
    # Execute o comando em um ambiente modificado com `env`
    fake_time_cmd=(env "LD_PRELOAD=/usr/lib/faketime/libfaketime.so.1" "FAKETIME=$SET_DATE")
fi

# A expansão de array citada "${fake_time_cmd[@]}" garante que cada parâmetro seja tratado como uma string separada, evitando problemas com espaços.
"${fake_time_cmd[@]}" dotnet tModLoader.dll -server "$@" -config serverconfig.txt
