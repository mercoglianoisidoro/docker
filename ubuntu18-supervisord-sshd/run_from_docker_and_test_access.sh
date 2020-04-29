#!/bin/bash



#remove:
docker rm -f -v $(docker ps -aqf "name=mercisi-ubuntu18-supervisord-sshd")
docker rmi $(docker images | grep -E "mercisi-ubuntu18-supervisord-sshd" |  awk '{ print $3; }')

set -e

docker run -d -p 2200:22 -e ROOT_PASSWORD=passroot --name mercisi-ubuntu18-supervisord-sshd  mercisi/ubuntu18-supervisord:sshd
sleep 5

ssh-keygen -f ~/.ssh/known_hosts -R [localhost]:2200
sshpass -p 'passroot'  ssh -o "StrictHostKeyChecking=no" root@localhost -p 2200 "whoami" 

if [ "$?" != "0" ]; then 
    exit 1
else
    echo "test ok"
fi