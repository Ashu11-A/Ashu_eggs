#!/bin/bash
if [ "${INSTALL_EX}" == "1" ]; then
    cp -f ./Frpc/frpc.ini ./Exemplo_Frpc_Windows64/frpc.ini
fi

echo "⚙️  Versão do Script: 2.4"

if [ "${FRP_MODE}" == "1" ]; then
    echo "👀  Saiba Mais: https://github.com/fatedier/frp"
    echo "✅  Iniciando Frps"
    echo "⚠️  Atenção, o FRP mudou de frps.ini para frps.toml"

    if [[ -f "./Frps/frps.toml" ]]; then
        ./Frps/frps -c ./Frps/frps.toml
    else
        ./Frps/frps -c ./Frps/frps.ini
    fi
else
    echo "👀  Saiba Mais: https://github.com/fatedier/frp"
    echo "✅  Iniciando Frpc"
    echo "⚠️  Atenção, o FRP mudou de frps.ini para frps.toml"

    if [[ -f "./Frps/frps.toml" ]]; then
        ./Frpc/frpc -c ./Frpc/frpc.toml
    else
        ./Frpc/frpc -c ./Frpc/frpc.ini
    fi
fi
