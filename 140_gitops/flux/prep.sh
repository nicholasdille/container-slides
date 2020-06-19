#!/bin/bash

curl --silent https://api.github.com/repos/fluxcd/flux/releases/latest \
| jq --raw-output '.assets[] | select(.name == "fluxctl_linux_amd64") | .browser_download_url' \
| xargs curl --location --fail --output /usr/local/bin/fluxctl
chmod +x /usr/local/bin/fluxctl
