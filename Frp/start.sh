#!/bin/bash
if [ "${INSTALL_EX}" == "1" ]; then
    cp -f ./Frpc/frpc.ini ./Exemplo_Frpc_Windows64/frpc.ini
fi

echo "⚙️  Versão do Script: 2.0"

if [ "${FRP_MODE}" == "1" ]; then
    echo "👀  Saiba Mais: https://github.com/fatedier/frp"
    echo "✅  Iniciando Frps"
    ./Frps/frps -c ./Frps/frps.ini
else
    echo "👀  Saiba Mais: https://github.com/fatedier/frp"
    echo "✅  Iniciando Frpc"
    ./Frpc/frpc -c ./Frpc/frpc.ini
fi
