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

--

## Demo: BuildKit rootless locally

https://github.com/moby/buildkit/blob/master/docs/rootless.md

Run the daemon in user context

```plaintext
rootlesskit buildkitd
```

Run the build

```plaintext
buildctl \
    --addr unix:///run/user/$UID/buildkit/buildkitd.sock build \
    --frontend dockerfile.v0 \
    --local context=. \
    --local dockerfile=.
```
