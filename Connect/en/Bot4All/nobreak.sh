#!/bin/bash
count=0
while [ $count -lt "$BREAK_NUMBER" ]; do
    start="$(cat logs/start-conf)"
    # Verifica se o conteúdo é um arquivo existente
    if [ -f "$start" ]; then
        # Verifica se o arquivo é um arquivo JavaScript (.js)
        if [[ "$start" == *.js ]]; then
            node "$start" >> logs/run.log 2>&1
            sleep 1
        fi
    elif [[ "$start" == "npm run"* ]] || [[ "$start" == "node"* ]]; then
        $start >> logs/run.log 2>&1
    fi
done