## Using BuildKit

BuildKit can be used in multiple ways

We explored implicit usage with Docker CLI

|            | Locally | Containerized | Rootless
|------------|---------|---------------|--------
| Docker CLI | X       | X             | n/a
| Daemon/CLI | X       | X             | X
| Daemonless | X       | X             | X

Daemonless is just a wrapper for daemon/CLI

--

## Demo: Docker CLI

Docker CLI hides the details of using BuildKit

```plaintext
export DOCKER_BUILDKIT=1
docker build .
```

Default daemon to BuildKit:

```plaintext
$ cat /etc/docker/daemon.json
{ "features": { "buildkit": true } }
```

--

## Demo: Locally

Run BuildKit locally

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

## Demo: Containerized

Run BuildKit in a container

Start the daemon:

```plaintext
docker run -d \\
    --name buildkitd \\
    --privileged \\
    moby/buildkit \\
        --addr tcp://127.0.0.1:1234
```

Run a build:

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

## Demo: Daemonless

Let a script take care of running the daemon

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
