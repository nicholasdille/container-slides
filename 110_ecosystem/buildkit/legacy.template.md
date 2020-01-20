## Build engines

`docker` comes with two build engines

### Legacy build engine

Default when running `docker build`

Has been around since the early days

### Buildkit powered build engine

Based on [Moby Buildkit](https://github.com/moby/buildkit)

Enabled by environment variable:

```bash
export DOCKER_BUILDKIT=1
```

Faster and more flexible than the legacy build engine
