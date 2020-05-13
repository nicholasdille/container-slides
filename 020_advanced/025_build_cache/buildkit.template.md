## Buildkit Cache Warming

Use remote images to warm cache

Image layers will be downloaded as needed

Same syntax using `--cache-from`

Cache information must be embedded

Prerequisites: Docker 19.03

### Build with cache from remote image

```plaintext
export DOCKER_BUILDKIT=1

# Build image with cache information
docker build --build-arg BUILDKIT_INLINE_CACHE=1 .

# Build image from remote cache
docker build --cache-from myimg .
```

--

## Demo: Buildkit Cache Warming

<!-- include: buildkit-0.command -->

<!-- include: buildkit-1.command -->

--

## Demo: Buildkit Cache Internals

<!-- include: internals-0.command -->
