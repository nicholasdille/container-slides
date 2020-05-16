## Rootless

BuildKit 0.7.x supports [running without root privileges](https://github.com/moby/buildkit/blob/master/docs/rootless.md)

Based on [rootlesskit](https://github.com/rootless-containers/rootlesskit)

Uses host networking by default or [slirp4netns](https://github.com/rootless-containers/slirp4netns) for isolation

Docker rootless is experimental since Docker 19.03

--

## Demo: Rootless daemonless containerized

<!-- include: daemonless_containerized-0.command -->
