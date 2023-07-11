#!/bin/bash
ARCH=$([ "$(uname -m)" == "x86_64" ] && echo "amd64" || echo "arm64")

if [ "${ARCH}" == "arm64" ];
then
bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/vps/ARM64/installer.sh)
else 
bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/vps/64x/installer.sh)
fi