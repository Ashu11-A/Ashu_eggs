#!/bin/bash
export LANG_PATH="https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Lang/paneldactyl.conf"
curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/loadLang.sh" -o /tmp/loadLang.sh
source /tmp/loadLang.sh
rm -f /tmp/loadLang.sh

version_egg="1.3"
version_script="3.0-Universal"
echo "$version_script ${version_script}"
if [[ -f "./logs/egg_version" ]]; then
    versions=" $(cat ./logs/egg_version) "
    comm1=$(printf '%s\n' "$versions" | tr -d '.')
    comm2=$(printf '%s\n' "${version_egg}" | tr -d '.')
    if [ "${ATZ_SYSTEM}" = "1" ]; then
        if [ "${comm1}" -ge "${comm2}" ]; then
            echo "$egg_updated"
        else
            echo "
    
$egg_outdated
$installed_ver ${versions}
$latest_ver ${version_egg}
$visit_github https://github.com/Ashu11-A/Ashu_eggs
    
"
        fi
    fi
else
    echo "
    
$egg_outdated
$installed_ver 1.0 (Legacy)
$latest_ver ${version_egg}
$visit_github https://github.com/Ashu11-A/Ashu_eggs
    
"
fi