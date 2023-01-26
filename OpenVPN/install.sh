#!/bin/bash
if [[ -f "./Logs/instalado" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/OpenVPN/start.sh)
else
    export AUTO_INSTALL=y
    export APPROVE_INSTALL=y
    export APPROVE_IP=y
    export IPV6_SUPPORT=n
    export PORT_CHOICE=1
    export PROTOCOL_CHOICE=1
    export DNS=1
    export COMPRESSION_ENABLED=y
    export CUSTOMIZE_ENC=n
    export CLIENT=clientname
    export PASS=1
    bash <(curl -s https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh)
    mkdir Logs
    touch ./Logs/instalado
fi