#!/bin/bash
bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
normal=$(echo -en "\e[0m")

if [ ! -f "logs/nodejs_version" ]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Bot4All/nvm.sh)
fi

printf "\n \n🔎  Pacotes Instalados: 
ffmpeg tesseract
iproute2 tzdata curl git
jq file unzip wget ncurses
build-base ca-certificates 
libressl-dev nvm node npm bash\n \n"

if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="na porta ${SERVER_PORT}"
else
    MGM="em ${SERVER_IP}:${SERVER_PORT}"
fi
echo "🟢  Estou rodando ${MGM}..."

(
    cd "./[seu_bot]" || exit

    if [[ -d .git ]] || [[ {{AUTO_UPDATE}} == "1" ]]; then
        echo "Executando: git pull"
        git pull
    fi
    if [[ ! -z ${NODE_PACKAGES} ]]; then
        npm install ${NODE_PACKAGES}
    fi

    if [[ ! -z ${UNNODE_PACKAGES} ]]; then
        npm uninstall ${UNNODE_PACKAGES}
    fi

    if [ -f ./.package.json ]; then
        npm install
    fi
)

echo -e "\n \n📃  Comandos Disponíveis: ${bold}${lightblue}help ${normal}, ${bold}${lightblue}version ${normal}, ${bold}${lightblue}npm ${normal}[your code] ou ${bold}${lightblue}node ${normal}[your code]...\n \n"

start="$(cat logs/start-conf)"
(
    cd "./[seu_bot]" || exit
    nohup node "${start}" 2>&1 &
)

while read -r line; do
    if [[ "$line" == "help" ]]; then
        echo "👀  Comandos Disponíveis:"
        echo "
+------------+---------------------------------------+
| Comando    |  O que Faz                            |
+------------+---------------------------------------+
| version    |  Troca a versão do Nodejs             |
| start-conf |  Troca a Inicialização do bot         |
| npm        |  Executa qualquer comando do npm      |
| node       |  Executa qualquer comando do nodejs   |
+------------+---------------------------------------+
        "
    elif [[ "$line" == *"npm"* ]]; then
        echo "Executando: ${bold}${lightblue}${line}"
        (
            cd "./[seu_bot]" || exit
            eval "$line"
        )
        printf "\n \n✅  Comando Executado\n \n"
    elif [[ "$line" == *"node"* ]]; then
        echo "Executando: ${bold}${lightblue}${line}"
        (
            cd "./[seu_bot]" || exit
            eval "$line"
        )
        printf "\n \n✅  Comando Executado\n \n"
    elif [[ "$line" == *"version"* ]]; then
        bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Bot4All/nvm.sh)
        exit 0
    elif [[ "$line" == *"start-conf"* ]]; then
        echo -n "📝  Qual é o arquivo de inicialização que você deseja utilizar? (bot.js, index.js...) (pressione [ENTER]): "
        read START
        echo "$START" >logs/start-conf
        echo "👌  OK, salvei ($START) aqui!"
        exit 0
    elif [[ "$line" != *"npm"* ]]; then
        echo "Comando Inválido. O que você está tentando fazer? Tente algo com ${bold}${lightblue}npm ${normal}ou ${bold}${lightblue}node."
    else
        echo "Script Falhou."
    fi
done
