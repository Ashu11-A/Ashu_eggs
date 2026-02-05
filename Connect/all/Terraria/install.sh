#!/bin/bash
# shellcheck shell=dash

mkdir -p logs

apk add --no-cache curl wget file unzip zip jq

# download.sh: primary = GitHub release + checksum; fallback = wiki
curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Terraria/download.sh" -o /tmp/download.sh
# shellcheck source=/dev/null
source /tmp/download.sh

cat <<EOF >logs/run.log
${version}: ${CLEAN_VERSION}
${link}: ${WIKI_DOWNLOAD_LINK:-}
${file}: ${FILE_NAME:-}
${clean_version}: ${CLEAN_VERSION}
EOF

printf "%s" "$unpacking"
if [ "$DOWNLOAD_SOURCE" = "github" ] && [ -n "$FILE_NAME" ]; then
    tar -xzf "$FILE_NAME"
    rm -f "$FILE_NAME"
else
    # Wiki fallback: zip with version folder
    unzip -o "$FILE_NAME"
    cp -rf "${CLEAN_VERSION}/Linux"/* ./
    rm -rf "${CLEAN_VERSION}"
    rm -f "$FILE_NAME"
fi

mkdir -p saves saves/Worlds # Ensure saves directories exist
chmod +x TerrariaServer.exe 2>/dev/null || true
touch banlist.txt

printf "%s" "$cleaning_up"
rm -f System* Mono* mscorlib.dll serverconfig.txt TerrariaServer.bin.x86_64 TerrariaServer

printf "%s" "$generating_config"
curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Terraria/serverconfig.txt" -o serverconfig.txt

printf "%s" "$install_complete"
