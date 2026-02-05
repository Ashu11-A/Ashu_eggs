#!/bin/bash
# shellcheck shell=bash

declare -a fake_time_cmd=()
if [ "${FAKETIME}" = "1" ]; then
    # Execute o comando em um ambiente modificado com `env`
    fake_time_cmd=(env "LD_PRELOAD=/usr/lib/faketime/libfaketime.so.1" "FAKETIME=$ANO_DIA")
fi

declare -a params
if [ "${TERRARIA_VERSION}" = "1.4.4" ] || [ "${TERRARIA_VERSION}" = "144" ]; then
    params=(
        -ip "0.0.0.0"
        -port "{{SERVER_PORT}}"
        -maxplayers "{{MAX_PLAYERS}}"
        -difficulty "{{DIFFICULTY}}"
        -pass "{{PASSWORD}}"
        -motd "{{MOTD}}"
        -world "/home/container/saves/Worlds/{{WORLD_NAME}}.wld"
        -autocreate "{{WORLD_SIZE}}"
        -banlist "/home/container/banlist.txt"
        -worldname "{{WORLD_NAME}}"
        -secure "{{SECURE}}"
        -seed "{{SEED}}"
    )
else
    params=(-config "serverconfig.txt")
fi

# A expansão de array citada "${array[@]}" garante que cada parâmetro seja tratado como uma string separada, evitando problemas com espaços.
"${fake_time_cmd[@]}" mono --server --gc=sgen -O=all ./TerrariaServer.exe "${params[@]}" < /dev/null
