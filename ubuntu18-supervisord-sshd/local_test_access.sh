#!/bin/bash

 ssh-keygen -f ~/.ssh/known_hosts -R [localhost]:2200



set -e

sshpass -p 'passroot'  ssh -o "StrictHostKeyChecking=no" root@localhost -p 2200 "whoami" 

if [ "$?" != "0" ]; then 
    exit 1
else
    echo "test ok"
fi