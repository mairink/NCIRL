#!/usr/bin/bash
TIMESTAMP=`date '+%Y/%m/%d-%H:%M'`;

sudo bash /etc/init.d/apache2 stop

echo "Apache stopped at  $TIMESTAMP"

echo "Apache stopped at  $TIMESTAMP" >> /home/testuser/log.log

 

