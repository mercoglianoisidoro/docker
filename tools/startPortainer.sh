#!/bin/bash
docker run --name portainer -d -p 9005:9000  --restart unless-stopped  -v /var/run/docker.sock:/var/run/docker.sock  -l portainer=portainer -v portainer_data:/data portainer/portainer --no-auth
