#!/bin/bash

# kubectl
curl --silent https://storage.googleapis.com/kubernetes-release/release/stable.txt | \
    xargs -I{} curl --silent --location --output /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/{}/bin/linux/amd64/kubectl
chmod +x /usr/local/bin/kubectl
cat >>~/.bashrc <<EOF
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
EOF

# k3s
curl --silent https://api.github.com/repos/rancher/k3s/releases/latest | \
    jq --raw-output '.assets[] | select(.name == "k3s") | .browser_download_url' | \
    xargs curl --silent --location --fail --output /usr/local/bin/k3s
chmod +x /usr/local/bin/k3s

# k3d
curl --silent https://raw.githubusercontent.com/rancher/k3d/master/install.sh | bash

