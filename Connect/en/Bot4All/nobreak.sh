#!/bin/bash
count=0
while [ $count -lt 10 ]; do
    start="$(cat logs/start-conf)"
    if [ "$(cat logs/start-ini)" = "1" ]; then
        node ${start} >> logs/run.log 2>&1
        npm start >> logs/run.log 2>&1
        sleep 1
    else
        $start >> logs/run.log 2>&1
    fi
    count=$((count+1))
    echo -e "\n \n📢  Bot crashed! attempt number: $count  \n \n"
done
