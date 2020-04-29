Description
========

Basic image perfect to testing multiple services inside à container.
Service sshd already installed.


# Use image from dockerhub

Image name : *image mercisi/ubuntu18-supervisord:sshd*

## usage example:

docker run -d -p 2200:22 -e ROOT_PASSWORD=passroot --name mercisi-ubuntu18-supervisord-ssh  mercisi/ubuntu18-supervisord:sshd


