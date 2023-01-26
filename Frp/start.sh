#!/bin/bash
if [ "${FRP_MODE}" == "1" ]; then
    echo "⊝ Versão do Script: 1.1"
    echo "Saiba Mais: https://github.com/fatedier/frp"
    echo "✓ Iniciando Frps"
    cp -f frpc.ini ./exemplo_frpc_windows64/frpc.ini
    ./frps -c ./frps.ini
else
    echo "⊝ Versão do Script: 1.1"
    echo "Saiba Mais: https://github.com/fatedier/frp"
    echo "✓ Iniciando Frpc"
    ./frpc -c ./frpc.ini
fi