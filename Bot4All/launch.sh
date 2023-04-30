#!/bin/bash
bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
normal=$(echo -en "\e[0m")

bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Bot4All/nvm.sh)

echo "🔎  Pacotes Instalados: iproute2, tzdata, curl, coreutils, git, jq, file, unzip, make, gcc, g++, python3, python3-dev, libtool, nodejs, nodejs-lts, ffmpeg, wget, py3-pip, ncurses, bash e nvm"

if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="na porta ${SERVER_PORT}"
else
    MGM="em ${SERVER_IP}:${SERVER_PORT}"
fi
echo "🟢  Estou rodando ${MGM}..."

if [[ -d .git ]] || [[ {{AUTO_UPDATE}} == "1" ]]; then
    echo "Executando: git pull"
    git pull
fi

if [[ ! -z ${NODE_PACKAGES} ]]; then
    /usr/local/bin/npm install ${NODE_PACKAGES}
fi

if [[ ! -z ${UNNODE_PACKAGES} ]]; then
    /usr/local/bin/npm uninstall ${UNNODE_PACKAGES}
fi

if [ -f /home/container/package.json ]; then
    /usr/local/bin/npm install
fi

if [ ! -f "../nodejs_version" ]; then
    echo -n "📝  Qual versão do nodejs você deseja utilizar (12, 14, 16, 18...) (pressione [ENTER]): "
    read VERSION
    echo "$VERSION" >../nodejs_version
    echo "👌  OK, salvei a versão (v$VERSION) aqui!"
    echo "🫵  Você pode alterar a versão usando o comando: ${bold}${lightblue}version"
fi

nohup /usr/local/bin/node /home/container/${BOT_JS_FILE} 2>&1 &

echo "📃  Comandos Disponíveis: ${bold}${lightblue}help ${normal}, ${bold}${lightblue}version ${normal}, ${bold}${lightblue}npm ${normal}[your code] ou ${bold}${lightblue}node ${normal}[your code]..."

while read -r line; do
    if [[ "$line" == "help" ]]; then
        echo "👀  Comandos Disponíveis:"
        echo "
+-----------+---------------------------------------+
| Comando   |  O que Faz                            |
+-----------+---------------------------------------+
| version   |  Troca a versão do Nodejs             |
| npm       |  Executa qualquer comando do npm      |
| node      |  Executa qualquer comando do nodejs   |
+-----------+---------------------------------------+
        "
    elif [[ "$line" == *"npm"* ]]; then
        echo "Executando: ${bold}${lightblue}${line}"
        eval "$line"
        printf "\n \n✅  Comando Executado\n \n"
    elif [[ "$line" == *"node"* ]]; then
        echo "Executando: ${bold}${lightblue}${line}"
        eval "$line"
        printf "\n \n✅  Comando Executado\n \n"
    elif [[ "$line" == *"version"* ]]; then
        echo -n "📝  Qual versão do nodejs você deseja utilizar (12, 14, 16, 18...) (pressione [ENTER]): "
        read VERSION
        echo "$VERSION" >../nodejs_version
        echo "👌  OK, salvei a versão (v$VERSION) aqui!"
        exit
    elif [[ "$line" != *"npm"* ]]; then
        echo "Comando Inválido. O que você está tentando fazer? Tente algo com ${bold}${lightblue}npm ${normal}ou ${bold}${lightblue}node."
    else
        echo "Script Falhou."
    fi
done
