#!/bin/bash
printf "$script_version\n" "3.0"
echo "$learn_more"

if [ "${FRP_MODE}" == "1" ]; then
  echo "$starting_frps"

  if [[ -f "./Frps/frps.toml" ]]; then
    ./Frps/frps -c ./Frps/frps.toml
  else
    printf "$config_format_warning\n" "frps.ini" "frps.toml"
    ./Frps/frps -c ./Frps/frps.ini
  fi
else
  echo "$starting_frpc"

  if [[ -f "./Frps/frps.toml" ]]; then
    ./Frpc/frpc -c ./Frpc/frpc.toml
  else
    printf "$config_format_warning\n" "frpc.ini" "frpc.toml"
    ./Frpc/frpc -c ./Frpc/frpc.ini
  fi
fi
