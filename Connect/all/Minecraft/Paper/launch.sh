#!/bin/bash

bold="\e[1m"
lightblue="\e[94m"
normal="\e[0m"

declare -a params=()

params+=("-XX:+DisableExplicitGC")

# --- (GC legado + FML + JIT) ---
declare -a _legacy_gc=(
    "-XX:+UseNUMA"
    "-XX:MaxTenuringThreshold=15"
    "-XX:MaxGCPauseMillis=30"
    "-XX:GCPauseIntervalMillis=150"
    "-XX:-UseGCOverheadLimit"
    "-XX:+UseBiasedLocking"
    "-XX:SurvivorRatio=8"
    "-XX:TargetSurvivorRatio=90"
    "-Dfml.ignorePatchDiscrepancies=true"
    "-Dfml.ignoreInvalidMinecraftCertificates=true"
    "-XX:+UseCompressedOops"
    "-XX:+OptimizeStringConcat"
    "-XX:ReservedCodeCacheSize=2048m"
    "-XX:+UseCodeCacheFlushing"
    "-XX:SoftRefLRUPolicyMSPerMB=2000"
    "-XX:ParallelGCThreads=10"
)

# --- (G1GC balanceado) ---
declare -a _g1_balanced=(
    "-XX:+AlwaysPreTouch"
    "-XX:+ParallelRefProcEnabled"
    "-XX:+PerfDisableSharedMem"
    "-XX:-UsePerfData"
    "-XX:MaxGCPauseMillis=200"
    "-XX:+UseG1GC"
    "-XX:G1HeapWastePercent=5"
    "-XX:G1MixedGCCountTarget=8"
)

if [ -z "${OPTIMIZE}" ] || [ "${OPTIMIZE}" = "(0) Geral" ]; then
    params+=("-Xms128M")
    params+=("-Xmx${SERVER_MEMORY:-1024}M")

    # Aikar's Flags
    params+=(
        "-XX:+UseG1GC"
        "-XX:+ParallelRefProcEnabled"
        "-XX:MaxGCPauseMillis=200"
        "-XX:+UnlockExperimentalVMOptions"
        "-XX:+AlwaysPreTouch"
        "-XX:G1NewSizePercent=30"
        "-XX:G1MaxNewSizePercent=40"
        "-XX:G1HeapRegionSize=8M"
        "-XX:G1ReservePercent=20"
        "-XX:G1HeapWastePercent=5"
        "-XX:G1MixedGCCountTarget=4"
        "-XX:InitiatingHeapOccupancyPercent=15"
        "-XX:G1MixedGCLiveThresholdPercent=90"
        "-XX:G1RSetUpdatingPauseTimePercent=5"
        "-XX:SurvivorRatio=32"
        "-XX:+PerfDisableSharedMem"
        "-XX:MaxTenuringThreshold=1"
        "-Dusing.aikars.flags=https://mcflags.emc.gs"
        "-Daikars.new.flags=true"
    )

elif [ "${OPTIMIZE}" = "(1) 1GB RAM" ]; then
    params+=("-Xmx1G" "-Xms1G" "-Xmn128m")
    params+=("${_legacy_gc[@]}")

elif [ "${OPTIMIZE}" = "(2) 2GB RAM" ]; then
    params+=("-Xms2G" "-Xmx2G" "-Xmn384m")
    params+=("${_legacy_gc[@]}")

elif [ "${OPTIMIZE}" = "(3) 3GB RAM" ]; then
    params+=("-Xms3G" "-Xmx3G" "-Xmn768m")
    params+=("${_legacy_gc[@]}")
    # Sobrescreve SoftRefLRUPolicyMSPerMB para cargas maiores
    params+=("-XX:SoftRefLRUPolicyMSPerMB=10000")

elif [ "${OPTIMIZE}" = "(4) 4+GB RAM" ]; then
    params+=("-Xms3584M" "-Xmx4G" "-Xmn768m")
    params+=("${_legacy_gc[@]}")
    params+=(
        "-XX:SoftRefLRUPolicyMSPerMB=10000"
        "-XX:+AlwaysPreTouch"
        "-XX:+ParallelRefProcEnabled"
        "-XX:+PerfDisableSharedMem"
        "-XX:-UsePerfData"
    )

elif [ "${OPTIMIZE}" = "(5) 4GB RAM / 4threads / 4cores" ]; then
    params+=("-Xms2G" "-Xmx2G" "-Xmn384m")
    params+=("${_g1_balanced[@]}")
    params+=(
        "-XX:+UseCompressedOops"
        "-XX:ParallelGCThreads=4"
        "-XX:ConcGCThreads=2"
        "-XX:InitiatingHeapOccupancyPercent=50"
        "-XX:G1HeapRegionSize=1"
    )

elif [ "${OPTIMIZE}" = "(6) 8+GB RAM / 8threads / 4cores" ]; then
    params+=("-Xms4G" "-Xmx4G" "-Xmn512m")
    params+=("${_g1_balanced[@]}")
    params+=(
        "-XX:ParallelGCThreads=8"
        "-XX:ConcGCThreads=2"
        "-XX:InitiatingHeapOccupancyPercent=50"
        "-XX:G1HeapRegionSize=1"
    )

elif [ "${OPTIMIZE}" = "(7) 12+GB RAM" ]; then
    params+=(
        "-Xms11G" "-Xmx11G"
        "-XX:+UseG1GC"
        "-XX:+ParallelRefProcEnabled"
        "-XX:MaxGCPauseMillis=200"
        "-XX:+UnlockExperimentalVMOptions"
        "-XX:+AlwaysPreTouch"
        "-XX:G1NewSizePercent=40"
        "-XX:G1MaxNewSizePercent=50"
        "-XX:G1HeapRegionSize=16M"
        "-XX:G1ReservePercent=15"
        "-XX:G1HeapWastePercent=5"
        "-XX:G1MixedGCCountTarget=4"
        "-XX:InitiatingHeapOccupancyPercent=20"
        "-XX:G1MixedGCLiveThresholdPercent=90"
        "-XX:G1RSetUpdatingPauseTimePercent=5"
        "-XX:SurvivorRatio=32"
        "-XX:+PerfDisableSharedMem"
        "-XX:MaxTenuringThreshold=1"
        "-Dusing.aikars.flags=https://mcflags.emc.gs"
        "-Daikars.new.flags=true"
    )
fi

if [ "${ALLOW_PLUGINS}" = "0" ]; then
    if [ -d "plugins" ] && ls plugins/*.jar 1>/dev/null 2>&1; then
        echo -e "${warning_plugins_not_allowed}"
        rm -f plugins/*.jar
    fi
fi

params+=("-jar" "${SERVER_JARFILE}")

printf "${running_optimization} ${bold}${lightblue}${OPTIMIZE:-Geral} ${normal}\n"
printf "${with_arguments} ${bold}${lightblue}${params[*]} ${normal}\n"

exec java "${params[@]}"