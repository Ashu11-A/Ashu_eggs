#!/bin/bash

if [ -d "Logs" ]; then
    mv Logs logs
fi

bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Zipline/install.sh) | tee logs/terminal.log
