#!/bin/bash
while true; do
    start="$(cat logs/start-conf)"
    (
        
        node ${start} >log_egg.txt 2>&1

        npm start >log_egg.txt 2>&1

        sleep 1
    )
done
