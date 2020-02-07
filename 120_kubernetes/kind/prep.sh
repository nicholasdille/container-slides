#!/bin/bash

curl -s https://api.github.com/repos/kubernetes-sigs/kind/releases/latest | \
    jq --raw-output '.assets[] | select(.name == "kind-linux-amd64") | .browser_download_url' | \
    xargs curl -sLfo /usr/local/bin/kind
chmod +x /usr/local/bin/kind
