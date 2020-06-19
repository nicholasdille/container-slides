#!/bin/bash

curl --silent https://api.github.com/repos/kubernetes/kompose/releases/latest | \
    jq --raw-output '.assets[] | select(.name | endswith("-linux-amd64")) | .browser_download_url' | \
    xargs curl --silent --location --fail --output /usr/local/bin/kompose
chmod +x /usr/local/bin/kompose
