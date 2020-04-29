#!/bin/bash

set -e 

docker pull mercisi/ubuntu18-supervisord:sshd-couchdb

#test with dgoss
dgoss run -d  -p 5984:5984 -p 2222:22 \
  -e COUCHDB_USER=admin -e COUCHDB_PASSWORD=admin_pass -e ROOT_PASSWORD=root_pass  \
  --mount source=supervisord_couchdbDATA,target=/data \
  --name supervisord_couchdb mercisi/ubuntu18-supervisord:sshd-couchdb




