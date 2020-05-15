## Demo: BuildKit locally

Run BuildKit locally

Requires daemon and CLI

Start the daemon

```plaintext
sudo buildkitd
```

Run a build

```plaintext
buildctl build \\
    --frontend dockerfile.v0 \\
    --local context=. \\
    --local dockerfile=.
```

--

## Demo: BuildKit fully containerized

Run BuildKit daemon and CLI in a container

Start the daemon in a privileged container

```plaintext
docker run -d \\
    --name buildkitd \\
    --privileged \\
    moby/buildkit \\
        --addr tcp://127.0.0.1:1234
```

Run a build from local files

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

## Demo: BuildKit daemon containerized

Run only the BuildKit daemon in a container

Start the daemon in a privileged container

```plaintext
docker run -d \\
    --name buildkitd \\
    --privileged \\
    --publish 127.0.0.1:1234:1234 \\
    moby/buildkit \\
        --addr tcp://0.0.0.0:1234
```

Run a build from local files

```plaintext
buildctl build \\
    --addr tcp://127.0.0.1:1234 \\
    --frontend dockerfile.v0 \\
    --local context=. \\
    --local dockerfile=.
```

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
