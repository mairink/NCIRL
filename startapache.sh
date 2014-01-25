#!/usr/bin/bash
#start Apache Sevrer

TIMESTAMP=`date '+%Y/%m/%d-%H:%M'`;

sudo bash /etc/init.d/apache2 restart

echo "Apache restarted at  $TIMESTAMP"

echo "Apache restarted at  $TIMESTAMP" >> /home/testuser/log.log



