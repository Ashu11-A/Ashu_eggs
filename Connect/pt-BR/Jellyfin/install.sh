#!/bin/bash
## Instalando Nginx
if [[ ! -f "./nginx/nginx.conf" ]]; then
    git clone https://github.com/Ashu11-A/nginx ./temp
    cp -r ./temp/nginx ./
    rm -rf ./temp
    rm -rf ./webroot/*
    rm -f ./nginx/conf.d/default.conf
fi

if [ ! -d "logs" ]; then
    mkdir logs
fi

## configurando Nginx
if [[ ! -f "./nginx/conf.d/default.conf" ]]; then
    (
        cd nginx/conf.d/ || exit
        rm default.conf
        curl -sO https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/Jellyfin/default.conf
    )
fi
sed -i \
    -e "s/listen.*/listen ${SERVER_PORT};/g" \
    nginx/conf.d/default.conf

if [ ! -d "./tmp" ]; then
    mkdir tmp
fi

if [[ -f "./jellyfin/jellyfin.dll" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/Jellyfin/start.sh)
else
    echo "❌ Jellyfin not installed, try change version! and reinstall"

    # Define a URL base para versões estáveis e instáveis
    BASE_URL_STABLE="https://repo.jellyfin.org/files/server/portable/stable"
    BASE_URL_UNSTABLE="https://repo.jellyfin.org/files/server/portable/unstable"

    # Verifica se a versão especificada existe
    check_version_exists() {
        local url=$1
        local status_code=$(curl -o /dev/null -s -w "%{http_code}\n" "$url")
        if [[ "$status_code" == "302" ]]; then
            return 0
        else
            return 1
        fi
    }

    # Processa a versão especificada
    if [[ "$VERSION" == "latest" ]]; then
        URL="https://repo.jellyfin.org/?path=/server/portable/latest-stable/any"
        DOWNLOAD_TYPE="latest-stable"
    elif [[ "$VERSION" == "beta" ]]; then
        URL="https://repo.jellyfin.org/?path=/server/portable/latest-unstable/any"
        DOWNLOAD_TYPE="latest-unstable"
    else
        DOWNLOAD_LINK="${BASE_URL_STABLE}/v${VERSION}/any/jellyfin_${VERSION}.tar.xz"
        FILE_NAME="jellyfin_${VERSION}.tar.xz"
        NAME=$(basename "$FILE_NAME" .tar.xz)
        
        # Verifica se a versão especificada existe
        if ! check_version_exists "$DOWNLOAD_LINK"; then
            echo "Specified version not found, using 'latest'."
            VERSION="latest"
            URL="https://repo.jellyfin.org/?path=/server/portable/latest-stable/any"
            DOWNLOAD_TYPE="latest-stable"
        fi
    fi

    if [[ "$VERSION" == "latest" || "$VERSION" == "beta" ]]; then
        # Baixa o conteúdo da página
        html_content=$(curl -s "$URL")
        # Filtra o link que contenha .tar.xz
        FILE_NAME=$(echo "$html_content" | grep -oP "(?<=href='/files/server/portable/${DOWNLOAD_TYPE}/any/)[^']*\.tar\.xz" | head -n1)
        NAME=$(basename "$FILE_NAME" .tar.xz)
        
        # Verifica se um link válido foi encontrado
        if [[ -n "$FILE_NAME" ]]; then
            DOWNLOAD_LINK="https://repo.jellyfin.org/files/server/portable/${DOWNLOAD_TYPE}/any//$FILE_NAME"
        else
            echo "No .tar.xz file found on the page."
            exit 1
        fi
    fi

    cat <<EOF > .log.txt
Version: ${VERSION}
Link: ${DOWNLOAD_LINK}
File: ${FILE_NAME}
EOF
    curl -L -O ${DOWNLOAD_LINK} -o ${FILE_NAME}
    tar -Jxvf ${FILE_NAME}
    RUN chown -R container:container /home/container
    mkdir .config
    mkdir .config/jellyfin
    cat <<EOF > .config/jellyfin/network.xml
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
    rm -rf ${FILE_NAME}
    echo "user_allow_other" >> /etc/fuse.conf
fi
