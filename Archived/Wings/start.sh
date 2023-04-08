#!/bin/ash
# shellcheck shell=dash
if [ -f "./wings" ]; then
    #!/bin/sh
    set -e

    if [ "${1#-}" != "$1" ]; then
        set -- docker "$@"
    fi

    if docker help "$1" >/dev/null 2>&1; then
        set -- docker "$@"
    fi

    if [ -z "$DOCKER_HOST" -a "$DOCKER_PORT_2375_TCP" ]; then
        export DOCKER_HOST='tcp://docker:2375'
    fi

    exec "$@"
    ./wings --debug --config ./config.yml
else
    bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Wings/install.sh) | tee logs/terminal.log
fi
