#!/bin/bash

set -e

echo "executing docker-entrypoint.sh"


if [ "$COUCHDB_USER" ] && [ "$COUCHDB_PASSWORD" ];
then
	echo "Creating admin user"
	printf "[admins]\n%s = %s\n" "$COUCHDB_USER" "$COUCHDB_PASSWORD" >> /home/couchdb/couchdb/etc/local.ini
fi


if [ -w "/data" ] 
then
   echo "Write permission is granted on /data"
else
   echo "Write permission is NOT granted on /data"
   exit -1
fi

/install.sh 2>&1 &
/home/couchdb/couchdb/bin/couchdb

