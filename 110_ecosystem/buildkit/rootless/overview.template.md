## Rootless

BuildKit 0.7.x supports [building without root privileges](https://github.com/moby/buildkit/blob/master/docs/rootless.md)

Based on [rootlesskit](https://github.com/rootless-containers/rootlesskit)

Uses host networking by default or [slirp4netns](https://github.com/rootless-containers/slirp4netns) for isolation

Docker rootless was experimental since Docker 19.03

Docker rootless is GA since Docker 20.10 (December 8th 2020)

### Running in a rootless container

Daemon requires more access to paths (AppArmor)<br/>as well as syscalls (seccomp):

```
docker run \
    --security-opt apparmor=unconfined \
    --security-opt seccomp=unconfined
```

Share process namespace with worker containers:

```
buildkitd --oci-worker-no-process-sandbox
```

--

## Security boundaries

### Capabilities

Capabilities control access to system calls

All capabilities are considered privileged

### seccomp mode 2

Filter entire system calls

Restrict arguments to system calls

[Default profile](https://github.com/moby/moby/blob/master/profiles/seccomp/default.json) applied by Docker

### AppArmor

Access control for objects

Applies to files and paths

[Default profile](https://github.com/moby/moby/blob/master/profiles/apparmor/template.go) applied by Docker
