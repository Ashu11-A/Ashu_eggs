#!/bin/bash
apt -y --no-install-recommends install wget unzip lib32gcc1 ca-certificates

mkdir -p /mnt/server
cd /mnt/server || exit

wget "https://github.com/Ashu11-A/Ashu_eggs/raw/main/Minecraft/Pocketmine-MP%20(0.15.10)/PocketMine-MP.phar"
wget "https://github.com/Ashu11-A/Ashu_eggs/raw/main/Minecraft/Pocketmine-MP%20(0.15.10)/bin.zip"

unzip bin.zip
chown -R root:root /mnt
chmod 777 -R ./*

rm -rf bin.zip
export HOME=/mnt/server