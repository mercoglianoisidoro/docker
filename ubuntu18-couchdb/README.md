Description
========

Coudhdb image, version 2.3.1.
Based on ubuntu 18 LTS


# Use image from dockerhub

Image name : *image mercisi/ubuntu18:couchdb*

## usage example:

docker run -d  -p 5984:5984 -p 2222:22  \
-e COUCHDB_USER=admin -e COUCHDB_PASSWORD=admin_pass \
--mount source=couchdbDATA,target=/data \
--name mercisi-ubuntu18-supervisord-ssh-couchdb mercisi/ubuntu18:couchdb


