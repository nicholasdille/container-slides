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
