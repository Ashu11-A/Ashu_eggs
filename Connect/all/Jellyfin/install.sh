#!/bin/bash
set -u

BASE_DIR="/mnt/server"
[[ -d "/home/container" ]] && BASE_DIR="/home/container"
cd "$BASE_DIR" || exit 1

HAS_NATIVE_JELLYFIN=0
if command -v jellyfin >/dev/null 2>&1; then
    HAS_NATIVE_JELLYFIN=1
fi

download_portable() {
    printf "${downloading_portable:-Downloading portable build (%s)...}\n" "${VERSION:-latest}"

    local BASE_URL_STABLE="https://repo.jellyfin.org/files/server/portable/stable"
    local URL DOWNLOAD_TYPE DOWNLOAD_LINK FILE_NAME html_content

    VERSION="${VERSION:-latest}"
    DOWNLOAD_LINK=""
    FILE_NAME=""

    if [[ "$VERSION" == "latest" ]]; then
        URL="https://repo.jellyfin.org/?path=/server/portable/latest-stable/any"
        DOWNLOAD_TYPE="latest-stable"
    elif [[ "$VERSION" == "beta" ]]; then
        URL="https://repo.jellyfin.org/?path=/server/portable/latest-unstable/any"
        DOWNLOAD_TYPE="latest-unstable"
    else
        DOWNLOAD_LINK="${BASE_URL_STABLE}/v${VERSION}/any/jellyfin_${VERSION}.tar.xz"
        FILE_NAME="jellyfin_${VERSION}.tar.xz"
        local status_code
        status_code=$(curl -o /dev/null -s -w "%{http_code}\n" "$DOWNLOAD_LINK")
        if [[ "$status_code" != "302" ]]; then
            echo "${version_not_found:-Specified version not found, using latest.}"
            VERSION="latest"
            URL="https://repo.jellyfin.org/?path=/server/portable/latest-stable/any"
            DOWNLOAD_TYPE="latest-stable"
        fi
    fi

    if [[ "$VERSION" == "latest" || "$VERSION" == "beta" ]]; then
        html_content=$(curl -s "$URL")
        FILE_NAME=$(echo "$html_content" | grep -oP "(?<=href='/files/server/portable/${DOWNLOAD_TYPE}/any/)[^']*\.tar\.xz" | head -n1)
        if [[ -n "$FILE_NAME" ]]; then
            DOWNLOAD_LINK="https://repo.jellyfin.org/files/server/portable/${DOWNLOAD_TYPE}/any//${FILE_NAME}"
        else
            echo "${no_tarball:-No .tar.xz file found on the page.}"
            return 1
        fi
    fi

    cat <<EOF > .log.txt
Version: ${VERSION}
Link: ${DOWNLOAD_LINK}
File: ${FILE_NAME}
EOF
    curl -L -o "${FILE_NAME}" "${DOWNLOAD_LINK}"
    tar -Jxvf "${FILE_NAME}"
    rm -f "${FILE_NAME}"
    chown -R container:container "$BASE_DIR" 2>/dev/null || true
    chmod 777 -R ./* 2>/dev/null || true
}

echo "${setting_up_env:-Setting up environment...}"
echo "${preparing_dirs:-Creating directories...}"
mkdir -p logs tmp data cache .config/jellyfin

if [[ ! -f "./.config/jellyfin/network.xml" ]]; then
    cat <<'EOF' > .config/jellyfin/network.xml
<?xml version="1.0" encoding="utf-8"?>
<NetworkConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
<RequireHttps>false</RequireHttps>
<CertificatePath />
<CertificatePassword />
<BaseUrl />
<PublicHttpsPort>8920</PublicHttpsPort>
<HttpServerPortNumber>8096</HttpServerPortNumber>
<HttpsPortNumber>8920</HttpsPortNumber>
<EnableHttps>false</EnableHttps>
<PublicPort>8096</PublicPort>
<EnableIPV6>false</EnableIPV6>
<EnableIPV4>true</EnableIPV4>
<IgnoreVirtualInterfaces>true</IgnoreVirtualInterfaces>
<VirtualInterfaceNames>vEthernet*</VirtualInterfaceNames>
<TrustAllIP6Interfaces>false</TrustAllIP6Interfaces>
<PublishedServerUriBySubnet />
<RemoteIPFilter />
<IsRemoteIPFilterBlacklist>false</IsRemoteIPFilterBlacklist>
<EnableUPnP>false</EnableUPnP>
<EnableRemoteAccess>true</EnableRemoteAccess>
<LocalNetworkSubnets />
<LocalNetworkAddresses />
<KnownProxies />
</NetworkConfiguration>
EOF
    echo "${network_xml_created:-network.xml created.}"
else
    echo "${network_xml_exists:-network.xml already exists.}"
fi

if [[ -n "${SERVER_PORT:-}" ]]; then
    sed -i -e "s|<HttpServerPortNumber>.*</HttpServerPortNumber>|<HttpServerPortNumber>${SERVER_PORT}</HttpServerPortNumber>|g" \
        -e "s|<PublicPort>.*</PublicPort>|<PublicPort>${SERVER_PORT}</PublicPort>|g" .config/jellyfin/network.xml
fi

if [[ "$HAS_NATIVE_JELLYFIN" == "1" ]]; then
    echo "${standalone_detected:-Standalone Jellyfin detected.}"
    rm -rf ./jellyfin
elif [[ ! -f "./jellyfin/jellyfin.dll" && ! -x "./jellyfin/jellyfin" ]]; then
    download_portable || exit 1
else
    echo "${dotnet_detected:-Portable Jellyfin install found.}"
fi

NATIVE_JELLYFIN_PATH="no"
[[ "$HAS_NATIVE_JELLYFIN" == "1" ]] && NATIVE_JELLYFIN_PATH="$(command -v jellyfin)"
cat <<EOF > ./logs/install_log.txt
Mode: install (dirs + network.xml + portable unless standalone)
Standalone: ${NATIVE_JELLYFIN_PATH}
Portable: $([[ -f ./jellyfin/jellyfin.dll || -x ./jellyfin/jellyfin ]] && echo "yes" || echo "no")
EOF

echo "${installation_complete:-Done.}"
