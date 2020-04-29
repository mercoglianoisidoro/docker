#!/bin/bash

#
# This is just a rapid test using curl 
# It represent also a rapid HowTo (search for word HowTo)
#

couchdb_address=127.0.0.1
db=test
port=5984
userAdmin=admin
passAdmin=admin_pass

#testing
#COUCHDB_USER=admin
#COUCHDB_PASSWORD=admin_pass
#couchdb_address=localhost

unset http_proxy

until $(curl --connect-timeout 1 -s --output /dev/null --head --fail -X GET "http://$couchdb_address:$port"); do
    echo "waiting service to install couchdb . . . . ."
    sleep 1
done


removeQuotesAndDiaplyResult(){
    echo "result = $1"
    result=$( echo $1 | sed -e 's/^"//' -e 's/"$//' )
    
}




#-----------------------------------
# Working with DB
# HowTo delete database
# HowTo create database
#-----------------------------------

# imposossible to create/delete without user db

result=$(curl -s -X PUT "http://$couchdb_address:$port/$db" | jq .error )
removeQuotesAndDiaplyResult $result
if [ "$result" != "unauthorized" ]; then 
    echo "problem with put -> unauthorized"
    exit 1
else
    echo "test ok"
fi

result=$(curl -s -X DELETE "http://$couchdb_address:$port/$db" | jq .error )
removeQuotesAndDiaplyResult $result
if [ "$result" != "unauthorized" ]; then 
    echo "problem with DELETE -> unauthorized"
    exit 1
else
    echo "test ok"
fi


#user admin ok

curl -s -X DELETE "http://$userAdmin:$passAdmin@$couchdb_address:$port/$db" #delete if exist
#create
result=$( curl -s -X PUT "http://$userAdmin:$passAdmin@$couchdb_address:$port/$db"  | jq .ok )
removeQuotesAndDiaplyResult $result
if [ "$result" != "true" ]; then 
    echo "problem in creating db with user admin"
    exit 1
else
        echo "test ok"
fi

#delete
curl -s -X DELETE "http://$userAdmin:$passAdmin@$couchdb_address:$port/$db" #delete if exist
result=$( curl -s -X DELETE "http://$userAdmin:$passAdmin@$couchdb_address:$port/$db"  | jq .error )
removeQuotesAndDiaplyResult $result
if [ "$result" != "not_found" ]; then 
    echo "problem in delete db with user admin"
    exit 1l
else
        echo "test ok"
fi


#-----------------------------------
# Working with documents
# HowTo add documents
# HowTo delete documents
#-----------------------------------

#if we got here, we can create and delete db
curl -s -X DELETE "http://$userAdmin:$passAdmin@$couchdb_address:$port/$db"

#database doesn't exist
result=$(curl -s -X DELETE "http://$couchdb_address:$port/test_db_non_existing/document_id" -d '{"document_name":"document test"}' | jq .error )
removeQuotesAndDiaplyResult $result
if [ "$result" != "not_found" ]; then 
    echo "got = $result"
    echo "problem delete -> not_found"
    exit 1
else
        echo "test ok"
fi

#database doesn't exist - with user admin 
result=$(curl -s -X DELETE "http://$userAdmin:$passAdmin@$couchdb_address:$port/test_db_non_existing/document_id" -d '{"document_name":"document test"}' | jq .error )
removeQuotesAndDiaplyResult $result
if [ "$result" != "not_found" ]; then 
    echo "got = $result"
    echo "problem delete (user admin) -> not_found"
    exit 1
else
        echo "test ok"
fi



curl -s -X PUT "http://$userAdmin:$passAdmin@$couchdb_address:$port/$db"
#now we have the db

#until now DB is non protected by users, so it's public
result=$(curl -s -X PUT "http://$couchdb_address:$port/$db/document_id" -d '{"document_name":"document test"}' | jq .ok )
removeQuotesAndDiaplyResult $result
if [ "$result" != "true" ]; then 
    echo "got = $result"
    echo "problem creating document"
    exit 1
else
        echo "test ok"
fi


result=$(curl -s -X PUT "http://$userAdmin:$passAdmin@$couchdb_address:$port/$db/document_id_withUserAdmin" -d '{"document_name":"document test"}' | jq .ok )
removeQuotesAndDiaplyResult $result
if [ "$result" != "true" ]; then 
    echo "got = $result"
    echo "problem creating document with user admin"
    exit 1
else
        echo "test ok"
fi


result=$(curl -s -X PUT "http://$userAdmin:$passAdmin@$couchdb_address:$port/$db/document_id_withUserAdmin" -d '{"document_name":"document test"}' | jq .error )
removeQuotesAndDiaplyResult $result
if [ "$result" != "conflict" ]; then 
    echo "got = $result"
    echo "problem creating document: should fail"
    exit 1
else
        echo "test ok"
fi


#curl -s -X PUT "http://$couchdb_address:$port/$db/document_id2" -d "{"document_name":"document test"}" | jq .

curl -s -X DELETE "http://$userAdmin:$passAdmin@$couchdb_address:$port/$db"





echo "TEST USERS"


#-----------------------------------
# managing users and user right
# HowTo create user
# HowTo provide rights to db
#-----------------------------------

#create user

# first step create _user DB
curl -s -X DELETE "http://$userAdmin:$passAdmin@$couchdb_address:$port/_users" | jq .
curl -s -X PUT "http://$userAdmin:$passAdmin@$couchdb_address:$port/_users" | jq .

# then the add user with USERNAME:PASS
result=$(
curl -s -X PUT "http://$userAdmin:$passAdmin@$couchdb_address:$port/_users/org.couchdb.user:USERNAME" \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-d '{"name":"USERNAME","password":"PASS","roles":[],"type":"user"}'  | jq .ok
)
removeQuotesAndDiaplyResult $result
if [ "$result" != "true" ]; then 
    echo "got = $result"
    echo "problem creating user"
    exit 1
else
        echo "test ok"
fi

#add rights to $db
#fist step create db
curl -s -X PUT "http://$userAdmin:$passAdmin@$couchdb_address:$port/$db"
#add right
result=$(
curl -s -X PUT "http://$userAdmin:$passAdmin@$couchdb_address:$port/$db/_security" \
-H "Content-Type: application/json" \
-d '{"admins":{"names":[],"roles":[]},"members":{"names":["USERNAME"],"roles":[]}}' | jq .ok
)
removeQuotesAndDiaplyResult $result
if [ "$result" != "true" ]; then 
    echo "got = $result"
    echo "problem doing right to db"
    exit 1
else
        echo "test ok"
fi

#now we can't access to db in public mode
result=$(curl -s -X PUT "http://$couchdb_address:$port/$db/document_id" -d '{"document_name":"document test"}' | jq .error )
removeQuotesAndDiaplyResult $result
if [ "$result" != "unauthorized" ]; then 
    echo "got = $result"
    echo "problem: db still public mode?"
    exit 1
else
        echo "test ok"
fi

#but user USERNAME:PASS can access
result=$(curl -s -X PUT "http://USERNAME:PASS@$couchdb_address:$port/$db/document_id_USERNAME" -d '{"document_name":"document test"}' | jq .ok )
removeQuotesAndDiaplyResult $result
if [ "$result" != "true" ]; then 
    echo "got = $result"
    echo "problem: can't access with  USERNAME:PASS"
    exit 1
else
        echo "test ok"
fi


curl -s -X DELETE "http://$userAdmin:$passAdmin@$couchdb_address:$port/_users" | jq .
