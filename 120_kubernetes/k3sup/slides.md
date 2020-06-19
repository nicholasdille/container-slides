## k3sup provisions k3s via SSH

### [k3sup](https://github.com/alexellis/k3sup) is made by [Alex Ellis](https://github.com/alexellis)

- Deploy `k3s` on a remote host
- Join host to `k3s` cluster
- Prerequisites: SSH

### Demo: Run against fresh remote host

```bash
# Install k3sup
curl --silent --location --show-error https://get.k3sup.dev | sh

# Deploy k3s server
k3sup install \
    --context k3sup \
    --ip 78.46.246.60 \
    --user root \
    --ssh-key ~/id_rsa_hetzner
kubectl --kubeconfig=./kubeconfig get nodes -o wide
```