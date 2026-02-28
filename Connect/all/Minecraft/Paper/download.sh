#!/bin/bash

PROJECT="paper"

if [ -n "${DL_PATH}" ]; then
    printf "%s %s\n" "$using_supplied_url" "${DL_PATH}"
    DOWNLOAD_URL=$(eval echo "$(echo "${DL_PATH}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")
    CLEAN_VERSION="custom"
    JAR_NAME="${SERVER_JARFILE}"
else
    LATEST_VERSION=$(curl -s "https://api.papermc.io/v2/projects/${PROJECT}" | jq -r '.versions[-1]')
    
    if [ -n "${MINECRAFT_VERSION}" ] && [ "${MINECRAFT_VERSION}" != "latest" ]; then
        VER_EXISTS=$(curl -s "https://api.papermc.io/v2/projects/${PROJECT}" | jq -r --arg VERSION "${MINECRAFT_VERSION}" '.versions[] | select(. == $VERSION)')
        if [ -n "${VER_EXISTS}" ]; then
            printf "%s %s\n" "$version_valid" "${MINECRAFT_VERSION}"
        else
            printf "%s %s\n" "$version_not_found" "${PROJECT}"
            MINECRAFT_VERSION="${LATEST_VERSION}"
        fi
    else
        MINECRAFT_VERSION="${LATEST_VERSION}"
    fi

    LATEST_BUILD=$(curl -s "https://api.papermc.io/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION}" | jq -r '.builds[-1]')
    
    if [ -n "${BUILD_NUMBER}" ] && [ "${BUILD_NUMBER}" != "latest" ]; then
        BUILD_EXISTS=$(curl -s "https://api.papermc.io/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION}" | jq -r --arg BUILD "${BUILD_NUMBER}" '.builds[] | tostring | select(. == $BUILD)')
        if [ -n "${BUILD_EXISTS}" ]; then
             printf "%s %s\n" "$build_valid" "${MINECRAFT_VERSION}"
        else
            printf "%s %s\n" "$using_latest_build" "${PROJECT}"
            BUILD_NUMBER="${LATEST_BUILD}"
        fi
    else
        BUILD_NUMBER="${LATEST_BUILD}"
    fi

    JAR_NAME="${PROJECT}-${MINECRAFT_VERSION}-${BUILD_NUMBER}.jar"
    DOWNLOAD_URL="https://api.papermc.io/v2/projects/${PROJECT}/versions/${MINECRAFT_VERSION}/builds/${BUILD_NUMBER}/downloads/${JAR_NAME}"
    CLEAN_VERSION="${MINECRAFT_VERSION}"
fi

export DOWNLOAD_SOURCE="PaperMC API"
export FILE_NAME="${JAR_NAME}"
export DOWNLOAD_LINK="${DOWNLOAD_URL}"
export CLEAN_VERSION="${CLEAN_VERSION}"
