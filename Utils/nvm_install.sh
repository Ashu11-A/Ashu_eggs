#!/bin/bash
# shellcheck source=/dev/null
source "/home/container/.nvm/nvm.sh"

echo -e "\n \n📝  Which version of Node.js do you want to use (12, 14, 16, 18, 20) (press [ENTER]): \n \n"
while read -r VERSION; do

    if [[ "$VERSION" =~ ^(12|14|16|18|20)$ ]]; then
        if [[ "$VERSION" == "12" ]]; then
            NODE_VERSION="12"
        elif [[ "$VERSION" == "14" ]]; then
            NODE_VERSION="14"
        elif [[ "$VERSION" == "16" ]]; then
            NODE_VERSION="16"
        elif [[ "$VERSION" == "18" ]]; then
            NODE_VERSION="18"
        elif [[ "$VERSION" == "20" ]]; then
            NODE_VERSION="20"
        fi

        if [ ! -d "logs" ]; then
            mkdir logs
        fi

        echo "$VERSION" >logs/nodejs_version
        echo -e "\n \n👍  Alright, I saved version $VERSION here!\n \n"
        echo -e "\n \n🫵  You can change the version using the command: ${bold}${lightblue}version.\n \n"

        if [[ -f "logs/nodejs_version" ]]; then
            echo "${NODE_VERSION}"
            if [ -n "${NODE_VERSION}" ]; then
                nvm install "${NODE_VERSION}"
                nvm use "${NODE_VERSION}"
                exit
            else
                echo -e "\n \n⚠️  Unidentified version, using default nvm (v18).\n \n"
                nvm install 18
                nvm use 18
                exit
            fi
        fi
        break
    else
        echo -e "\n \n🥶  Version not found, only versions 12, 14, 16, 18, 20 are available.\n \n"
    fi
done
