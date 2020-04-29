#!/bin/bash

set -e



if [ -z "$ROOT_PASSWORD" ]; then
	# Create root pass for ssh service
	echo "root:$ROOT_PASSWORD" | chpasswd
	echo "entrypoint : root password set"
   exit 0
else
   echo 'entrypoint : No password set for service sshd for user root; please check env variables'
fi
