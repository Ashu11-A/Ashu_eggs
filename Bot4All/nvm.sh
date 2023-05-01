#!/bin/bash
# shellcheck source=/dev/null
source "/home/container/.nvm/nvm.sh"

printf "\n \n📝  Qual versão do nodejs você deseja utilizar (12, 14, 16, 18...) (pressione [ENTER]): \n \n"
read -r VERSION
if [[ "$VERSION" == "12" ]]; then
    export version="12.22.9"
elif [[ "$VERSION" == "14" ]]; then
    export version="14.21.3"
elif [[ "$VERSION" == "16" ]]; then
    export version="16.20.0"
elif [[ "$VERSION" == "18" ]]; then
    export version="18.16.0"
elif [[ "$VERSION" == "20" ]]; then
    export version="20.0.0"
else
    printf "\n \n🥶 Versão não encontrada, usando a versão 18\n \n"
    version="18.16.0"
fi
echo "$VERSION" >logs/nodejs_version
printf "\n \n👍  Blz, salvei a versão (v%s) aqui!\n \n" "$VERSION"
echo -e "\n \n🫵  Você pode alterar a versão usando o comando: ${bold}${lightblue}version.\n \n"

if [[ -f "logs/nodejs_version" ]]; then

    if [ -n "${versions}" ]; then
        nvm install "${version}"
        nvm use "${version}"
    else
        printf "\n \n⚠️  Versão não identificada, usando nvm padrão (v18).\n \n"
        nvm install "18.16.0"
        nvm use "18.16.0"
    fi
fi
