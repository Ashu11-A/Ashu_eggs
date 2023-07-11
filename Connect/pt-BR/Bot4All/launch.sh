#!/bin/bash
echo -e "\n \n🔎  Pacotes Instalados: 
jq file unzip wget ncurses tar
sqlite3 libsqlite3-dev python3
libressl-dev nvm node npm bash
build-base ca-certificates zip
iproute2 tzdata curl git lolcat
python3-dev libtool iputils-ping
ffmpeg tesseract figlet dnsutils\n \n"

if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="na porta ${SERVER_PORT}"
else
    MGM="em ${SERVER_IP}:${SERVER_PORT}"
fi
echo "🟢  Estou rodando ${MGM}..."

(
    if [ -n "${GIT_ADDRESS}" ] && [ -d .git ] || [ "${AUTO_UPDATE}" == "1" ]; then
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

echo -e "\n \n📃  Comandos Disponíveis: ${bold}${lightblue}help ${normal}, ${bold}${lightblue}start ${normal}, ${bold}${lightblue}show ${normal}, ${bold}${lightblue}version ${normal}, ${bold}${lightblue}npm ${normal}[your code] ou ${bold}${lightblue}node ${normal}[your code]...\n \n"

echo -e "\n \n🔒  Sistema antiqueda inicializando...\n \n"
nohup bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/Bot4All/nobreak.sh) &

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

            eval "$line"
        )
        echo -e "\n \n✅  Comando Executado\n \n"
    elif [[ "$line" == *"node"* ]]; then
        echo -e "\n \nExecutando: ${bold}${lightblue}${line}\n \n"
        (

            eval "$line"
        )
        echo -e "\n \n✅  Comando Executado\n \n"
    elif [[ "$line" == "show" ]]; then
        echo -e "\n \nExecutando: ${bold}${lightblue}${line}\n \n"
        (

            eval "tail -n 40 log_egg.txt"
        )
        echo -e "\n \n✅  Comando Executado\n \n"
    elif [[ "$line" == *"version"* ]]; then
        if [ -z "${NVM_STATUS}" ] || [ "${NVM_STATUS}" = "1" ]; then
            if [[ -d ".nvm" ]]; then
                bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/Bot4All/nvm_install.sh)
                exit
                exit
            else
                echo -e "\n \n⚠️  NVM não instalado, será necessario reinstalar o servidor...\n \n"
            fi
        else
            printf "\n \n📢  NVM está desativado! você não poderá trocar a versão do Nodejs, ative ele e reinstale o servidor. \n \n"
        fi
    elif [[ "$line" == *"start"* ]]; then
        echo -e "\n \n📝  Qual o tipo de inicialização que você deseja utilizar?\n [1]: Expecificar somente o arquivo (EX: bot.js)\n (funcionará assim: node MEU_ARQUIVO.sh)\n [2]: Inicialição por comando (EX: npm run start) (pressione [ENTER]): \n \n"
        while read -r START; do
            if [[ "$START" =~ ^(1|2)$ ]]; then
                echo "$START" >logs/start-ini
                if [ -f "logs/start-set" ]; then
                    rm logs/start-set
                fi
                echo -e "\n \n👌  OK, salvei ($START) aqui!\n"
                echo -e "🫵  Você pode alterar isso usando o comando: ${bold}${lightblue}start\n \n"
                exit
            else
                echo -e "\n \n😅  Por favor, selecione a forma de inicialização com 1 ou 2\n \n"
            fi
        done
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
