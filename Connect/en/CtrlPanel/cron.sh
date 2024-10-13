#!/bin/bash

while true; do

  php /home/container/controlpanel/artisan schedule:run >>/dev/null 2>&1 && /bin/bash /crontab_test.sh

  sleep 60
done
