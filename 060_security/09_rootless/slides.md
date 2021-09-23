# Reminder

![Docker stack with access from local and remote](060_security/09_rootless/stack.drawio.svg) <!-- .element: style="width: 80%;" -->

---

## Docker Design Disadvantages

![Docker stack with access from local and remote](060_security/09_rootless/stack.drawio.svg) <!-- .element: style="float: right; width: 45%;" -->

Daemon runs as root

Client controls daemon without authentication

### Security issues

`docker run -v /:/host`

`docker run -v /var/run/docker.sock:`

`docker run --privileged`

---

## Rootless Docker IS NOT

Running as non-root in a container

Forcing a user `docker run/exec --user`

Executing `docker` from a non-root account

Enabling user namespace mapping

---

## Rootless Docker IS

Running containers as non-root

Based on user namespaces

GA since Docker 20.10

---

## Limitations of Rootless Docker

OverlayFS only on Ubuntu

Reduced network performance

Unable to open ports below 1024

Resource management only with cgroup v2

---

## Rootless Docker

### Install

Registers `dockerd` as systemd user unit

```bash
curl -fsSL https://get.docker.com/rootless | sh
```

### Use

```bash
docker context use rootless
```

--

## Testing Rootless Docker

```bash
docker info
docker run -d nginx
ps faux
docker run -d ubuntu sleep infinity
docker run -d --user $(id -u):$(id -g) ubuntu sleep infinity
docker build github.com/nicholasdille/docker-tools
```

---

## Rootless Inception

Docker Rootless in Docker Rootful

```bash
docker run -d --name dind-rootless --privileged \
    docker:20.10-dind-rootless
```

Privileged container is required for:

- Disable seccomp
- Disable apparmor
- Mount mask

---

## Remote Rootless Docker

Remote access to rootless Docker via [secure TCP](https://docs.docker.com/engine/security/protect-access/)

```bash
export DOCKERD_ROOTLESS_ROOTLESSKIT_FLAGS="-p 0.0.0.0:2376:2376/tcp"
dockerd-rootless.sh \
    --host tcp://0.0.0.0:2376 \
    --tlsverify \
    --tlscacert=ca.pem \
    --tlscert=cert.pem \
    --tlskey=key.pem
```

Remoting through SSH also works...

...but `DOCKER_HOST` must be set and available for user

---

## Good to know

[Official documentation](https://docs.docker.com/engine/security/rootless/)

Resource management requires cgroup v2

Container UID 0 is mapped to host UID of user

All other container UIDs are mapped to high UIDs

### Alternatives

[Rootless Podman](https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md) is also a thing

---

## Rootless BuildKit

[Official documentation](https://github.com/moby/buildkit/blob/master/docs/rootless.md)

### Run buildkitd

```bash
rootlesskit --net=slirp4netns --copy-up=/etc --disable-host-loopback \
    buildkitd
```

(add `--oci-worker-snapshotter=native` when `fuse-overlayfs` produces errors)

--

## Test rootless BuildKit

### Build locally

```bash
buildctl --addr "unix:///run/user/$UID/buildkit/buildkitd.sock" \
    build \
        --frontend gateway.v0 \
        --opt source=docker/dockerfile \
        --opt context=git://github.com/nicholasdille/docker-tools
```

---

## Rootless BuildKit Inception

### Run containerized buildkitd

```bash
docker run --name buildkitd -d \
    --security-opt seccomp=unconfined \
    --security-opt apparmor=unconfined \
    --device /dev/fuse \
    moby/buildkit:rootless --oci-worker-no-process-sandbox
```

### Build against container

```bash
buildctl --addr docker-container://buildkitd \
    build ...
```

---

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

---

## Under the Hood of Rootless

It's all based on [user namespaces](https://man7.org/linux/man-pages/man7/user_namespaces.7.html)

The person behind rootless implementations: [Akihiro Suda](https://github.com/AkihiroSuda)

The code behind setting up rootless: [rootlesskit](https://github.com/rootless-containers/rootlesskit)

Networking for rootless: [slirp4netns](https://github.com/rootless-containers/slirp4netns)

Home of [Rootless Containers](https://rootlesscontaine.rs/)

---

## Rootless Playground

Homebrew tap maintained by [@nicholasdille](https://twitter.com/nicholasdille)

### Install nerdctl and friends

```bash
brew tap nicholasdille/tap
brew install containerd buildkit nerdctl
```

### Play with them

Follow the official documentation (links above)

---

## Rootless Workplace

Based on Homebrew

Tap maintained by [@nicholasdille](https://twitter.com/) with >100 container tools

Rootless is very much work in progress

Please [report issues](https://github.com/nicholasdille/homebrew-tap/issues)

### Prepare

```bash
brew tap nicholasdille/tap
brew tap nicholasdille/immortal
```

--

## Docker

```bash
brew install dockerd-rootless
brew immortal start dockerd-rootless

SOCK="unix://$(brew --prefix)/var/run/dockerd/docker.sock"
docker context create rootless \
    --description "Docker Rootless" \
    --docker "host=${SOCK}"
docker context use rootless

docker version
```

--

## BuildKit

```bash
brew install buildkitd-rootless
brew immortal start buildkitd-rootless

SOCK="unix://$(brew --prefix)/var/run/buildkitd/buildkit/buildkitd.sock"
export BUILDKIT_HOST="unix://${SOCK}"
buildctl build ...
```

--

## containerd/nerdctl

### Rootless containerd only

```bash
brew install containerd-rootless
brew immortal start containerd-rootless
```

### Rootless containerd with nerdctl

```bash
brew install nerdctl-immortal
brew immortal start nerdctl-containerd
brew immortal start nerdctl-buildkitd
nerdctl-rootless version
```

---

## Rootless Kubernetes

[Official documentation](https://kubernetes.io/docs/tasks/administer-cluster/kubelet-in-userns/)

Requires cgroup v2, systemd user, uidmap

Requires feature gate `KubeletInUserNamespace`

### Rootless KinD

[Official documentation](https://kind.sigs.k8s.io/docs/user/rootless/), some [loose ends](https://github.com/kubernetes-sigs/kind/issues/1797)

Requires cgroup v2

```bash
export DOCKER_HOST=unix://${XDG_RUNTIME_DIR}/docker.sock
kind create cluster
```

---

## Rootless Notes

Enable cgroup v2:

- In `/etc/default/grub` set `GRUB_CMDLINE_LINUX="systemd.unified_cgroup_hierarchy=1"`
- Run `update-grub` and `reboot`

[WSL2 and cgroup v2](https://github.com/microsoft/WSL/issues/6662): Requires change in Microsoft owned init for service VM

[usernetes](https://github.com/rootless-containers/usernetes): Run Kubernetes without root privileges

[sysbox](https://github.com/nestybox/sysbox): Next-generation "runc" that empowers rootless containers to run workloads such as Systemd, Docker, Kubernetes, just like VMs
