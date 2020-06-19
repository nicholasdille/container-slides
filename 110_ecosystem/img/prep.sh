#!/bin/sh

curl --silent https://api.github.com/repos/genuinetools/img/releases/latest | \
    jq --raw-output '.assets[] | select(.name == "img-linux-amd64") | .browser_download_url' | \
    xargs curl --silent --location --fail --output /usr/local/bin/img
chmod +x /usr/local/bin/img
