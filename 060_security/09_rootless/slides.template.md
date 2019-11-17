## Rootless Docker

Reduce attack surface

### It is not...

- Running as non-root in container
- Enabling user namespace mapping

### It is...

- Running `dockerd` as non-root
- Experimental preview in Docker 19.03
- See [slides](https://de.slideshare.net/AkihiroSuda/dockercon-2019-hardening-docker-daemon-with-rootless-mode) by Aikihiro Suda

--

## Demo: Rootless Docker

### Running Docker as unprivileged user

- Based on user namespaces (map UIDs to unprivileged range)
- Handling of namespaces is based on [`rootlesskit`](https://github.com/rootless-containers/rootlesskit) by Akihiro Suda
- Networking is based on [`moby/vpnkit`](https://github.com/moby/vpnkit)

```bash
curl -sSL https://get.docker.com/rootless | sh
```

### What does not work

- Only Ubuntu supports `overlay` fs
- Other distributions use `vfs` (not recommended for production)

### Rootless Everything

Akihiro is also working on...

- [Rootless kubernetes](https://github.com/rootless-containers/usernetes)
- [Rootless buildkit](https://github.com/moby/buildkit/blob/master/docs/rootless.md)
