#!/bin/bash

set -e 

docker pull mercisi/ubuntu18-supervisord:sshd

#test with dgoss
dgoss run -d -p 2200:22 -e ROOT_PASSWORD=root_pass --name ubuntu18-supervisord_testing mercisi/ubuntu18-supervisord:sshd


