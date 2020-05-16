## Rootless

BuildKit 0.7.x supports [running without root privileges](https://github.com/moby/buildkit/blob/master/docs/rootless.md)

Based on [rootlesskit](https://github.com/rootless-containers/rootlesskit)

Uses host networking by default or [slirp4netns](https://github.com/rootless-containers/slirp4netns) for isolation

Docker rootless is experimental since Docker 19.03

--

## Demo: Docker Rootless Containerized

Run the daemon

```plaintext
docker run -it \\
    --publish 127.0.0.1:2375:2375 \\
    docker:stable-dind-rootless \\
        dockerd \\
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

## Demo: Rootless locally

Run the daemon in user context

```plaintext
buildkitd
```

Run the build

```plaintext
buildctl build \\
    --frontend dockerfile.v0 \\
    --local context=. \\
    --local dockerfile=.
```

--

## Demo: Rootless fully containerized

Run the daemon in user context

```plaintext
docker run -d \\
    --name buildkitd \\
    --security-opt apparmor=unconfined \\
    --security-opt seccomp=unconfined \\
    moby/buildkit:rootless \\
        --oci-worker-no-process-sandbox \\
        --addr tcp://127.0.0.1:1234
```

Run a build sharing the same network namespace

```plaintext
docker run -it \\
    --network container:buildkitd \\
    --volume $PWD:/src \\
    --workdir /src \\
    --entrypoint buildctl \\
    moby/buildkit build \\
        --addr tcp://127.0.0.1:1234 \\
        --frontend dockerfile.v0 \\
        --local context=. \\
        --local dockerfile=.
```

--

## Demo: Rootless daemon containerized

Run the daemon in user context with a port publishing

```plaintext
docker run -d \\
    --name buildkitd \\
    --security-opt apparmor=unconfined \\
    --security-opt seccomp=unconfined \\
    --publish 127.0.0.1:1234:1234 \\
    moby/buildkit:rootless \\
        --oci-worker-no-process-sandbox \\
        --addr tcp://0.0.0.0:1234
```

Run a build

```plaintext
buildctl build \\
    --addr tcp://127.0.0.1:1234 \\
    --frontend dockerfile.v0 \\
    --local context=. \\
    --local dockerfile=.
```

--

## Demo: Rootless daemonless

Run a build by running the daemon on-demand

```plaintext
export BUILDKITD_FLAGS=--oci-worker-no-process-sandbox \\
buildctl-daemonless.sh build \\
    --frontend dockerfile.v0 \\
    --local context=. \\
    --local dockerfile=.
```

--

## Demo: Rootless daemonless containerized

Run a containerized build with the daemon on-demand

```plaintext
docker run -it \\
    --security-opt apparmor=unconfined \\
    --security-opt seccomp=unconfined \\
    --env BUILDKITD_FLAGS=--oci-worker-no-process-sandbox \\
    --volume $PWD:/src \\
    --workdir /src \\
    --entrypoint buildctl-daemonless.sh \\
    moby/buildkit build \\
        --frontend dockerfile.v0 \\
        --local context=. \\
        --local dockerfile=.
```
