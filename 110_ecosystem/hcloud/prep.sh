#!/bin/bash

curl -s https://api.github.com/repos/hetznercloud/cli/releases/latest | \
    jq --raw-output '.assets[] | select(.name == "hcloud-linux-amd64.tar.gz") | .browser_download_url' | \
    xargs curl -sLf | \
    tar -xvzC ~/.local/bin/ hcloud
