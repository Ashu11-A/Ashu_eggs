#!/bin/bash
if [[ -f "./Emby/EmbyServer.dll" ]]; then
    bash <(curl -s "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/en/Emby/start.sh")
else

    GITHUB_PACKAGE=MediaBrowser/Emby.Releases
    LATEST_JSON=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq -c '.[]' | head -1)
    RELEASES=$(curl --silent "https://api.github.com/repos/$GITHUB_PACKAGE/releases" | jq '.[]')

    if [ -z "$VERSION" ] || [ "$VERSION" == "latest" ]; then
        echo -e "defaulting to latest release"
        DOWNLOAD_LINK=$(echo $LATEST_JSON | jq .assets | jq -r .[].browser_download_url | grep -i netcore)
    else
        VERSION_CHECK=$(echo $RELEASES | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .tag_name')
        if [ "$VERSION" == "$VERSION_CHECK" ]; then
            DOWNLOAD_LINK=$(echo $RELEASES | jq -r --arg VERSION "$VERSION" '. | select(.tag_name==$VERSION) | .assets[].browser_download_url' | grep -i netcore)
        else
            echo -e "defaulting to latest release"
            DOWNLOAD_LINK=$(echo $LATEST_JSON | jq .assets | jq -r .[].browser_download_url | grep -i netcore)
        fi
    fi

    mkdir -p /mnt/server
    cd /mnt/server

    if [[ -f "./Emby/EmbyServer.dll" ]]; then
        mkdir -p Emby_OLD
        mv ./* Emby_OLD
    else
        echo "Clean installation"
    fi

    mkdir -p logs

    cat <<EOF > ./logs/log_install.txt
Version: ${VERSION}
Link: ${DOWNLOAD_LINK}
File: ${DOWNLOAD_LINK##*/}
EOF

    echo -e "running 'curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}'"
    curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}
    echo -e "Unpacking server files"
    unzip ${DOWNLOAD_LINK##*/}
    rm -rf ${DOWNLOAD_LINK##*/}
    mv system Emby
    mkdir -p programdata/
    mkdir -p programdata/config/

    cat <<EOF > programdata/config/system.xml
<?xml version="1.0"?>
<ServerConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
<EnableDebugLevelLogging>false</EnableDebugLevelLogging>
<EnableAutoUpdate>true</EnableAutoUpdate>
<LogFileRetentionDays>3</LogFileRetentionDays>
<RunAtStartup>true</RunAtStartup>
<IsStartupWizardCompleted>false</IsStartupWizardCompleted>
<EnableUPnP>true</EnableUPnP>
<PublicPort>8096</PublicPort>
<PublicHttpsPort>8920</PublicHttpsPort>
<HttpServerPortNumber>8096</HttpServerPortNumber>
<HttpsPortNumber>8920</HttpsPortNumber>
<EnableHttps>false</EnableHttps>
<IsPortAuthorized>true</IsPortAuthorized>
<AutoRunWebApp>true</AutoRunWebApp>
<EnableRemoteAccess>true</EnableRemoteAccess>
<LogAllQueryTimes>false</LogAllQueryTimes>
<EnableCaseSensitiveItemIds>true</EnableCaseSensitiveItemIds>
<PreferredMetadataLanguage>en</PreferredMetadataLanguage>
<MetadataCountryCode>US</MetadataCountryCode>
<SortRemoveWords>
<string>the</string>
<string>a</string>
<string>an</string>
<string>das</string>
<string>der</string>
<string>el</string>
<string>la</string>
</SortRemoveWords>
<LibraryMonitorDelay>60</LibraryMonitorDelay>
<EnableDashboardResponseCaching>true</EnableDashboardResponseCaching>
<ImageSavingConvention>Compatible</ImageSavingConvention>
<EnableAutomaticRestart>true</EnableAutomaticRestart>
<CollectionFolderIdsMigrated>false</CollectionFolderIdsMigrated>
<UICulture>en-us</UICulture>
<SaveMetadataHidden>false</SaveMetadataHidden>
<RemoteClientBitrateLimit>0</RemoteClientBitrateLimit>
<DisplaySpecialsWithinSeasons>true</DisplaySpecialsWithinSeasons>
<LocalNetworkSubnets />
<LocalNetworkAddresses />
<EnableExternalContentInSuggestions>true</EnableExternalContentInSuggestions>
<RequireHttps>false</RequireHttps>
<IsBehindProxy>false</IsBehindProxy>
<RemoteIPFilter />
<IsRemoteIPFilterBlacklist>false</IsRemoteIPFilterBlacklist>
<ImageExtractionTimeoutMs>0</ImageExtractionTimeoutMs>
<PathSubstitutions />
<UninstalledPlugins />
<CollapseVideoFolders>true</CollapseVideoFolders>
<EnableOriginalTrackTitles>false</EnableOriginalTrackTitles>
<VacuumDatabaseOnStartup>false</VacuumDatabaseOnStartup>
<SimultaneousStreamLimit>0</SimultaneousStreamLimit>
<DatabaseCacheSizeMB>96</DatabaseCacheSizeMB>
<EnableSqLiteMmio>false</EnableSqLiteMmio>
<NextUpUpgraded>false</NextUpUpgraded>
<ChannelOptionsUpgraded>false</ChannelOptionsUpgraded>
<TimerIdsUpgraded>false</TimerIdsUpgraded>
<ForcedSortNameUpgraded>false</ForcedSortNameUpgraded>
<InheritedParentalRatingValueUpgraded>false</InheritedParentalRatingValueUpgraded>
<EnablePeopleLetterSubFolders>false</EnablePeopleLetterSubFolders>
<OptimizeDatabaseOnShutdown>true</OptimizeDatabaseOnShutdown>
<DatabaseAnalysisLimit>400</DatabaseAnalysisLimit>
<DisableAsyncIO>false</DisableAsyncIO>
</ServerConfiguration>
EOF
fi