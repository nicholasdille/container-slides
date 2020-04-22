#!/bin/bash

curl -s https://api.github.com/repos/fluxcd/flux/releases/latest \
| jq --raw-output '.assets[] | select(.name == "fluxctl_linux_amd64") | .browser_download_url' \
| xargs curl -Lfo /usr/local/bin/fluxctl
chmod +x /usr/local/bin/fluxctl
