#!/bin/bash
if [[ -d "./ffmpeg-commander/public" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/FFmpeg/version.sh)
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/FFmpeg/launch.sh)
else
    git clone https://github.com/Ashu11-A/ffmpeg-commander-Egg
    mv ffmpeg-commander-Egg ffmpeg-commander
    fakeroot chmod 775 ./*
    (
        cd ffmpeg-commander || exit
        npm install
        npm audit fix
    )
fi
