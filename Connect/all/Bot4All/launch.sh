#!/bin/bash
bold=$(echo -en "\e[1m")
lightblue=$(echo -en "\e[94m")
normal=$(echo -en "\e[0m")

echo -e "\n \n$installed_packages\n \n"

if [ "$SERVER_IP" = "0.0.0.0" ]; then
    MGM=$(printf "$on_port" "$SERVER_PORT")
else
    MGM=$(printf "$on_ip_port" "$SERVER_IP" "$SERVER_PORT")
fi

printf "$running\n" "$MGM"

(
    if [ -n "$GIT_ADDRESS" ] && [ -d .git ] || [ "$AUTO_UPDATE" == "1" ]; then
        echo "${executing}: git pull"
        git pull
    fi
    if [[ ! -z $NODE_PACKAGES ]]; then
        npm install $NODE_PACKAGES
    fi

    if [[ ! -z $UNNODE_PACKAGES ]]; then
        npm uninstall $UNNODE_PACKAGES
    fi
    if [ ! -d "./node_modules" ]; then
        if [ -f ./package.json ]; then
            npm install
        fi
    fi
)

printf "$available_commands\n" "${bold}${lightblue}help ${normal}, ${bold}${lightblue}start ${normal}, ${bold}${lightblue}show ${normal}, ${bold}${lightblue}version ${normal}, ${bold}${lightblue}npm ${normal}[your code], ${bold}${lightblue}node ${normal}[your code], ${bold}${lightblue}lang${normal}."

echo -e "\n \n$initializing_anti_crash\n \n"
nohup curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Bot4All/nobreak.sh" -o /tmp/nobreak.sh && bash /tmp/nobreak.sh &

while read -r line; do
    if [[ "$line" == "help" ]]; then
        echo -e "$available_commands_header"
        echo -e "$command_list"
    elif [[ "$line" == *"npm"* ]]; then
        echo -e "\n \n${executing}: \n \n"
        (
            eval "$line"
        )
        echo -e "\n \n$command_executed\n \n"
    elif [[ "$line" == *"node"* ]]; then
        echo -e "\n \n${executing}: \n \n"
        (
            eval "$line"
        )
        echo -e "\n \n$command_executed\n \n"
    elif [[ "$line" == "show" ]]; then
        echo -e "\n \n${executing}: \n \n"
        (
            eval "tail -F logs/run.log"
        )
        echo -e "\n \n$command_executed\n \n"
    elif [[ "$line" == *"version"* ]]; then
        if [ -z "$NVM_STATUS" ] || [ "$NVM_STATUS" = "1" ]; then
            curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/nvm.sh" -o /tmp/nvm.sh && bash /tmp/nvm.sh --select
            exit
            exit
        else
            echo -e "\n \n$nvm_disabled\n \n"
        fi
    elif [[ "$line" == *"start"* ]]; then
        echo -e "\n \n$start_command_prompt\n \n"
        read -r START
        echo "$START" >logs/start-conf
        printf "$saved_start_command\n" "($START)"
        pritnf "$change_start_command\n" "start"
        exit
        exit
    elif [[ "$line" == "lang" ]]; then
        source <(curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/lang.sh")
    else
        echo "$invalid_command"
    fi
done