#!/bin/bash
if [[ -f "./mta-server64" ]]; then
    echo "⚙️ Versão do Script: 1.0"
    echo "✅ Iniciando MTA"
    ./mta-server64 -n
else
    echo "MTA Não Instalado, isso é realmente muito estranho, essa é uma segunda verificação."
fi