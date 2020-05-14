## Rootless

BuildKit 0.7.x supports running without root privileges

XXX https://github.com/moby/buildkit/blob/master/docs/rootless.md

XXX rootlesskit https://github.com/rootless-containers/rootlesskit

XXX host networking or slirp4netns https://github.com/rootless-containers/slirp4netns

XXX distros?

--

## Demo: Rootless locally

Run the daemon in user context:

```plaintext
buildkitd
```

Run the build:

```plaintext
buildctl build \\
    --frontend dockerfile.v0 \\
    --local context=. \\
    --local dockerfile=.
```

--

## Demo: Rootless fully containerized

Run the daemon in user context:

```plaintext
docker run -d \\
    --name buildkitd \\
    --security-opt apparmor=unconfined \\
    --security-opt seccomp=unconfined \\
    moby/buildkit:rootless \\
        --oci-worker-no-process-sandbox \\
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

## Demo: Rootless daemon containerized

Run the daemon in user context:

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

Run a build:

```plaintext
buildkit build \\
    --addr tcp://127.0.0.1:1234 \\
    --frontend dockerfile.v0 \\
    --local context=. \\
    --local dockerfile=.
```

--

## Demo: Rootless daemonless

Run a build:

```plaintext
export BUILDKITD_FLAGS=--oci-worker-no-process-sandbox \\
buildctl-daemonless.sh build \\
    --frontend dockerfile.v0 \\
    --local context=. \\
    --local dockerfile=.
```

--

## Demo: Rootless daemonless containerized

Run a build:

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
