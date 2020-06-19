#!/bin/bash

curl --silent https://api.github.com/repos/tektoncd/cli/releases/latest | \
    jq --raw-output '.assets[] | select(.name | endswith("_Linux_x86_64.tar.gz")) | .browser_download_url' | \
    xargs curl --silent --location --fail | tar -xvzC /usr/local/bin/ tkn
