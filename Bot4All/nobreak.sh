#!/bin/bash
while true
do

    start="$(cat ../logs/start-conf)"
    node ${start} >log.txt

    npm start >log.txt

    sleep 1
done
