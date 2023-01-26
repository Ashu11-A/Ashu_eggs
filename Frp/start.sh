#!/bin/bash
if [ "${FRP_MODE}" == "1" ]; then
    echo "⊝ Versão do Script: 1.0"
    echo "✓ Iniciando Frps"
    ./frps -c ./frps.ini
else
    echo "✓ Iniciando Frpc"
    ./frpc -c ./frpc.ini
fi