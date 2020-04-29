
#!/bin/bash

#set up couchdb
#install: see http://docs.couchdb.org/en/stable/install/setup.html

if [ -z  "$COUCHDB_USER" ] && [ -z  "$COUCHDB_PASSWORD" ]; then
   CREDS="$COUCHDB_USER:$COUCHDB_PASSWORD@"
else
   CREDS=""
fi

until $(curl --connect-timeout 1 -s --output /dev/null --head --fail -X GET "http://${CREDS}127.0.0.1:5984/"); do
    echo "waiting service to install couchdb . . . . ."
    sleep 1
done


#check if _user db already exist, otherwise create it
result=$(curl --connect-timeout 1 -s -X GET "http://${CREDS}127.0.0.1:5984/_users" | jq .db_name )
if [ "$result" != '"_users"' ]
then 
    echo "creating system database _users"
    curl -s -X PUT "http://${CREDS}127.0.0.1:5984/_users"
    curl -s -X PUT "http://${CREDS}127.0.0.1:5984/_users/_security" \
-H "Content-Type: application/json" \
-d '{"admins":{"names":["admin"]},"members":{"names":["admin"]}}' 

else
    echo "system database _users already created"
fi

#check if _replicator db already exist, otherwise create it
result=$(curl --connect-timeout 1 -s -X GET "http://${CREDS}127.0.0.1:5984/_replicator" | jq .db_name )
if [ "$result" != '"_replicator"' ]
then 
    echo "creating system database _replicator"
    curl -s -X PUT "http://${CREDS}127.0.0.1:5984/_replicator"
    curl -s -X PUT "http://${CREDS}127.0.0.1:5984/_replicator/_security" \
-H "Content-Type: application/json" \
-d '{"admins":{"names":["admin"]},"members":{"names":["admin"]}}' 

else
    echo "system database _replicator already created"
fi
