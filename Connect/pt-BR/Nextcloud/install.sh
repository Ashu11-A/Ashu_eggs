#!/bin/ash

if [ ! -d "/home/container" ]; then
    apk add bash
fi

if [ -f "./launch.sh" ]; then
  rm ./launch.sh
fi

curl -sO https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Nextcloud/launch.sh
chmod +x launch.sh
bash ./launch.sh