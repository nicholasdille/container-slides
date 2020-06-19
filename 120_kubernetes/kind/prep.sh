#!/bin/bash

curl --silent https://api.github.com/repos/kubernetes-sigs/kind/releases/latest | \
    jq --raw-output '.assets[] | select(.name == "kind-linux-amd64") | .browser_download_url' | \
    xargs curl --silent --location --fail --output /usr/local/bin/kind
chmod +x /usr/local/bin/kind
