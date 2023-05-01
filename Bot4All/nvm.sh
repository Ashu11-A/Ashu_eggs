#!/bin/bash
# shellcheck source=/dev/null
source "/home/container/.nvm/nvm.sh"

if [[ -f "logs/nodejs_version" ]]; then

    versions="$(cat logs/nodejs_version)"

    if [[ "$versions" == "12" ]]; then
        version="12.22.9"
    elif [[ "$versions" == "14" ]]; then
        version="14.21.3"
    elif [[ "$versions" == "16" ]]; then
        version="16.20.0"
    elif [[ "$versions" == "18" ]]; then
        version="18.16.0"
    elif [[ "$versions" == "10" ]]; then
        version="20.0.0"
    else
        echo "🥶 Versão não encontrada, usando a versão 18"
        version="18.16.0"
    fi

    if [ -n "${versions}" ]; then
        nvm install "${version}"
        nvm use "${version}"
        node --version
    else
        echo "⚠️  Versão não identificada, usando nvm padrão (v18)."
        nvm install "18.16.0"
        nvm use "18.16.0"
    fi
fi
