#!/usr/bin/bash
#restart MYSQL Sevrer

TIMESTAMP=`date '+%Y/%m/%d-%H:%M'`;

sudo bash /etc/init.d/mysql restart

echo "MySql restarted at  $TIMESTAMP"

echo "MySql  restarted at  $TIMESTAMP" >> /home/testuser/log.log


