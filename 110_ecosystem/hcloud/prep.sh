#!/bin/bash

curl --silent https://api.github.com/repos/hetznercloud/cli/releases/latest | \
    jq --raw-output '.assets[] | select(.name == "hcloud-linux-amd64.tar.gz") | .browser_download_url' | \
    xargs curl --silent --location --fail | \
    tar -xvzC ~/.local/bin/ hcloud
