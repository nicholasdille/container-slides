## Demo: Docker Rootless

https://docs.docker.com/engine/security/rootless/

Run the daemon

```plaintext
docker run -it \
    --publish 127.0.0.1:2375:2375 \
    docker:stable-dind-rootless \
        dockerd \
            --host tcp://0.0.0.0:2375
```

Run the build

```plaintext
docker --host tcp://127.0.0.1:2375 build .
```

Default to using different Docker endpoint

```plaintext
docker context create dind --docker "host=tcp://127.0.0.1:2375"
docker context use dind
```
