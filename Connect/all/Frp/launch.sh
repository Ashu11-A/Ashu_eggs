#!/bin/bash

curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/toml.sh -o toml.sh
source ./toml.sh

# Define valores padrão para variáveis vazias
if [[ -z "${BIND_PORT}" ]]; then
  BIND_PORT="${SERVER_PORT:-7000}"
fi

if [[ -z "${DASHBOARD_PORT}" ]]; then
  DASHBOARD_PORT="7500"
fi

if [[ -z "${DASHBOARD_USER}" ]]; then
  DASHBOARD_USER="admin"
fi

if [[ -z "${DASHBOARD_PWD}" ]]; then
  DASHBOARD_PWD="admin"
fi

if [[ -z "${TOKEN}" ]]; then
  TOKEN="change_this_token"
fi

printf "$script_version\n" "3.0"
echo "$learn_more"

if [ "${FRP_MODE}" == "1" ]; then
  echo "$starting_frps"

  if [[ -f "./Frps/frps.toml" ]]; then
    # Configura os valores do frps.toml
    printf "$configuring_bind_port\n" "${BIND_PORT}"
    set_toml_value "Frps/frps.toml" "bindPort" "${BIND_PORT}"
    
    printf "$configuring_kcp_port\n" "${BIND_PORT}"
    set_toml_value "Frps/frps.toml" "kcpBindPort" "${BIND_PORT}"
    
    printf "$configuring_webserver_addr\n" "0.0.0.0"
    set_toml_value "Frps/frps.toml" "webServer.addr" "0.0.0.0"
    
    printf "$configuring_webserver_port\n" "${DASHBOARD_PORT}"
    set_toml_value "Frps/frps.toml" "webServer.port" "${DASHBOARD_PORT}"
    
    printf "$configuring_webserver_user\n" "${DASHBOARD_USER}"
    set_toml_value "Frps/frps.toml" "webServer.user" "${DASHBOARD_USER}"
    
    echo "$configuring_webserver_password"
    set_toml_value "Frps/frps.toml" "webServer.password" "${DASHBOARD_PWD}"
    
    echo "$configuring_auth_token"
    set_toml_value "Frps/frps.toml" "auth.token" "${TOKEN}"
    
    ./Frps/frps -c ./Frps/frps.toml
  else
    printf "$config_format_warning\n" "frps.ini" "frps.toml"
    ./Frps/frps -c ./Frps/frps.ini
  fi
else
  echo "$starting_frpc"

  if [[ -f "./Frpc/frpc.toml" ]]; then
    # Configura os valores do frpc.toml
    printf "$configuring_server_port\n" "${BIND_PORT}"
    set_toml_value "Frpc/frpc.toml" "serverPort" "${BIND_PORT}"
    
    printf "$configuring_auth_method\n" "token"
    set_toml_value "Frpc/frpc.toml" "auth.method" "token"
    
    echo "$configuring_auth_token"
    set_toml_value "Frpc/frpc.toml" "auth.token" "${TOKEN}"
    
    ./Frpc/frpc -c ./Frpc/frpc.toml
  else
    printf "$config_format_warning\n" "frpc.ini" "frpc.toml"
    ./Frpc/frpc -c ./Frpc/frpc.ini
  fi
fi
