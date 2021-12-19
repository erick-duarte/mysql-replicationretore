#!/bin/bash

MASTERIP='IP'
MASTERUSER='USER'
MASTERPASS='PASS'

MASTERFILE=$(/usr/bin/mysql -u $MASTERUSER -p$MASTERPASS -h $MASTERIP -e 'SHOW MASTER STATUS \G' | grep 'File:' | cut -d":" -f2 | cut -d" " -f2)
MASTERPOSITIONS=$(/usr/bin/mysql -u $MASTERUSER -p$MASTERPASS -h $MASTERIP -e 'SHOW MASTER STATUS \G' | grep 'Position:' | cut -d":" -f2 | cut -d" " -f2)
SYNCSTATUS=$(/usr/bin/mysql -u $MASTERUSER -p$MASTERPASS -e 'show slave status \G' | /usr/bin/grep -E "Slave_IO_Running:|Slave_SQL_Running:" | /usr/bin/awk '{print $2}' | /usr/bin/grep -c Yes)

if [ "${SYNCSTATUS}" -le "1" ]
then
    echo "CHANGE MASTER TO MASTER_HOST='$MASTERIP', \
        MASTER_USER='$MASTERUSER', \
        MASTER_PASSWORD='$MASTERPASS', \
        MASTER_LOG_FILE='$MASTERFILE', \
        MASTER_LOG_POS=$MASTERPOSITIONS; START SLAVE;" | /usr/bin/mysql -u $MASTERUSER -p$MASTERPASS
fi
