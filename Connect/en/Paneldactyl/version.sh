#!/bin/bash
version_egg="1.1"
version_script="2.3"
echo "⚙️  Script Version: ${version_script}"
if [[ -f "./logs/egg_version" ]]; then
    versions=" $(cat ./logs/egg_version) "
    comm1=$(printf '%s\n' "$versions" | tr -d '.')
    comm2=$(printf '%s\n' "${version_egg}" | tr -d '.')
    if [ "${ATZ_SYSTEM}" = "1" ]; then
        if [ "${comm1}" -ge "${comm2}" ]; then
            echo "✅  Updated Egg."
        else
            echo "
    
⚠️  Outdated Egg.
🔴  Installed Version: ${versions}
🟢  Latest Version: ${version_egg}
🌐  Visit: https://github.com/Ashu11-A/Ashu_eggs

"
        fi
    fi
else
    echo "
    
⚠️  Outdated Egg.
🔴  Installed Version: 1.0 (respectively).
🟠  If you have just updated the Egg, simply reinstall your Server (nothing will be deleted).
🟢  Latest Version: ${version_egg}
🌐  Visit: https://github.com/Ashu11-A/Ashu_eggs
    
"
fi
