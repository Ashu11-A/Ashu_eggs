#!/bin/bash

if [ "$SERVER_IP" = "0.0.0.0" ]; then
    MGM=$(printf "$on_port" "$SERVER_PORT")
else
    MGM=$(printf "$on_ip_port" "$SERVER_IP" "$SERVER_PORT")
fi

printf "$web_interface_starting\n" "$MGM"

(
    cd api || exit
    touch nohup.out
    nohup npm run start 2>&1 &
)

(
    cd web
    npm run dev -- --port $SERVER_PORT --host 0.0.0.0
)