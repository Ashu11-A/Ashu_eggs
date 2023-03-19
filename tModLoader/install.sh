#!/bin/ash
if [[ -f "./tModLoader.dll" ]]; then
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/tModLoader/start.sh)
else

    GITHUB_PACKAGE=tModLoader/tModLoader
    ## get release info and download links
    LATEST_JSON=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq -c '.[]' | head -1)
    RELEASES=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq '.[]')
    if [ -z "$VERSION" ] || [ "$VERSION" == "latest" ]; then
        echo -e "Baixando a versão mais recente por causa de um erro"
        DOWNLOAD_LINK=$(echo $LATEST_JSON | jq .assets | jq -r .[].browser_download_url | grep -i tmodloader.zip)
    else
    VERSION_CHECK=$(echo $RELEASES | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .tag_name')
        if [ "$VERSION" == "$VERSION_CHECK" ]; then
            if [[ "$VERSION" == v* ]]; then
                DOWNLOAD_LINK=$(echo $RELEASES | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .assets[].browser_download_url' | grep -i linux | grep -i zip)
            else
                DOWNLOAD_LINK=$(echo $RELEASES | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .assets[].browser_download_url' | grep -i tmodloader.zip)
            fi
        else
            echo -e "Baixando a versão mais recente por causa de um erro"
            DOWNLOAD_LINK=$(echo $LATEST_JSON | jq .assets | jq -r .[].browser_download_url | grep -i tmodloader.zip)
        fi
    fi

    #if [ -f "tModLoaderServer" ]; then
        #echo -e "Movendo arquivos antigos para tModLoader_OLD"
        #mkdir tModLoader_OLD
        #mv ./* tModLoader_OLD
    #else
        #echo -e "Primeira instalação"
    #fi
    mkdir Mods
    echo -e "Executando 'curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}'"
    curl -sSL "${DOWNLOAD_LINK}" -o "${DOWNLOAD_LINK##*/}"
    echo -e "Descompactando Arquivos"
    unzip -o "${DOWNLOAD_LINK##*/}"
    echo -e "Limpando arquivos inúteis..."
    rm -rf "${DOWNLOAD_LINK##*/}"
    echo "Removendo Steamworks.NET.dll antigo e com falhas"
    rm -rf Libraries/steamworks.net/20.1.0/lib/netstandard2.1/Steamworks.NET.dll
    #cd Libraries/steamworks.net/20.1.0/lib/netstandard2.1/
    #wget https://github.com/Ashu11-A/Ashu_eggs/raw/main/Steamworks.NET.dll
    #cd /mnt/server
    echo "Fazendo o Download do Steamworks.NET.dll Modificado"
    curl -sSL https://github.com/Ashu11-A/Ashu_eggs/raw/main/tModLoader/Steamworks.NET.dll -o Steamworks.NET.dll
    mv Steamworks.NET.dll Libraries/steamworks.net/20.1.0/lib/netstandard2.1/
    echo -e "Colocando permisão para os arquivos para evitar erros."
    chmod -R 755 ./*
    chmod +x tModLoaderServer.bin.x86_64
    echo 'dotnet tModLoader.dll -server "$@"' > tModLoaderServer
    chmod +x tModLoaderServer
    echo -e "Limpando arquivos extras."
    rm -rf /mnt/server/.local/share/Terraria/ModLoader/Mods
    rm -rf terraria-server-*.zip
    rm "${DOWNLOAD_LINK##*/}"
    rm -rf DedicatedServerUtils LaunchUtils PlatformVariantLibs tModPorter RecentGitHubCommits.txt *.bat serverconfig.txt
    echo -e "Gerando arquivo de configuração"
    touch ./Mods/enabled.json
    touch ./banlist.txt
    cat <<EOF > serverconfig.txt
||----------------------------------------------------------------||
Note: To change any value go to Startup, and change there!
Notas: Para alterar qualquer valor va para Startup, e altere la!
||----------------------------------------------------------------||
world=
worldpath=
modpath=
banlist=
port=
||----------------------------------------------------------------||
worldname=
maxplayers=
difficulty=
autocreate=
slowliquids=
seed=
motd=
||----------------------------------------------------------------||
password=
secure=
language=
EOF
    echo -e "Instalação completa"
fi
