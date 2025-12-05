#!/bin/bash

curl --silent --location --fail https://api.github.com/repos/aelsabbahy/goss/releases/latest | \
    jq --raw-output '.assets[] | select(.name | contains("-linux-amd64")) | .browser_download_url' | \
    xargs curl --silent --location --fail --output /usr/local/bin/goss
chmod +x /usr/local/bin/goss

curl --silent --location --fail https://api.github.com/repos/aelsabbahy/goss/releases/latest | \
    jq --raw-output '.assets[] | select(.name == "dgoss") | .browser_download_url' | \
    xargs curl --silent --location --fail --output /usr/local/bin/dgoss
chmod +x /usr/local/bin/dgoss
