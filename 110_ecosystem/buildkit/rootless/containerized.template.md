## Demo: Rootless containerized

<!-- include: containerized-0.command -->

<!-- include: containerized-1.command -->

--

## Demo: Rootless fully containerized

Run the daemon in user context with a port publishing

```plaintext
docker run --name buildkitd \
    --detach \
    --security-opt apparmor=unconfined \
    --security-opt seccomp=unconfined \
    --publish 127.0.0.1:1234:1234 \
    moby/buildkit:rootless \
        --oci-worker-no-process-sandbox \
        --addr tcp://0.0.0.0:1234
```

Run a build

```plaintext
docker run --interactive --tty \
    --network container:buildkitd \
    --volume $PWD:/src \
    --workdir /src \
    --entrypoint buildctl \
    moby/buildkit \
        --addr tcp://127.0.0.1:1234 \
        build \
            --frontend dockerfile.v0 \
            --local context=. \
            --local dockerfile=.
```
