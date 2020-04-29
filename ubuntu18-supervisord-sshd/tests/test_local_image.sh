#!/bin/bash

ssh-keygen -f ~/.ssh/known_hosts -R [localhost]:2200



dgoss run -d -p 2222:22 -e ROOT_PASSWORD=root_pass --name mercisi_ubuntu18-supervisord-ssh_testing mercisi--ubuntu18-supervisord:sshd

