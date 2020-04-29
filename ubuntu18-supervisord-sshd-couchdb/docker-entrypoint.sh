#!/bin/bash

set -e



if [ "$COUCHDB_USER" ] && [ "$COUCHDB_PASSWORD" ]; then
	echo "Creating admin user"
	printf "[admins]\n%s = %s\n" "$COUCHDB_USER" "$COUCHDB_PASSWORD" >> /home/couchdb/couchdb/etc/local.ini
fi

checkPermissionForData(){
if [ -w "/data" ] 
then
   echo "Write permission is granted on /data"
   exit 0
else
   echo "Write permission is NOT granted on /data"
   exit -1
fi
}
export -f checkPermissionForData

su couchdb -c "bash -c checkPermissionForData"

if [ $? -eq 0 ]
then
   /install.sh &
   /usr/bin/supervisord -n
else
	exit -1
fi
