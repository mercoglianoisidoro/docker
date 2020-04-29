#!/bin/bash


#juste to test locally:

#remove and create volumes
docker volume rm couchdbDATA
docker volume create couchdbDATA

#remove container:
docker rm -f -v $(docker ps -aqf "name=mercisi-ubuntu18-supervisord-ssh-couchdb")

#remove  image:
docker rmi $(docker images | grep -E "mercisi-ubuntu18-supervisord-ssh-couchdb" |  awk '{ print $3; }')

#build
docker build -t mercisi--ubuntu18-supervisord:ssh-couchdb .

#run
docker run -d  -p 5984:5984 -p 2222:22  \
-e COUCHDB_USER=admin -e COUCHDB_PASSWORD=admin_pass \
-e ROOT_PASSWORD=root_pass \
--mount source=couchdbDATA,target=/data \
--name mercisi-ubuntu18-supervisord-ssh-couchdb mercisi--ubuntu18-supervisord:ssh-couchdb


#to see logs:
#docker logs -f $(docker ps -aqf "name=mercisi-ubuntu18-supervisord-ssh-couchdb")

# docker exec -it mercisi-ubuntu18-supervisord-ssh-couchdb bash
 






