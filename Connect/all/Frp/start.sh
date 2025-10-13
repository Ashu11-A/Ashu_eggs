#!/bin/bash

export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Lang/frp.conf"
curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/loadLang.sh -o loadLang.sh

if [[ ! -f "./Frps/frps" || ! -f "./Frpc/frpc" ]]; then
  echo "en" > logs/language.conf

  source ./loadLang.sh
  set -a

  curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Frp/install.sh -o install.sh
  chmod a+x ./install.sh
  ./install.sh

  rm ./logs/language.conf
  exit
fi

# update please

source ./loadLang.sh
set -a

if [[ -f "./exemple.sh" ]]; then 
  ./exemple.sh
fi

curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Frp/launch.sh -o launch.sh
chmod a+x ./launch.sh
./launch.sh