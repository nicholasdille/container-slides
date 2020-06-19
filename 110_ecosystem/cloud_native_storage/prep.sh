#!/bin/bash

curl --silent https://api.github.com/repos/deislabs/oras/releases/latest | \
    jq --raw-output '.assets[] | select(.name | endswith("_linux_amd64.tar.gz")) | .browser_download_url' | \
    xargs curl --silent --location --fail | \
    tar -xvzC /usr/local/bin/ oras
