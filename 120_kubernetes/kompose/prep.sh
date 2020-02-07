#!/bin/bash

curl -s https://api.github.com/repos/kubernetes/kompose/releases/latest | \
    jq --raw-output '.assets[] | select(.name | endswith("-linux-amd64")) | .browser_download_url' | \
    xargs curl -sLfo /usr/local/bin/kompose
chmod +x /usr/local/bin/kompose
