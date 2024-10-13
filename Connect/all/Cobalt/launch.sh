#!/bin/bash

if [ "$SERVER_IP" = "0.0.0.0" ]; then
    MGM=$(printf "$on_port" "$SERVER_PORT")
else
    MGM=$(printf "$on_ip_port" "$SERVER_IP" "$SERVER_PORT")
fi

printf "$web_interface_starting\n" "$MGM"

npm start