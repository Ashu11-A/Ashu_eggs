#!/bin/bash
echo -e "\n \n🔎  Pacotes Instalados: 
jq file unzip wget ncurses tar
sqlite3 libsqlite3-dev python3
libressl-dev nvm node npm bash
build-base ca-certificates zip
iproute2 tzdata curl git lolcat
python3-dev libtool iputils-ping
ffmpeg tesseract figlet dnsutils
libgconf-2-4 libatk1.0-0 libgtk-3-0
libatk-bridge2.0-0 libgdk-pixbuf2.0-0 
libgbm-dev libnss3-dev libxss-dev \n \n"

if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="on port ${SERVER_PORT}"
else
    MGM="at ${SERVER_IP}:${SERVER_PORT}"
fi
echo "🟢  I am running ${MGM}..."

(
    if [ -n "${GIT_ADDRESS}" ] && [ -d .git ] || [ "${AUTO_UPDATE}" == "1" ]; then
        echo "Running: git pull"
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

echo -e "\n \n🔒  Initializing fail-safe system...\n \n"
nohup bash <(curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/Bot4All/nobreak.sh") &

while read -r line; do
    if [[ "$line" == "help" ]]; then
        echo "👀  Available Commands:"
        echo "
+---------+---------------------------+
| Command | What It Does              |
+---------+---------------------------+
| version | Change Nodejs version     |
| start   | Change Bot Initialization |
| show    | Show bot logs             |
| npm     | Run any npm command       |
| node    | Run any nodejs command    |
+---------+---------------------------+
"
        echo -e "\n \nRunning: ${bold}${lightblue}${line}\n \n"
    elif [[ "$line" == *"npm"* ]]; then
        (

            eval "$line"
        )
        echo -e "\n \n✅  Command Executed\n \n"
        echo -e "\n \nRunning: ${bold}${lightblue}${line}\n \n"
    elif [[ "$line" == *"node"* ]]; then
        (

            eval "$line"
        )
        echo -e "\n \n✅  Command Executed\n \n"
    elif [[ "$line" == "show" ]]; then
        echo -e "\n \nRunning: ${bold}${lightblue}${line}\n \n"
        (

            eval "tail -F logs/run.log"
        )
        echo -e "\n \n✅  Command Executed\n \n"
    elif [[ "$line" == *"version"* ]]; then
        if [ -z "${NVM_STATUS}" ] || [ "${NVM_STATUS}" = "1" ]; then
            if [[ -d ".nvm" ]]; then
                bash <(curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/Bot4All/nvm_install.sh")
                exit
                exit
            else
                echo -e "\n \n⚠️  NVM not installed, server needs to be reinstalled...\n \n"
            fi
        else
            printf "\n \n📢  NVM is disabled! You cannot change the Nodejs version, enable it and reinstall the server. \n \n"
        fi
    elif [[ "$line" == *"start"* ]]; then
        echo -e "\n \n📝  What is the startup command/file you want to use? (EX: bot.js, npm run start...) (press [ENTER]): \n \n"
        read -r START
        echo "$START" >logs/start-conf
        echo -e "\n \n👌  OK, I've saved ($START) here!\n"
        echo -e "🫵  You can change this using the command: ${bold}${lightblue}start\n \n"
        exit
        exit
        echo -e "\n \nInvalid Command. What are you trying to do? Try something with ${bold}${lightblue}help${normal}, ${bold}${lightblue}version${normal}, ${bold}${lightblue}start-conf${normal}, ${bold}${lightblue}show${normal}, ${bold}${lightblue}npm ${normal}or ${bold}${lightblue}node.\n \n"
    elif [[ "$line" != *"npm"* ]] || [[ "$line" != *"node"* ]] || [[ "$line" != *"show"* ]] || [[ "$line" != *"version"* ]] || [[ "$line" != *"start"* ]]; then
    else
        echo "Script Failed."
    fi
done

: <<'LIMBO'
start="$(cat logs/start-conf)"
(
    
    nohup node ${start} >logs/run.log 2>&1 &

    pid=$!
    sleep 5

    if ps -p $pid >/dev/null; then
        echo "✅  Server started successfully!"
    else
        echo "⛔️  Error starting server with nodejs! Trying to use npm."
        nohup npm start >logs/run.log &

        pid=$!
        sleep 5
        if ps -p $pid >/dev/null; then
            echo "✅  Server started successfully!"
        else
            echo "⛔️  Error starting server with npm and nodejs!"
        fi
    fi
)
LIMBO
