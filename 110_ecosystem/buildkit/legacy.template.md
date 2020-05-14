## Build engines

### Legacy build engine

Default when running `docker build`

Has been around since the early days

### BuildKit powered build engine

Based on [Moby BuildKit](https://github.com/moby/buildkit)

Enabled by environment variable:

```plaintext
export DOCKER_BUILDKIT=1
```

Faster and more flexible than the legacy build engine
