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
