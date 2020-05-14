## Using BuildKit

BuildKit can be used in multiple ways

Uses a client/server architecture (daemon and CLI)

|            | Locally | Containerized | Rootless |
|------------|:-------:|:-------------:|:--------:|
| Docker CLI | X       | X             | experimental
| Daemon/CLI | X       | X             | X
| Daemonless | X       | X             | X

Daemonless is just a wrapper for daemon/CLI

XXX why BuildKit without Docker CLI

--

## Demo: Docker CLI

Docker CLI hides the details of using BuildKit

### Option 1: Enable BuildKit using Docker CLI

```plaintext
export DOCKER_BUILDKIT=1
docker build .
```

### Option 2: Configure Docker daemon to use BuildKit

```plaintext
$ cat /etc/docker/daemon.json
{
    "features": {
        "buildkit": true
    }
}
```

--

## Demo: Docker fully containerized

XXX dind

```plaintext
docker run -d \\
    --name dind \\
    --privileged \\
    docker:stable-dind \\
        --host tcp://127.0.0.1:2375
```

XXX

Run a build from local files:

```plaintext
docker run -it \\
    --network container:dind \\
    --volume $PWD:/src \\
    --workdir /src \\
    docker:stable \\
        docker --host tcp://127.0.0.1:2375 \\
        build .
```

--

## Demo: Docker daemon containerized

XXX dind

```plaintext
docker run -d \\
    --name dind \\
    --privileged \\
    --publish 127.0.0.1:2375:2375 \\
    docker:stable-dind \\
        --host tcp://0.0.0.0:2375
```

XXX

Run a build from local files:

```plaintext
docker --host tcp://127.0.0.1:2375 build .
```

--

## Demo: Locally

Run BuildKit locally

Requires daemon and CLI

Start the daemon:

```plaintext
sudo buildkitd
```

Run a build:

```plaintext
buildctl build \\
    --frontend dockerfile.v0 \\
    --local context=. \\
    --local dockerfile=.
```

--

## Demo: BuildKit fully containerized

Run BuildKit daemon and CLI in a container

Start the daemon in a privileged container:

```plaintext
docker run -d \\
    --name buildkitd \\
    --privileged \\
    moby/buildkit \\
        --addr tcp://127.0.0.1:1234
```

Run a build from local files:

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

Start the daemon in a privileged container:

```plaintext
docker run -d \\
    --name buildkitd \\
    --privileged \\
    --publish 127.0.0.1:1234:1234 \\
    moby/buildkit \\
        --addr tcp://0.0.0.0:1234
```

Run a build from local files:

```plaintext
buildkit build \\
    --addr tcp://127.0.0.1:1234 \\
    --frontend dockerfile.v0 \\
    --local context=. \\
    --local dockerfile=.
```

--

## Demo: BuildKit daemonless

Let a script take care of running the daemon on-demand

Run a build locally:

```plaintext
buildctl-daemonless.sh build \\
    --frontend dockerfile.v0 \\
    --local context=. \\
    --local dockerfile=.
```

Run a build containerized:

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
