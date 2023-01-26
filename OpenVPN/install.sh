#!/bin/bash
if [[ -f "./Emby/EmbyServer.dll" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/OpenVPN/start.sh)
else
    export AUTO_INSTALL=y
    bash <(curl -s https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh)
    mkdir Logs
    touch ./Logs/instalado
fi