#!/bin/bash
while true; do
    start="$(cat logs/start-conf)"
    (
        npm config set prefix /home/container/[seu_bot]/.npm
        cd "./[seu_bot]" || exit
        node ${start} >log_egg.txt 2>&1

        npm start >log_egg.txt 2>&1

        sleep 1
    )
done
