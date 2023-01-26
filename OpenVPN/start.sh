#!/bin/bash
if [[ -f "./Logs/instalado" ]]; then
    echo "⚙️ Versão do Script: 1.0"
    echo "✅ Iniciando OpenVPN"
    bash <(curl -s https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh)
else
    echo "Painel Não Instalado, isso é realmente muito estranho, essa é uma segunda verificação."
fi