## Rootless containerd

[Official documentation](https://github.com/containerd/containerd/blob/main/docs/rootless.md)

Requires CNI

### Install and run

```bash
mkdir -p ~/bin
R=containerd/nerdctl
V=v0.11.2
F="nerdctl-${V#v}-linux-amd64.tar.gz"
curl -sL "https://github.com/$R/releases/download/$V/$F" | \
    tar -xzC bin
containerd-rootless-setuptool.sh install
curl -sL https://github.com/containernetworking/plugins/releases/download/v1.0.1/cni-plugins-linux-amd64-v1.0.1.tgz | \
    tar -xzC bin
curl -sL https://github.com/AkihiroSuda/cni-isolation/releases/download/v0.0.3/cni-isolation-amd64.tgz | \
    tar -xzC bin
```

--

## Test rootless containerd

### Run container

```bash
export CNI_PATH="$HOME/bin"
nerdctl run -it --rm alpine
nerdctl run -d nginx
nerdctl ps -a
```

### Build

Requires `buildkitd` to be running rootless

```bash
git clone https://github.com/nicholasdille/docker-tools
cd docker-tools
nerdctl build .
```
