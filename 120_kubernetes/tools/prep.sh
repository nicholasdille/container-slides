#!/bin/bash

VERSION=$(curl --silent https://api.github.com/repos/ahmetb/kubectx/releases/latest | jq --raw-output '.tag_name')
curl --silent --location --fail --output /usr/local/bin/kubectx https://github.com/ahmetb/kubectx/raw/${VERSION}/kubectx
curl --silent --location --fail --output /usr/local/bin/kubens https://github.com/ahmetb/kubectx/raw/${VERSION}/kubens
chmod +x /usr/local/bin/{kubectx,kubens}

curl --silent https://api.github.com/repos/robscott/kube-capacity/releases/latest | \
    jq --raw-output '.assets[] | select(.name | endswith("_Linux_x86_64.tar.gz")) | .browser_download_url' | \
    xargs curl --silent --location --fail | \
    tar -xvzC /usr/local/bin/ kube-capacity
