#!/bin/bash

export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Lang/xray.conf"
curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/lang.sh" -o /tmp/lang.sh
source /tmp/lang.sh

echo "$updating_script"
curl -sSL -o start.sh "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Xray/start.sh"
chmod +x start.sh

CONFIG_FILE="config.json"
UUID_FILE="uuid"

echo "$checking_credentials"

if [ -n "$TOKEN" ]; then
  echo "$token_env_detected"
  UUID="$TOKEN"
elif [ -f "$UUID_FILE" ]; then
  echo "$uuid_file_found"
  UUID=$(cat "$UUID_FILE")
else
  echo "$generating_uuid"
  UUID=$(cat /proc/sys/kernel/random/uuid)
fi

echo "$UUID" > "$UUID_FILE"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "$downloading_config"
  curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Xray/config.json" -o "$CONFIG_FILE"
fi

if [ -f "$CONFIG_FILE" ]; then
  echo "$applying_config"

  sed -i "s/^\([[:space:]]*\)\"id\":.*/\1\"id\": \"$UUID\"/" "$CONFIG_FILE"
  sed -i "s/^\([[:space:]]*\)\"port\":.*/\1\"port\": $SERVER_PORT,/" "$CONFIG_FILE"

else
  printf "${config_missing}\n" "$CONFIG_FILE"
  exit 1
fi

DISPLAY_PROTOCOL=$(grep "\"protocol\":" "$CONFIG_FILE" | head -n 1 | awk -F '"' '{print $4}')
DISPLAY_NETWORK=$(grep "\"network\":" "$CONFIG_FILE" | head -n 1 | awk -F '"' '{print $4}')

echo ""
echo "$config_success"
echo "$separator"

printf "${display_uuid}\n" "$UUID"
printf "${display_port}\n" "$SERVER_PORT"
printf "${display_protocol}\n" "$DISPLAY_PROTOCOL"
printf "${display_network}\n" "$DISPLAY_NETWORK"

echo "$separator"

xray