#!/bin/bash

set -e 


#test with dgoss

#test with dgoss
#into test_dockerhub_image directory
dgoss run -d  -p 5984:5984 -p 2222:22  \
-e COUCHDB_USER=admin -e COUCHDB_PASSWORD=admin_pass \
-e ROOT_PASSWORD=root_pass \
--name goss_testing mercisi--ubuntu18-supervisord:ssh-couchdb








