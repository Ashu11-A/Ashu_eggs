#!/bin/bash
if [ "${INSTALL_EX}" == "1" ]; then
    cp -f ./Frpc/frpc.ini ./Example_Frpc_Windows64/frpc.ini
fi

echo "⚙️ Script Version: 2.4"

if [ "${FRP_MODE}" == "1" ]; then
    echo "👀 Learn More: https://github.com/fatedier/frp"
    echo "✅ Starting Frps"
    ./Frps/frps -c ./Frps/frps.ini
else
    echo "👀 Learn More: https://github.com/fatedier/frp"
    echo "✅ Starting Frpc"
    ./Frpc/frpc -c ./Frpc/frpc.ini
fi
