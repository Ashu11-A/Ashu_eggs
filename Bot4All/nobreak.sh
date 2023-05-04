#!/bin/bash
count=0
while [ $count -lt 10 ]; do
    start="$(cat logs/start-conf)"
    (
        node ${start} >log_egg.txt 2>&1
        npm start >log_egg.txt 2>&1
        sleep 1
    )
    count=$((count+1))
done
