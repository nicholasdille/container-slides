## Reminder

![](060_security/09_rootless/stack.drawio.svg) <!-- .element: style="width: 80%;" -->

---

## Docker Design Disadvantages

![](060_security/09_rootless/stack.drawio.svg) <!-- .element: style="float: right; width: 45%;" -->

Daemon runs as root

Client controls daemon without authentication

### Security issues

`docker run -v /:/host`

`docker run -v /var/run/docker.sock:`

`docker run --privileged`

---

## Rootless Docker

### It is not...

- Running as non-root in a container
- Forcing a user `docker run/exec --user $(id -u):$(id -g) ...`
- Executing `docker` from a non-root account
- Enabling user namespace mapping

---

## Rootless Docker

### It is...

- Running containers as non-root
- Based on user namespaces
- GA since Docker 20.10

---

## Rootless Docker

### Limitations

- OverlayFS only on Ubuntu
- Reduced network performance
- Unable to open ports below 1024
- No cgroup (resource management)

---

## Rootless Docker

### Install

```bash
curl -fsSL https://get.docker.com/rootless | sh
```

### Run

```bash
export XDG_RUNTIME_DIR="${HOME}/.docker/run"
dockerd-rootless.sh
```

### Use

```bash
docker context use rootless
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

XXX

```bash
export DOCKERD_ROOTLESS_ROOTLESSKIT_FLAGS="-p 0.0.0.0:2376:2376/tcp"
dockerd-rootless.sh \
    --host tcp://0.0.0.0:2376 \
    --tlsverify \
    --tlscacert=ca.pem \
    --tlscert=cert.pem \
    --tlskey=key.pem
```

XXX https://docs.docker.com/engine/security/protect-access/

---

## Good to know

[Official documentation](https://docs.docker.com/engine/security/rootless/)

Resource management required cgroup v2

Container UID 0 is mapped to host UID of user

All other container UIDs are mapped to high UIDs

### Alternatives

[Rootless Podman](https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md) is also a thing

---

## Rootless BuildKit

[Official documentation](https://github.com/moby/buildkit/blob/master/docs/rootless.md)

### Run

```bash
rootlesskit --net=slirp4netns --copy-up=/etc --disable-host-loopback \
    buildkitd
```

(add `--oci-worker-snapshotter=native` when `fuse-overlayfs` produces errors)

### Use

```bash
buildctl --addr unix:///run/user/$UID/buildkit/buildkitd.sock \
    build ...
```

---

## Rootless BuildKit Inception

### Run

```bash
docker run --name buildkitd -d \
    --security-opt seccomp=unconfined \
    --security-opt apparmor=unconfined \
    --device /dev/fuse \
    moby/buildkit:rootless --oci-worker-no-process-sandbox
```

### Use

```bash
buildctl --addr docker-container://buildkitd \
    build ...
```

---

## Rootless containerd

[Official documentation](https://github.com/containerd/containerd/blob/main/docs/rootless.md)

### Use with systemd

```bash
mkdir -p ~/bin
curl -sLo bin/containerd-rootless.sh https://github.com/containerd/nerdctl/raw/master/extras/rootless/containerd-rootless.sh
curl -sLo bin/containerd-rootless-setuptool.sh https://github.com/containerd/nerdctl/raw/master/extras/rootless/containerd-rootless-setuptool.sh
R=containerd/nerdctl
V=v0.11.2
P=extras/rootless
S=containerd-rootless-setuptool.sh
curl -sL https://github.com/$R/raw/$V/$P/$S | \
    bash -s install
```

XXX

---

## Under the Hood of Rootless

XXX

[User namespaces](https://man7.org/linux/man-pages/man7/user_namespaces.7.html)

[Akihiro Suda](https://github.com/AkihiroSuda)

[rootlesskit](https://github.com/rootless-containers/rootlesskit)

[slirp4netns](https://github.com/rootless-containers/slirp4netns)

[Rootless Containers](https://rootlesscontaine.rs/)

---

## Rootless Playground

XXX

### Install

```bash
brew tap nicholasdille/tap
brew install containerd buildkit nerdctl
```

### Use

XXX

---

## Rootless Workplace

Very much work in progress

### Docker

```bash
brew tap nicholasdille/immortal
brew install dockerd-immortal
brew immortal start dockerd-rootless
docker-immortal.sh version
```

### nerdctl

```bash
brew tap nicholasdille/immortal
brew install nerdctl-immortal
brew immortal start containerd-rootless
nerdctl-immortal.sh version
```

---

## Rootless Kubernetes

https://github.com/rootless-containers/usernetes

https://kubernetes.io/docs/tasks/administer-cluster/kubelet-in-userns/

### KinD

https://github.com/kubernetes-sigs/kind/issues/1797

https://kind.sigs.k8s.io/docs/user/rootless/

```bash
export DOCKER_HOST=unix://${XDG_RUNTIME_DIR}/docker.sock
kind create cluster
```

---

## Rootless Notes

[sysbox](https://github.com/nestybox/sysbox): Open-source, next-generation "runc" that empowers rootless containers to run workloads such as Systemd, Docker, Kubernetes, just like VMs

[WSL2 and cgroup v2}(https://github.com/microsoft/WSL/issues/6662): Requires change in Microsoft owned init for service VM
