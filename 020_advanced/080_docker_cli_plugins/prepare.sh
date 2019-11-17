#!/bin/bash

# Prepare local registry
mkdir -p auth
docker run --entrypoint htpasswd registry:2 \
    -Bbn testuser testpassword > auth/htpasswd
docker run -d -p 127.0.0.1:5000:5000 --name registry \
    --mount type=bind,source=$(pwd)/auth,target=/auth \
    --env REGISTRY_AUTH=htpasswd \
    --env REGISTRY_AUTH_HTPASSWD_REALM=registry \
    --env REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
    registry:2

# Install CLIP
FILEPATH=lukaszlach/clip/master/docker-clip
curl -sLfO https://raw.githubusercontent.com/${FILEPATH}
mv docker-clip ~/.docker/cli-plugins/
chmod +x ~/.docker/cli-plugins/docker-clip
