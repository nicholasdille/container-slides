#!/bin/bash

#curl --silent https://api.github.com/repos/moby/buildkit/releases/latest | \
curl --silent https://api.github.com/repos/moby/buildkit/releases | jq 'map(select(.tag_name | startswith("v"))) | .[0]' | \
    jq --raw-output '.assets[] | select(.name | endswith(".linux-amd64.tar.gz")) | .browser_download_url' | \
    xargs curl --silent --location --fail | \
    tar -xvzC /usr/local/

curl --silent https://api.github.com/repos/moby/buildkit/releases | \
    jq --raw-output 'map(select(.tag_name | startswith("v"))) | .[0].tag_name' | \
    xargs -I{} curl --location --fail --output /usr/local/bin/buildctl-daemonless.sh https://github.com/moby/buildkit/raw/{}/examples/buildctl-daemonless/buildctl-daemonless.sh
chmod +x /usr/local/bin/buildctl-daemonless.sh
