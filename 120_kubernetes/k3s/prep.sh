#!/bin/bash

# kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin/

# k3d
curl -s https://raw.githubusercontent.com/rancher/k3d/master/install.sh | bash
