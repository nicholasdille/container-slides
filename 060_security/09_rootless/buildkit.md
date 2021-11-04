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
