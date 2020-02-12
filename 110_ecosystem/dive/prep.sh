#!/bin/bash

curl -s https://api.github.com/repos/wagoodman/dive/releases/latest | \
    jq --raw-output '.assets[] | select(.name | endswith("_linux_amd64.tar.gz")) | .browser_download_url' | \
    xargs curl -sLf | \
    tar -xvzC /usr/local/bin/ dive
