#!/bin/bash
set -u

BASE_DIR="/mnt/server"
[[ -d "/home/container" ]] && BASE_DIR="/home/container"
cd "$BASE_DIR" || exit 1

HAS_NATIVE_JELLYFIN=0
if command -v jellyfin >/dev/null 2>&1; then
    HAS_NATIVE_JELLYFIN=1
fi

SCRIPT_VERSION="2.4"
printf "${script_version:-Script Version: %s}\n" "$SCRIPT_VERSION"

mkdir -p logs tmp data cache .config/jellyfin logs/jellyfin

if [[ ! -f "./nginx/nginx.conf" || ! -f "./nginx/conf.d/default.conf" || ! -f "./.config/jellyfin/network.xml" ]]; then
    bash <(curl -sSL https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Jellyfin/install.sh)
fi

if [[ "$BASE_DIR" == "/mnt/server" ]]; then
    echo "${installation_complete:-Done.}"
    exit 0
fi

if [[ -n "${SERVER_PORT:-}" ]]; then
    [[ -f "./nginx/conf.d/default.conf" ]] && sed -i -e "s/listen.*/listen ${SERVER_PORT};/g" nginx/conf.d/default.conf
fi

echo "${permissions:-Setting file permissions...}"
chmod 777 -R ./* 2>/dev/null || true

FFMPEG_BIN=""
for candidate in "/usr/lib/jellyfin-ffmpeg/ffmpeg" "/usr/bin/ffmpeg" "/usr/local/bin/ffmpeg" "$(command -v ffmpeg 2>/dev/null || true)" "$(command -v jellyfin-ffmpeg 2>/dev/null || true)"; do
    if [[ -n "$candidate" && -x "$candidate" ]]; then
        FFMPEG_BIN="$candidate"
        break
    fi
done
if [[ -n "$FFMPEG_BIN" ]]; then
    printf "${ffmpeg_using:-Using FFmpeg: %s}\n" "$FFMPEG_BIN"
    FFMPEG_ARG=(--ffmpeg "$FFMPEG_BIN")
else
    echo "${ffmpeg_missing:-FFmpeg not found, starting without --ffmpeg.}"
    FFMPEG_ARG=()
fi

echo "${starting_nginx:-Starting Nginx...}"
if [[ -f "./nginx/nginx.conf" ]]; then
    nohup /usr/sbin/nginx -c "$BASE_DIR/nginx/nginx.conf" -p "$BASE_DIR/" 2>&1 &
else
    echo "⚠️ nginx/nginx.conf not found, skipping Nginx."
fi

WEBDIR=""
for candidate in "/usr/share/jellyfin/web" "/usr/lib/jellyfin/bin/jellyfin-web"; do
    if [[ -d "$candidate" && -n "$(ls -A "$candidate" 2>/dev/null)" ]]; then
        WEBDIR="$candidate"
        break
    fi
done

JELLY_ARGS=(
    --datadir "$BASE_DIR/data"
    --configdir "$BASE_DIR/.config/jellyfin"
    --cachedir "$BASE_DIR/cache"
    --logdir "$BASE_DIR/logs/jellyfin"
)
if [[ -n "$WEBDIR" ]]; then
    printf "${webdir_using:-Using web client: %s}\n" "$WEBDIR"
    JELLY_ARGS+=(--webdir "$WEBDIR")
fi

if [[ "$HAS_NATIVE_JELLYFIN" == "1" ]]; then
    echo "${starting_standalone:-Starting Jellyfin (standalone)...}"
    exec jellyfin "${JELLY_ARGS[@]}" ${FFMPEG_ARG[@]+"${FFMPEG_ARG[@]}"}
fi

if [[ -x "./jellyfin/jellyfin" ]]; then
    echo "${starting_portable_bin:-Starting Jellyfin (portable binary)...}"
    exec ./jellyfin/jellyfin "${JELLY_ARGS[@]}" ${FFMPEG_ARG[@]+"${FFMPEG_ARG[@]}"}
fi

if [[ -f "./jellyfin/jellyfin.dll" ]]; then
    echo "${starting_dotnet:-Starting Jellyfin (dotnet jellyfin.dll)...}"
    exec dotnet jellyfin/jellyfin.dll "${JELLY_ARGS[@]}" ${FFMPEG_ARG[@]+"${FFMPEG_ARG[@]}"}
fi

echo "${no_jellyfin:-Jellyfin not found. Reinstall the server.}"
exit 1
