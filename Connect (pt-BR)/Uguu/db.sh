#!/bin/bash
## Instalando Postgres
if [ ! -f "/mnt/server/logs/database_instalado" ]; then
    # Comandos a serem executados se estiver na pasta /mnt/server/
    # Server Files: /mnt/server
    adduser -D -h /home/container container
    chown -R container: /mnt/server/
    su container -c 'initdb -D /mnt/server/DB/ -A md5 -U "$PGUSER" --pwfile=<(echo "$PGPASSWORD")'
    mkdir -p /mnt/server/DB/run/
    ## Add default "allow from all" auth rule to pg_hba
    if ! grep -q "# Custom rules" "/mnt/server/DB/pg_hba.conf"; then
        echo -e "# Custom rules\nhost all all 0.0.0.0/0 md5" >>"/mnt/server/DB/pg_hba.conf"
    fi
    echo -e "Done"
    if [ ! -d "/mnt/server/logs" ]; then
        mkdir logs
    fi
    touch /mnt/server/logs/database_instalado
fi
