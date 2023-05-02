#!/bin/bash
while true
do

    start="$(cat ../logs/start-conf)"
    node ${start} >nohup.out

    npm start >nohup.out

    sleep 1
done
