#!/bin/bash

set -e 


#test with dgoss
dgoss run -d  -p 5984:5984 -e COUCHDB_USER=admin -e COUCHDB_PASSWORD=admin_pass -e ROOT_PASSWORD=root_pass mercisi/ubuntu18-supervisord:couchdb




