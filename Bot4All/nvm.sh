#!/bin/bash
# shellcheck source=/dev/null
source "/usr/local/bin/nvm.sh"

if [[ -f "logs/nodejs_version" ]]; then

    versions="$(cat logs/nodejs_version)"

    if [ -n "${versions}" ]; then
        echo "✅  Usando versão: v${versions}"
        nvm install "${versions}"
        nvm use "${versions}"
        node --version
    else
        echo "⚠️  Versão não identificada, usando nvm padrão (v18)."
        nvm use default
        node --version
    fi
fi
