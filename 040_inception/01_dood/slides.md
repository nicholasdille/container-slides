## Docker-out-of-Docker (DooD)

Using the existing Docker daemon

### How it works

- Containerized Docker CLI
- Mapped Docker socket

### Disadvantages

- Conflicts with other containers
- Interferes with the host

--

## Demo: Docker-out-of-Docker (DooD)

Mapping the daemon socket:

```bash
docker run -it --rm \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  docker:18.09 \
  docker version
```