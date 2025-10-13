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
rm frps.toml
rm frpc.toml

cat <<EOF >frpc.toml
[common]
$frpc_comment_server
serverAddr = $SERVER_IP
serverPort = $bind_port
$frpc_comment_webserver
webServer.addr = 0.0.0.0
webServer.port = 7500
webServer.user = admin
webServer.password = admin
$frpc_comment_auth
auth.additionalScopes = ["HeartBeats", "NewWorkConns"]
token = $token
$frpc_comment_example
[[$frpc_example_name]]
type = "tcp"
localIP = "0.0.0.0"
localPort = 7777
remotePort = 25310
transport.useCompression = true
EOF

cat <<EOF >frps.toml
[common]
$frps_comment_bind
bindAddr = $IP
bindPort =
kcpBindPort =
$frps_comment_dashboard
webServer.addr =
webServer.port =
webServer.user =
webServer.password =
$frps_comment_security
auth.method = "token"
auth.additionalScopes = ["HeartBeats", "NewWorkConns"]
auth.token =
EOF

mkdir -p Frps
mv frps* ./Frps

mkdir -p Frpc
mv frpc* ./Frpc

curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Frp/exemple.sh -o exemple.sh
chmod a+x ./exemple.sh
./exemple.sh

echo -e "$installation_complete"
exit 0
