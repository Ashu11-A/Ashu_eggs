#!/bin/bash
count=0
while [ $count -lt 10 ]; do
    start="$(cat logs/start-conf)"
    if [ "$(cat logs/start-ini)" = "1" ]; then
        node ${start} >log_egg.txt 2>&1
        npm start >log_egg.txt 2>&1
        sleep 1
    else
        $start >log_egg.txt 2>&1
    fi
    count=$((count+1))
    echo -e "\n \n📢  Bot quebrou! numero da tentativa: $count  \n \n"
done
