#!/bin/bash
version_egg="1.0"
version_script="1.0"
echo "⚙️  Script Version: ${version_script}"
if [[ -f "./logs/egg_version" ]]; then
    versions=" $(cat ./logs/egg_version) "
    comm1=$(printf '%s\n' "$versions" | tr -d '.')
    comm2=$(printf '%s\n' "${version_egg}" | tr -d '.')
    if [ "${ATZ_SYSTEM}" = "1" ]; then
        if [ "${comm1}" -ge "${comm2}" ]; then
            echo "✅  Egg Updated."
        else
            echo "
    
⚠️  Egg Outdated.
🔴  Installed Version: ${versions}
🟢  Most Recent Version: ${version_egg}
🌐  Access: https://github.com/Ashu11-A/Ashu_eggs
    
"
        fi
    fi
else
    echo "
    
⚠️  Egg Outdated.
🔴  Installed Version: 1.0 (respectively).
🟠  If you have just updated the Egg, just Reinstall your Server (nothing will be deleted).
🟢  Most Recent Version: ${version_egg}
🌐  Access: https://github.com/Ashu11-A/Ashu_eggs
    
"
fi
