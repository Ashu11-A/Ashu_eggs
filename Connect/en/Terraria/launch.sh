#!/bin/bash
# shellcheck shell=dash

if [ "${TERRARIA_VERSION}" = "1.4.4" ] || [ "${TERRARIA_VERSION}" = "144" ]; then
    if [ "${FAKETIME}" = "1" ]; then
        LD_PRELOAD=/usr/lib/faketime/libfaketime.so.1 FAKETIME="$ANO_DIA" mono --server --gc=sgen -O=all ./TerrariaServer.exe -ip 0.0.0.0 -port {{SERVER_PORT}} -maxplayers {{MAX_PLAYERS}} -difficulty {{DIFFICULTY}} -pass {{PASSWORD}} -motd {{MOTD}} -world /home/container/.local/share/Terraria/Worlds/{{WORLD_NAME}}.wld -autocreate {{WORLD_SIZE}} -banlist /home/container/banlist.txt -worldname {{WORLD_NAME}} -secure {{SECURE}} -seed {{SEED}}
    else
        mono --server --gc=sgen -O=all ./TerrariaServer.exe -ip 0.0.0.0 -port {{SERVER_PORT}} -maxplayers {{MAX_PLAYERS}} -difficulty {{DIFFICULTY}} -pass {{PASSWORD}} -motd {{MOTD}} -world /home/container/.local/share/Terraria/Worlds/{{WORLD_NAME}}.wld -autocreate {{WORLD_SIZE}} -banlist /home/container/banlist.txt -worldname {{WORLD_NAME}} -secure {{SECURE}} -seed {{SEED}}
    fi
else
    if [ "${FAKETIME}" = "1" ]; then
        LD_PRELOAD=/usr/lib/faketime/libfaketime.so.1 FAKETIME="$ANO_DIA" mono --server --gc=sgen -O=all ./TerrariaServer.exe -config serverconfig.txt
    else
        mono --server --gc=sgen -O=all ./TerrariaServer.exe -config serverconfig.txt
    fi
fi
