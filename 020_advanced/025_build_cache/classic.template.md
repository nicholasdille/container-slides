## Classic Build Cache Warming

### How it works

Builds may not run on the same host

Use local images to warm cache

```plaintext
docker pull myimage:1
docker build --cache-from myimage:1 --tag myimage:2
```

Internal build cache is ignored when using `--cache-from`

### Prerequisites

Added in Docker 1.13

Image must be present locally

--

## Demo: Classic Build Cache Warming

<!-- include: classic-0.command -->

<!-- include: classic-1.command -->

<!-- include: classic-2.command -->

<!-- include: classic-3.command -->

Internal build cache is still used when cache image does not exist
