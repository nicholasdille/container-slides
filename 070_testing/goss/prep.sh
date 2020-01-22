#!/bin/bash

curl -sLf https://api.github.com/repos/aelsabbahy/goss/releases/latest | jq --raw-output '.assets[] | select(.name | contains("-linux-amd64")) | .browser_download_url' | xargs curl -sLfo /usr/local/bin/goss
chmod +x /usr/local/bin/goss

curl -sLf https://api.github.com/repos/aelsabbahy/goss/releases/latest | jq --raw-output '.assets[] | select(.name == "dgoss") | .browser_download_url' | xargs curl -sLfo /usr/local/bin/dgoss
chmod +x /usr/local/bin/dgoss
