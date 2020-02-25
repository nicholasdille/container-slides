## k3s: The lightweight k8s

### [k3s](https://github.com/rancher/k3s) is made by Rancher

- Removes legacy, alpha and non-default features
- Removes most plugins
- Adds sqlite3 as default configuration store
- Adds simple launcher
- Packages dependencies like containerd, flannel, CoreDNS, CNI

### Demo: SSH into fresh VM

```bash
# Run k3s server
k3s server &
k3s kubectl get nodes
```

XXX export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

XXX token: /var/lib/rancher/k3s/server/node-token

XXX k3s agent --server https://myserver:6443 --token ${NODE_TOKEN}

--

## k3d: k3s in Docker

### [k3d](https://github.com/rancher/k3d) is made by Rancher

- Lightweight k3s distribution
- Prerequisites: Docker

### Demo: Run on fresh Docker host

```bash
# Deploy k3s cluster
k3d create --name k3d --workers 3
export KUBECONFIG="$(k3d get-kubeconfig --name='k3d')"
kubectl cluster-info
docker ps
```

