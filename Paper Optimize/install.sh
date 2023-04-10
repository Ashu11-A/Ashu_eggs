#!/bin/ash
# shellcheck shell=dash
# Paper Installation Script
#
# Server Files: /mnt/server
if [ -f "${SERVER_JARFILE}" ]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Paper%20Optimize/launch.sh)
else
    PROJECT=paper
    if [ -n "${DL_PATH}" ]; then
        echo "Using supplied download url: ${DL_PATH}"
        DOWNLOAD_URL=$(eval echo $(echo ${DL_PATH} | sed -e 's/{{/${/g' -e 's/}}/}/g'))
    else
        VER_EXISTS=$(curl -s https://api.papermc.io/v2/projects/${PROJECT} | jq -r --arg VERSION $MINECRAFT_VERSION '.versions[] | contains($VERSION)' | grep -m1 true)
        LATEST_VERSION=$(curl -s https://api.papermc.io/v2/projects/${PROJECT} | jq -r '.versions' | jq -r '.[-1]')
        if [ "${VER_EXISTS}" = "true" ]; then
            echo "Version is valid. Using version ${MINECRAFT_VERSION}"
        else
            echo "Specified version not found. Defaulting to the latest ${PROJECT} version"
            MINECRAFT_VERSION=${LATEST_VERSION}
        fi
        BUILD_EXISTS=$(curl -s https://api.papermc.io/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION} | jq -r --arg BUILD ${BUILD_NUMBER} '.builds[] | tostring | contains($BUILD)' | grep -m1 true)
        LATEST_BUILD=$(curl -s https://api.papermc.io/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION} | jq -r '.builds' | jq -r '.[-1]')
        if [ "${BUILD_EXISTS}" = "true" ]; then
            echo "Build is valid for version ${MINECRAFT_VERSION}. Using build ${BUILD_NUMBER}"
        else
            echo "Using the latest ${PROJECT} build for version ${MINECRAFT_VERSION}"
            BUILD_NUMBER=${LATEST_BUILD}
        fi
        JAR_NAME=${PROJECT}-${MINECRAFT_VERSION}-${BUILD_NUMBER}.jar
        echo "Version being downloaded"
        echo "MC Version: ${MINECRAFT_VERSION}"
        echo "Build: ${BUILD_NUMBER}"
        echo "JAR Name of Build: ${JAR_NAME}"
        DOWNLOAD_URL=https://api.papermc.io/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION}/builds/${BUILD_NUMBER}/downloads/${JAR_NAME}
    fi
    cd /mnt/server || exit
    mkdir logs
    echo "Running curl -o ${SERVER_JARFILE} ${DOWNLOAD_URL}"
    if [ -f "${SERVER_JARFILE}" ]; then
        mv "${SERVER_JARFILE}" "${SERVER_JARFILE}.old"
    fi
    curl -o "${SERVER_JARFILE}" "${DOWNLOAD_URL}"
    if [ ! -f server.properties ]; then
        echo "Downloading MC server.properties"
        curl -o server.properties https://raw.githubusercontent.com/parkervcp/eggs/master/minecraft/java/server.properties
        curl -o spigot.yml https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Paper%20Optimize/config/spigot.yml
        curl -o bukkit.yml https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Paper%20Optimize/config/bukkit.yml
        mkdir config
        cd config || exit
        curl -o paper-world-defaults.yml https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Paper%20Optimize/config/paper-world-defaults.yml
    fi
fi
