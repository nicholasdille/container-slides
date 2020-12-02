<!-- .slide: class="center" style="text-align: center; vertical-align: middle" -->

## Rootless

---

## Rootless

BuildKit 0.7.x supports [building without root privileges](https://github.com/moby/buildkit/blob/master/docs/rootless.md)

Based on [rootlesskit](https://github.com/rootless-containers/rootlesskit)

Uses host networking by default or [slirp4netns](https://github.com/rootless-containers/slirp4netns) for isolation

Docker rootless is experimental since Docker 19.03

Docker rootless will be GA in Docker 20.10

--

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

--

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

--

## Demo: Rootless daemonless

Run a build by running the daemon on-demand

```plaintext
export BUILDKITD_FLAGS=--oci-worker-no-process-sandbox \
buildctl-daemonless.sh build \
    --frontend dockerfile.v0 \
    --local context=. \
    --local dockerfile=.
```

--

## Demo: Rootless daemonless containerized

Run a containerized build with the daemon on-demand

```plaintext
docker run -it \
    --security-opt apparmor=unconfined \
    --security-opt seccomp=unconfined \
    --env BUILDKITD_FLAGS=--oci-worker-no-process-sandbox \
    --volume $PWD:/src \
    --workdir /src \
    --entrypoint buildctl-daemonless.sh \
    moby/buildkit build \
        --frontend dockerfile.v0 \
        --local context=. \
        --local dockerfile=.
```
