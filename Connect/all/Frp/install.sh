#!/bin/bash

GITHUB_PACKAGE=fatedier/frp
LATEST_JSON=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq -c '.[]' | head -1)
RELEASES=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq '.[]')
ARCH=$([ "$(uname -m)" == "x86_64" ] && echo "amd64" || echo "arm64")

if [ "${ARCH}" == "arm64" ]; then
  if [ -z "$VERSION" ] || [ "$VERSION" == "latest" ]; then
    echo -e "$defaulting_latest"
    DOWNLOAD_LINK=$(echo "$LATEST_JSON" | jq .assets | jq -r .[].browser_download_url | grep -i frp | grep -i linux | grep -i arm64)
  else
    VERSION_CHECK=$(echo "$RELEASES" | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .tag_name')
    if [ "$VERSION" == "$VERSION_CHECK" ]; then
        DOWNLOAD_LINK=$(echo "$RELEASES" | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .assets[].browser_download_url' | grep -i frp | grep -i linux | grep -i arm64)
    else
        echo -e "$defaulting_latest"
        DOWNLOAD_LINK=$(echo "$LATEST_JSON" | jq .assets | jq -r .[].browser_download_url | grep -i frp | grep -i linux | grep -i arm64)
    fi
  fi
else
  if [ -z "$VERSION" ] || [ "$VERSION" == "latest" ]; then
    echo -e "$defaulting_latest"
    DOWNLOAD_LINK=$(echo "$LATEST_JSON" | jq .assets | jq -r .[].browser_download_url | grep -i frp | grep -i linux | grep -i amd64)
  else
    VERSION_CHECK=$(echo "$RELEASES" | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .tag_name')
    if [ "$VERSION" == "$VERSION_CHECK" ]; then
      DOWNLOAD_LINK=$(echo "$RELEASES" | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .assets[].browser_download_url' | grep -i frp | grep -i linux | grep -i amd64)
    else
      echo -e "$defaulting_latest"
      DOWNLOAD_LINK=$(echo "$LATEST_JSON" | jq .assets | jq -r .[].browser_download_url | grep -i frp | grep -i linux | grep -i amd64)
    fi
  fi
fi

if [[ -f "./Frps/frps" ]]; then
  mkdir -p Frp_OLD
  mv ./* Frp_OLD
else
    echo "$clean_install"
fi

if [ "${SERVER_IP}" = "0.0.0.0" ]; then
  IP="toque-me.com.br"
else
  IP="${SERVER_IP}"
fi

mkdir -p logs

printf "$log_install" "${VERSION}" "${DOWNLOAD_LINK}" "${DOWNLOAD_LINK##*/}" >./logs/log_install.txt

    printf "$running_curl\n" "${DOWNLOAD_LINK}" "${DOWNLOAD_LINK##*/}"
    curl -sSL "${DOWNLOAD_LINK}" -o "${DOWNLOAD_LINK##*/}"
    echo -e "$unpacking_files"
    tar -xvzf "${DOWNLOAD_LINK##*/}"
    cp -R frp*/* ./
    rm -rf frp*linux*
    rm -rf "${DOWNLOAD_LINK##*/}"
    rm -f frps.toml frpc.toml

    # Baixa os arquivos de configuração TOML
    mkdir -p Frpc
    curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Frp/frpc.toml -o Frpc/frpc.toml

    mkdir -p Frps
    curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Frp/frps.toml -o Frps/frps.toml

    mv frps ./Frps/
    mv frpc ./Frpc/

    curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Frp/exemple.sh -o exemple.sh
    chmod a+x ./exemple.sh
    ./exemple.sh

    echo -e "$installation_complete"
exit 0
