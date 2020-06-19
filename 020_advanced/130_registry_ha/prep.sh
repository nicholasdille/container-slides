#!/bin/bash

curl --silent https://api.github.com/repos/docker/compose/releases/latest | \
        jq --raw-output '.assets[] | select(.name | endswith("-Linux-x86_64")) | .browser_download_url' | \
        xargs curl --silent --location --fail --output /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
