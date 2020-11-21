## Demo: BuildKit locally

Requires daemon and CLI

<!-- include: buildkit_locally-0.command -->

<!-- include: buildkit_locally-1.command -->

--

## Demo: BuildKit daemon containerized

Run only the BuildKit daemon in a container

<!-- include: buildkit_containerized-0.command -->

<!-- include: buildkit_containerized-1.command -->

--

## Demo: BuildKit fully containerized

Run BuildKit daemon and CLI in a container

<!-- include: buildkit_containerized-0.command -->

<!-- include: buildkit_containerized-2.command -->
--

## Demo: BuildKit daemonless

Let a script take care of running the daemon on-demand

Run a build locally

```plaintext
buildctl-daemonless.sh build \\
    --frontend dockerfile.v0 \\
    --local context=. \\
    --local dockerfile=.
```

Run a build containerized

```plaintext
docker run -it \\
    --privileged \\
    --volume $PWD:/src \\
    --workdir /src \\
    --entrypoint buildctl-daemonless.sh \\
    moby/buildkit build \\
        --frontend dockerfile.v0 \\
        --local context=. \\
        --local dockerfile=.
```
