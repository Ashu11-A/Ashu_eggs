#!/bin/bash

if [[ $INSTALL_EX != "1" ]]; then
  exit
fi

cp -f ./Frpc/frpc.toml ./ExampleFrpc_Windows/frpc.toml
cp -f ./Frpc/frpc.toml ./ExampleFrpc_Linux/frpc.toml

if [[ -d "ExampleFrpc_Windows" || -d "ExampleFrpc_Linux" ]]; then
  exit
fi

echo "$preparing_examples"

GITHUB_PACKAGE=fatedier/frp
LATEST_JSON=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq -c '.[]' | head -1)
RELEASES=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq '.[]')

mkdir -p ExampleFrpc_Windows
mkdir -p ExampleFrpc_Linux
mkdir -p logs

# Determina os links de download para Windows e Linux (amd64)
if [ -z "$VERSION" ] || [ "$VERSION" == "latest" ]; then
  echo "$using_latest_version"
  DOWNLOAD_LINK_W=$(echo "$LATEST_JSON" | jq .assets | jq -r .[].browser_download_url | grep -i frp | grep -i windows | grep -i amd64)
  DOWNLOAD_LINK_L=$(echo "$LATEST_JSON" | jq .assets | jq -r .[].browser_download_url | grep -i frp | grep -i linux | grep -i amd64)
else
  VERSION_CHECK=$(echo "$RELEASES" | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .tag_name')
  if [ "$VERSION" == "$VERSION_CHECK" ]; then
    DOWNLOAD_LINK_W=$(echo "$RELEASES" | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .assets[].browser_download_url' | grep -i frp | grep -i windows | grep -i amd64)
    DOWNLOAD_LINK_L=$(echo "$RELEASES" | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .assets[].browser_download_url' | grep -i frp | grep -i linux | grep -i amd64)
  else
    echo "$version_not_found"
    DOWNLOAD_LINK_W=$(echo "$LATEST_JSON" | jq .assets | jq -r .[].browser_download_url | grep -i frp | grep -i windows | grep -i amd64)
    DOWNLOAD_LINK_L=$(echo "$LATEST_JSON" | jq .assets | jq -r .[].browser_download_url | grep -i frp | grep -i linux | grep -i amd64)
  fi
fi

printf "$log_install_ex" "${VERSION:-latest}" "${DOWNLOAD_LINK_W}" "${DOWNLOAD_LINK_L}" >./logs/log_install_Ex.txt

(
  cd ExampleFrpc_Windows || exit
  echo "$downloading_windows_example"
  curl -sSL "${DOWNLOAD_LINK_W}" -o "${DOWNLOAD_LINK_W##*/}"
  echo "$extracting_windows_example"
  unzip -q "${DOWNLOAD_LINK_W##*/}"
  cp -R frp*/* ./
  rm -rf frp*windows* "${DOWNLOAD_LINK_W##*/}" frps* LICENSE
  
  # Cria script de inicialização para Windows
  cat <<EOF >start.bat
@echo off
frpc.exe -c frpc.toml
EOF
)

# Processa o exemplo para Linux
(
  cd ExampleFrpc_Linux || exit
  echo "$downloading_linux_example"
  curl -sSL "${DOWNLOAD_LINK_L}" -o "${DOWNLOAD_LINK_L##*/}"
  echo "$extracting_linux_example"
  tar -xvzf "${DOWNLOAD_LINK_L##*/}"
  cp -R frp*/* ./
  rm -rf frp*linux* "${DOWNLOAD_LINK_L##*/}" frps* LICENSE

  # Cria script de inicialização para Linux
  cat <<EOF >start.sh
#!/bin/bash
./frpc -c frpc.toml
EOF
  chmod +x start.sh
)

echo -e "$preparation_completed"