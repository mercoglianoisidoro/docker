#!/bin/bash

#remove:
docker rm -f -v $(docker ps -aqf "name=mercisi-ubuntu18-supervisord-sshd")
docker rmi $(docker images | grep -E "mercisi-ubuntu18-supervisord-sshd" |  awk '{ print $3; }')
ssh-keygen -f ~/.ssh/known_hosts -R [localhost]:2200



docker build -t mercisi--ubuntu18-supervisord:sshd .
docker run -d -p 2200:22 -e ROOT_PASSWORD=passroot --name mercisi-ubuntu18-supervisord-sshd  mercisi--ubuntu18-supervisord:sshd

#docker exec -it mercisi-ubuntu18-supervisord-sshd bash