#!/bin/sh

curl -s https://api.github.com/repos/genuinetools/img/releases/latest | \
    jq --raw-output '.assets[] | select(.name == "img-linux-amd64") | .browser_download_url' | \
    xargs curl -sLfo /usr/local/bin/img
chmod +x /usr/local/bin/img
