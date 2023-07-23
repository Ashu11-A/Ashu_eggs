#!/bin/bash
count=0
while [ $count -lt 10 ]; do
    start="$(cat logs/start-conf)"
    # Verifica se o conteúdo é um arquivo existente
    if [ -f "$start" ]; then
        # Verifica se o arquivo é um arquivo JavaScript (.js)
        if [[ "$start" == *.js ]]; then
            node ${start} >log_egg.txt 2>&1
            sleep 1
        fi
    elif [[ "$start" == "npm run"* ]] || [[ "$start" == "node"* ]]; then
        $start >log_egg.txt 2>&1
        sleep 1
    fi
    count=$((count + 1))
    echo -e "\n \n📢  Bot quebrou! numero da tentativa: $count  \n \n"
done