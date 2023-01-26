#!/bin/bash
ARCH=$([ "$(uname -m)" == "x86_64" ] && echo "amd64" || echo "arm64")

if [ "${ARCH}" == "amd64" ];
then
    echo "🔎 Arquitetura Identificada: 64x"
    if [[ -f "./mta-server64" ]]; then
        echo "⚙️ Versão do Script: 1.3"
        echo "✅ Iniciando MTA"
        ./mta-server64 -n
    else
        echo "MTA Não Instalado, isso é realmente muito estranho, essa é uma segunda verificação."
    fi
else
    echo "🔎 Arquitetura Identificada: ARM64"
    echo "⚠️ Atenção: Este Egg ainda não funciona no ARM64"
    if [[ -f "./mta-server64" ]]; then
        echo "⚙️ Versão do Script: 1.3"
        echo "✅ Iniciando MTA"
        ./mta-server64 -n
    else
        echo "MTA Não Instalado, isso é realmente muito estranho, essa é uma segunda verificação."
    fi
fi