## Docker-in-Docker (DinD)

Running an additional Docker daemon

### How it works

- Containerized Docker daemon
- Requires a privileged container

### Disadvantages

- Privileged containers enable host breakouts

--

## Demo: Docker-in-Docker (DinD)

Isolating a Docker daemon:

```bash
docker run -d --rm \
  --privileged \
  --name dind \
  docker:stable-dind

docker exec -it dind docker version
```

Also refer to security!