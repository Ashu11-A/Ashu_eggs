#!/bin/bash
while true
do

    start="$(cat logs/start-conf)"
    (
        cd "./[seu_bot]" || exit
        node ${start}

        npm start
    )

    sleep 1
done
