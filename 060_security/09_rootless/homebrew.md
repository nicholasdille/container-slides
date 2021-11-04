## Rootless Playground

Homebrew tap maintained by [@nicholasdille](https://twitter.com/nicholasdille)

### Install nerdctl and friends

```bash
brew tap nicholasdille/tap
brew install containerd buildkit nerdctl
```

### Play with them

Follow the official documentation (links above)

---

## Rootless Workplace

Based on Homebrew

Tap maintained by [@nicholasdille](https://twitter.com/) with >100 container tools

Rootless is very much work in progress

Please [report issues](https://github.com/nicholasdille/homebrew-tap/issues)

### Prepare

```bash
brew tap nicholasdille/tap
brew tap nicholasdille/immortal
```

--

## Docker

```bash
brew install dockerd-rootless
brew immortal start dockerd-rootless

SOCK="unix://$(brew --prefix)/var/run/dockerd/docker.sock"
docker context create rootless \
    --description "Docker Rootless" \
    --docker "host=${SOCK}"
docker context use rootless

docker version
```

--

## BuildKit

```bash
brew install buildkitd-rootless
brew immortal start buildkitd-rootless

SOCK="unix://$(brew --prefix)/var/run/buildkitd/buildkit/buildkitd.sock"
export BUILDKIT_HOST="unix://${SOCK}"
buildctl build ...
```

--

## containerd/nerdctl

### Rootless containerd only

```bash
brew install containerd-rootless
brew immortal start containerd-rootless
```

### Rootless containerd with nerdctl

```bash
brew install nerdctl-immortal
brew immortal start nerdctl-containerd
brew immortal start nerdctl-buildkitd
nerdctl-rootless version
```
