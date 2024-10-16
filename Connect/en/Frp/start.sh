#!/bin/bash

if [ -d "Logs" ]; then
    mv Logs logs
fi

if [ "${INSTALL_EX}" == "1" ]; then
    cp -f ./Frpc/frpc.ini ./Example_Frpc_Windows64/frpc.ini
fi

echo "⚙️ Script Version: 2.5"

if [ "${FRP_MODE}" == "1" ]; then
    echo "👀  Learn More: https://github.com/fatedier/frp"
    echo "✅  Starting Frps"
    echo "⚠️  Attention, the FRP has changed from frps.ini to frps.toml"

    if [[ -f "./Frps/frps.toml" ]]; then
        ./Frps/frps -c ./Frps/frps.toml
    else
        ./Frps/frps -c ./Frps/frps.ini
    fi
else
    echo "👀  Learn More: https://github.com/fatedier/frp"
    echo "✅  Starting Frpc"
    echo "⚠️  Attention, the FRP has changed from frps.ini to frps.toml"

    if [[ -f "./Frps/frps.toml" ]]; then
        ./Frpc/frpc -c ./Frpc/frpc.toml
    else
        ./Frpc/frpc -c ./Frpc/frpc.ini
    fi
fi
