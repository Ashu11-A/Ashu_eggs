#!/bin/bash
# shellcheck shell=dash
# Terraria server download: primary = GitHub release (Ashu_eggs) + checksum; fallback = wiki/fandom.

GITHUB_REPO="Ashu11-A/Ashu_eggs"
RELEASE_TAG="terraria-servers"
RELEASE_API="https://api.github.com/repos/${GITHUB_REPO}/releases/tags/${RELEASE_TAG}"

# Normalize version: "1.4.5.4" -> 1454, "latest" or "" -> resolve from API
normalize_version() {
    local v="${1:-latest}"
    if [ "$v" = "latest" ] || [ -z "$v" ]; then
        echo "latest"
        return
    fi
    echo "$v" | sed 's/\.//g'
}

CLEAN_VERSION=$(normalize_version "${TERRARIA_VERSION:-latest}")
DOWNLOAD_SOURCE=""
FILE_NAME=""
WIKI_DOWNLOAD_LINK=""
export CLEAN_VERSION

# ---- Primary: GitHub release + checksum ----
try_github() {
    if ! command -v jq >/dev/null 2>&1; then
        return 1
    fi

    local release_json
    release_json=$(curl -sSLf "$RELEASE_API" 2>/dev/null) || return 1
    [ -n "$release_json" ] || return 1

    local asset_name
    local download_url

    if [ "$CLEAN_VERSION" = "latest" ]; then
        CLEAN_VERSION=$(echo "$release_json" | jq -r '.assets[].name' | grep -E '^[0-9]+\.tar\.gz$' | sed 's/\.tar\.gz$//' | sort -n | tail -1)
        [ -n "$CLEAN_VERSION" ] || return 1
        asset_name="${CLEAN_VERSION}.tar.gz"
    else
        asset_name="${CLEAN_VERSION}.tar.gz"
        # Check asset exists in release
        if ! echo "$release_json" | jq -e --arg n "$asset_name" '.assets[] | select(.name == $n)' >/dev/null 2>&1; then
            return 1
        fi
    fi

    download_url=$(echo "$release_json" | jq -r --arg n "$asset_name" '.assets[] | select(.name == $n) | .browser_download_url')
    [ -n "$download_url" ] || return 1

    printf "%s" "${downloading_github:-Downloading from GitHub }"
    if ! curl -sSLf "$download_url" -o "$asset_name"; then
        rm -f "$asset_name"
        return 1
    fi

    # Download checksums.txt from same release and verify
    local checksums_url
    checksums_url=$(echo "$release_json" | jq -r '.assets[] | select(.name == "checksums.txt") | .browser_download_url')
    if [ -n "$checksums_url" ] && [ "$checksums_url" != "null" ]; then
        local checksums_line
        checksums_line=$(curl -sSLf "$checksums_url" 2>/dev/null | grep -E "[0-9a-f]{64}[[:space:]]+${asset_name}\$" | head -1)
        if [ -n "$checksums_line" ]; then
            echo "$checksums_line" > "checksums_one.txt"
            if command -v sha256sum >/dev/null 2>&1; then
                if ! sha256sum -c checksums_one.txt >/dev/null 2>&1; then
                    printf "%s" "${checksum_fail:-Checksum verification failed. }"
                    rm -f "checksums_one.txt" "$asset_name"
                    return 1
                fi
            fi
            rm -f checksums_one.txt
        fi
    fi
    printf "%s" "${checksum_ok:-Checksum OK. }"

    DOWNLOAD_SOURCE="github"
    FILE_NAME="$asset_name"
    return 0
}

# ---- Fallback: Wiki / official links ----
do_wiki() {
    printf "%s" "${fallback_wiki:-Using wiki fallback. }"

    if [ "$CLEAN_VERSION" = "latest" ]; then
        WIKI_DOWNLOAD_LINK=$(curl -sSL https://terraria.fandom.com/wiki/Server#Downloads | grep '>Terraria Server ' | grep -Eoi '<a [^>]+>' | grep -Eo 'href="[^"]+"' | grep -Eo '(http|https)://[^"]+' | tail -1 | cut -d'?' -f1)
    else
        WIKI_DOWNLOAD_LINK=$(curl -sSL https://terraria.fandom.com/wiki/Server#Downloads | grep '>Terraria Server ' | grep -Eoi '<a [^>]+>' | grep -Eo 'href="[^"]+"' | grep -Eo '(http|https)://[^"]+' | grep "${CLEAN_VERSION}" | cut -d'?' -f1)
    fi

    [ -n "$WIKI_DOWNLOAD_LINK" ] || return 1

    if ! curl --output /dev/null --silent --head --fail "$WIKI_DOWNLOAD_LINK"; then
        printf "%s" "${link_invalid:-Link invalid. }"
        return 1
    fi

    printf "%s" "${link_valid:-Link valid. }"
    FILE_NAME="${WIKI_DOWNLOAD_LINK##*/}"
    printf "%s" "${running_curl:-Downloading... }"
    curl -sSL "$WIKI_DOWNLOAD_LINK" -o "$FILE_NAME" || return 1

    DOWNLOAD_SOURCE="wiki"
    return 0
}

# Run: try GitHub first, then wiki
if try_github; then
    :
elif do_wiki; then
    :
else
    printf "%s" "${link_invalid:-Download failed. }"
    exit 2
fi

export FILE_NAME DOWNLOAD_SOURCE
