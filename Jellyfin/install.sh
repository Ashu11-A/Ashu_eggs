#!/bin/bash
if [[ -f "./jellyfin/jellyfin.dll" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Jellyfin/start.sh)
else

    mkdir -p /mnt/server
    cd /mnt/server || exit
    DOWNLOAD_LINK=$(https://repo.jellyfin.org/releases/server/portable/versions/stable/combined/${VERSION}/jellyfin_${VERSION}.tar.gz)
    cat <<EOF > .log.txt
Versão: ${VERSION}
Link: ${DOWNLOAD_LINK}
Arquivo: ${DOWNLOAD_LINK##*/}
EOF
    rm -rf ./*
    curl -sSL "${DOWNLOAD_LINK}" -o "${DOWNLOAD_LINK##*/}"
    tar -vzxf "${DOWNLOAD_LINK##*/}"
    mkdir jellyfin
    mv jellyfin_${VERSION}/* ./jellyfin/
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
    rm -rf "${DOWNLOAD_LINK##*/}"
    rm -rf jellyfin_"${VERSION}"
    echo "user_allow_other" >> /etc/fuse.conf
fi