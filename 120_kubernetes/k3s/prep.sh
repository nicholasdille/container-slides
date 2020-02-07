#!/bin/bash

# kubectl
curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt | \
        xargs -I{} curl -sLo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/{}/bin/linux/amd64/kubectl
chmod +x /usr/local/bin/kubectl

# k3d
curl -s https://raw.githubusercontent.com/rancher/k3d/master/install.sh | bash
