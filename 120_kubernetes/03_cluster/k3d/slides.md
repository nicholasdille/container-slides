## k3d

k3s in Docker

k3s: Lightweight Kubernetes in a single binary https://github.com/k3s-io/k3s

[<i class="fa fa-globe" style="width: 1.5em; text-align: center;"></i>](https://github.com/rancher/k3d) [<i class="fa fa-file-alt" style="width: 1.5em; text-align: center;"></i>](https://k3d.io/)

Installation

```bash
curl https://github.com/k3d-io/k3d/releases/download/v5.3.0/k3d-linux-amd64 \
    --silent \
    --location \
    --output /usr/local/bin/k3d
chmod +x /usr/local/bin/k3d
```

Create a cluster

```bash
k3d cluster create
```
