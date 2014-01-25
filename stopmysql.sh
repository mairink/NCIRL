#!/usr/bin/bash
TIMESTAMP=`date '+%Y/%m/%d-%H:%M'`;

sudo bash /etc/init.d/mysql stop
apt-get update
echo "MySQL stopped at  $TIMESTAMP"

echo "MYsQL stopped at  $TIMESTAMP" >> /home/testuser/log.log


