#!/bin/bash

curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/toml.sh -o toml.sh
source ./toml.sh

# Define BIND_PORT como SERVER_PORT se estiver vazio ou não existir
if [[ -z "${BIND_PORT}" ]]; then
  BIND_PORT="${SERVER_PORT}"
fi

printf "$script_version\n" "3.0"
echo "$learn_more"

if [ "${FRP_MODE}" == "1" ]; then
  echo "$starting_frps"

  if [[ -f "./Frps/frps.toml" ]]; then
    # Configura os valores do frps.toml
    set_toml_value "Frps/frps.toml" "bindPort" "${BIND_PORT}"
    set_toml_value "Frps/frps.toml" "kcpBindPort" "${BIND_PORT}"
    set_toml_value "Frps/frps.toml" "webServer.addr" "0.0.0.0"
    set_toml_value "Frps/frps.toml" "webServer.port" "${DASHBOARD_PORT}"
    set_toml_value "Frps/frps.toml" "webServer.user" "${DASHBOARD_USER}"
    set_toml_value "Frps/frps.toml" "webServer.password" "${DASHBOARD_PWD}"
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
    set_toml_value "Frpc/frpc.toml" "serverPort" "${BIND_PORT}"
    set_toml_value "Frpc/frpc.toml" "auth.method" "token"
    set_toml_value "Frpc/frpc.toml" "auth.token" "${TOKEN}"
    
    ./Frpc/frpc -c ./Frpc/frpc.toml
  else
    printf "$config_format_warning\n" "frpc.ini" "frpc.toml"
    ./Frpc/frpc -c ./Frpc/frpc.ini
  fi
fi
