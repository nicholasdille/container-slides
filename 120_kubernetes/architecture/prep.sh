#!/bin/bash

curl --silent https://api.github.com/repos/kubernetes-sigs/kind/releases/latest | \
    jq --raw-output '.assets[] | select(.name == "kind-linux-amd64") | .browser_download_url' | \
    xargs curl --location --fail --output /usr/local/bin/kind
chmod +x /usr/local/bin/kind

curl --silent https://storage.googleapis.com/kubernetes-release/release/stable.txt | \
    xargs -I{} curl --location --output /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/{}/bin/linux/amd64/kubectl
chmod +x /usr/local/bin/kubectl
cat >>~/.bashrc <<EOF
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
EOF
