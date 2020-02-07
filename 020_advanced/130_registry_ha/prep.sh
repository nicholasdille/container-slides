#!/bin/bash

curl -s https://api.github.com/repos/docker/compose/releases/latest | \
        jq --raw-output '.assets[] | select(.name | endswith("-Linux-x86_64")) | .browser_download_url' | \
        xargs curl -sLfo /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
