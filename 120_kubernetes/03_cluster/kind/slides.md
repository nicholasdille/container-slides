## kind

Creates a Kubernetes cluster in containers

Official tool used by Kubernetes developers

Highly configurable

[<i class="fas fa-globe" style="width: 1.5em; text-align: center;"></i>](https://github.com/kubernetes-sigs/kind/) [<i class="fas fa-file-alt" style="width: 1.5em; text-align: center;"></i>](https://kind.sigs.k8s.io/)

Installation

```bash
curl https://github.com/kubernetes-sigs/kind/releases/download/v0.11.1/kind-linux-amd64 \
    --silent \
    --location \
    --output /usr/local/bin/kind
chmod +x /usr/local/bin/kind
```

Create a cluster

```bash
kind create cluster
```

`kubectl` is automatically configured
