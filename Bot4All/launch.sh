#!/bin/bash
bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
normal=$(echo -en "\e[0m")

echo -e "\n \n🔎  Pacotes Instalados: 
ffmpeg tesseract figlet
iproute2 tzdata curl git
jq file unzip wget ncurses
build-base ca-certificates lolcat
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
    if [ ! -d "./node_modules" ]; then
        if [ -f ./package.json ]; then
            npm install
        fi
    fi
)

echo -e "\n \n📃  Comandos Disponíveis: ${bold}${lightblue}help ${normal}, ${bold}${lightblue}show ${normal}, ${bold}${lightblue}version ${normal}, ${bold}${lightblue}npm ${normal}[your code] ou ${bold}${lightblue}node ${normal}[your code]...\n \n"

echo -e "\n \n🔒  Sistema antiqueda inicializando...\n \n"
nohup bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Bot4All/nobreak.sh) 2>&1 &

while read -r line; do
    if [[ "$line" == "help" ]]; then
        echo "👀  Comandos Disponíveis:"
        echo "
+------------+---------------------------------------+
| Comando    |  O que Faz                            |
+------------+---------------------------------------+
| version    |  Troca a versão do Nodejs             |
| start      |  Troca a Inicialização do bot         |
| show       |  Mostra as logs do bot                |
| npm        |  Executa qualquer comando do npm      |
| node       |  Executa qualquer comando do nodejs   |
+------------+---------------------------------------+
        "
    elif [[ "$line" == *"npm"* ]]; then
        echo -e "\n \nExecutando: ${bold}${lightblue}${line}\n \n"
        (
            cd "./[seu_bot]" || exit
            eval "$line"
        )
        echo -e "\n \n✅  Comando Executado\n \n"
    elif [[ "$line" == *"node"* ]]; then
        echo -e "\n \nExecutando: ${bold}${lightblue}${line}\n \n"
        (
            cd "./[seu_bot]" || exit
            eval "$line"
        )
        echo -e "\n \n✅  Comando Executado\n \n"
    elif [[ "$line" == "show" ]]; then
        echo -e "\n \nExecutando: ${bold}${lightblue}${line}\n \n"
        (
            cd "./[seu_bot]" || exit
            eval "tail -n 40 log_egg.txt"
        )
        echo -e "\n \n✅  Comando Executado\n \n"
    elif [[ "$line" == *"version"* ]]; then
        bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Bot4All/nvm_install.sh)
        exit
        exit
    elif [[ "$line" == *"start"* ]]; then
        printf "\n \n📝  Qual é o arquivo de inicialização que você deseja utilizar? (bot.js, index.js...) (pressione [ENTER]): \n \n"
        read -r START
        echo "$START" >logs/start-conf
        echo "👌  OK, salvei ($START) aqui!"
        exit
        exit
    elif [[ "$line" != *"npm"* ]] || [[ "$line" != *"node"* ]] || [[ "$line" != *"show"* ]] || [[ "$line" != *"version"* ]] || [[ "$line" != *"start"* ]]; then
        echo -e "\n \nComando Inválido. O que você está tentando fazer? Tente algo com ${bold}${lightblue}help${normal}, ${bold}${lightblue}version${normal}, ${bold}${lightblue}start-conf${normal},${bold}${lightblue}show${normal},${bold}${lightblue}npm ${normal}ou ${bold}${lightblue}node.\n \n"
    else
        echo "Script Falhou."
    fi
done

: <<'LIMBO'
start="$(cat logs/start-conf)"
(
    cd "./[seu_bot]" || exit
    nohup node ${start} >log_egg.txt 2>&1 &

    pid=$!
    sleep 5

    if ps -p $pid >/dev/null; then
        echo "✅  Servidor iniciado com sucesso!"
    else
        echo "⛔️  Erro ao iniciar o servidor com nodejs! Tentando usar npm."
        nohup npm start >log_egg.txt &

        pid=$!
        sleep 5
        if ps -p $pid >/dev/null; then
            echo "✅  Servidor iniciado com sucesso!"
        else
            echo "⛔️  Erro ao iniciar o servidor com npm e nodejs!"
        fi
    fi
)
LIMBO
