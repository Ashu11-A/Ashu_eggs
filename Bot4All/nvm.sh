#!/bin/bash

if [[ -f "logs/nodejs_version" ]]; then

    versions=" $(cat ../nodejs_version) "

    if [ -z "${versions}" ]; then
        echo "✅  Usando versão: v${versions}"
        nvm install "${versions}"
        nvm use "${versions}"
        node --version
    else
        echo "⚠️  Versão não identificada, usando v18."
        nvm install 18
        nvm use 18
        node --version
    fi
fi
