#!/bin/bash
while true
do

    start="$(cat logs/start-conf)"
    node ${start}

    npm start

    sleep 1
done
