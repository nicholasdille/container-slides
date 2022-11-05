## kind (Kubernetes-IN-Docker)

Creates a Kubernetes cluster in containers

Official tool used by Kubernetes developers

Highly configurable [<i class="fa fa-globe" style="width: 1.5em; text-align: center;"></i>](https://github.com/kubernetes-sigs/kind/) [<i class="fa fa-file-alt" style="width: 1.5em; text-align: center;"></i>](https://kind.sigs.k8s.io/)

### Installation

```bash
curl https://github.com/kubernetes-sigs/kind/releases/latest/download/kind-linux-amd64 \
    --silent \
    --location \
    --output /usr/local/bin/kind
chmod +x /usr/local/bin/kind
```

### Deployment

`kubectl` is automatically configured:

```bash
kind create cluster
```
