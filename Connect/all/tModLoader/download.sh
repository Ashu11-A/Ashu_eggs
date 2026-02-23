#!/bin/bash

GITHUB_PACKAGE="tModLoader/tModLoader"

# Normalize version: "latest" or "" -> resolve from API
normalize_version() {
    local v="${1:-latest}"
    if [ "$v" = "latest" ] || [ -z "$v" ]; then
        echo "latest"
        return
    fi
    echo "$v"
}

VERSION="${TMODLOADER_VERSION:-latest}"
CLEAN_VERSION=$(normalize_version "$VERSION")
DOWNLOAD_LINK=""
TAG_NAME=""
FILE_NAME=""

try_github() {
    if ! command -v jq >/dev/null 2>&1; then
        return 1
    fi

    local releases_json
    local download_url=""
    local tag_name=""

    if [ "$CLEAN_VERSION" = "latest" ]; then
        releases_json=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases/latest")
        tag_name=$(echo "$releases_json" | jq -r '.tag_name')
        download_url=$(echo "$releases_json" | jq -r '.assets[] | select(.name | test("tModLoader.zip"; "i")) | .browser_download_url')
    else
        local specific_release_json
        specific_release_json=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases/tags/$CLEAN_VERSION")
        
        local release_id
        release_id=$(echo "$specific_release_json" | jq -r .id)

        if [ "$release_id" != "null" ]; then
            tag_name=$(echo "$specific_release_json" | jq -r '.tag_name')
            if [[ "$tag_name" == v* ]]; then
                download_url=$(echo "$specific_release_json" | jq -r '.assets[] | select(.name | test("linux.*zip|tmodloader.zip"; "i")) | .browser_download_url' | head -1)
            else
                download_url=$(echo "$specific_release_json" | jq -r '.assets[] | select(.name | test("tModLoader.zip"; "i")) | .browser_download_url')
            fi
        else
            # Fallback to latest if version not found
            releases_json=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases/latest")
            tag_name=$(echo "$releases_json" | jq -r '.tag_name')
            download_url=$(echo "$releases_json" | jq -r '.assets[] | select(.name | test("tModLoader.zip"; "i")) | .browser_download_url')
        fi
    fi

    DOWNLOAD_LINK="$download_url"
    TAG_NAME="$tag_name"
    FILE_NAME="${DOWNLOAD_LINK##*/}"
    return 0
}

if try_github; then
    :
else
    exit 2
fi

# tModLoader-sync resolution (Always latest)
if command -v jq >/dev/null 2>&1; then
    SYNC_REPO="Ashu11-A/tModLoader-sync"
    ARCH=$(uname -m)
    SYNC_RELEASE_JSON=$(curl --silent "https://api.github.com/repos/$SYNC_REPO/releases/latest")
    
    case "$ARCH" in
        x86_64)  SYNC_PATTERN="server-linux-x64" ;;
        aarch64) SYNC_PATTERN="server-linux-arm64" ;;
        *)       SYNC_PATTERN="" ;;
    esac

    if [ -n "$SYNC_PATTERN" ]; then
        SYNC_DOWNLOAD_LINK=$(echo "$SYNC_RELEASE_JSON" | jq -r ".assets[] | select(.name == \"$SYNC_PATTERN\") | .browser_download_url")
        SYNC_FILE_NAME="tml-sync"
    fi
fi

export CLEAN_VERSION DOWNLOAD_LINK TAG_NAME FILE_NAME SYNC_DOWNLOAD_LINK SYNC_FILE_NAME
