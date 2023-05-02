#!/bin/bash
while true
do

    start="$(cat ../logs/start-conf)"
    node ${start} >log_egg.txt

    npm start >log_egg.txt

    sleep 1
done
