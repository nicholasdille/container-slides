#!/bin/bash

# k3sup
#curl -sLS https://get.k3sup.dev | sh
curl -s https://api.github.com/repos/alexellis/k3sup/releases/latest | \
    jq --raw-output '.assets[] | select(.name == "k3sup") | .browser_download_url' | \
    xargs curl -sLfo /usr/local/bin/k3sup
chmod +x /usr/local/bin/k3sup
