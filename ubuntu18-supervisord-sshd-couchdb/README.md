Description
========

Basic image perfect to testing multiple services inside à container.
Service sshd and couchdb already installed.


# Use image from dockerhub

Image name : *image mercisi/ubuntu18-supervisord:sshd-couchdb*

## usage example:

docker run -d  -p 5984:5984 -p 2222:22  \
-e COUCHDB_USER=admin -e COUCHDB_PASSWORD=admin_pass \
-e ROOT_PASSWORD=root_pass \
--mount source=couchdbDATA,target=/data \
--name mercisi-ubuntu18-supervisord-ssh-couchdb mercisi/ubuntu18-supervisord:sshd-couchdb


