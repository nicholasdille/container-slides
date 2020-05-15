## BuildKit Cache Warming

### How it works

Use remote images to warm the cache

Image layers will be downloaded as needed

Same syntax using `--cache-from`

### Prerequisites

Cache information must be embedded during build

Docker 19.03

--

## Demo: BuildKit Cache Warming

<!-- include: buildkit-0.command -->

<!-- include: buildkit-1.command -->

--

## Demo: BuildKit Cache Internals

<!-- include: internals-0.command -->
