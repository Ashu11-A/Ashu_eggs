#!/bin/bash
if [[ -d "./public" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/FFmpeg/version.sh)
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/FFmpeg/launch.sh)
else
    git clone https://github.com/alfg/ffmpeg-commander .
    npm install
fi
