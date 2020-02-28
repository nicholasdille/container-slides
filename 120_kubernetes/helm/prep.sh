#!/bin/bash

curl -Ls -o /dev/null -w %{url_effective} https://github.com/helm/helm/releases/latest | \
    grep -oE "[^/]+$" | \
    xargs -I{} curl -sL "https://get.helm.sh/helm-{}-linux-amd64.tar.gz" | \
    tar -xvz --strip-components=1 -C /usr/local/bin/ linux-amd64/helm
