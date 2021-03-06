#!/bin/bash

curl --silent https://api.github.com/repos/k14s/ytt/releases/latest | \
    jq --raw-output '.assets[] | select(.name | endswith("-linux-amd64")) | .browser_download_url' | \
    xargs curl --silent --location --fail --output /usr/local/bin/ytt
chmod +x /usr/local/bin/ytt
