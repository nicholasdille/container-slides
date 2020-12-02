## Persisting Cache Directories

Modern software development relies on countless dependencies

Filling caches takes time

### BuildKit to the rescue

[Cache directories](https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/experimental.md#run---mounttypecache) can be persisted

Syntax is similar to mounting secrets

```plaintext
# syntax = docker/dockerfile:experimental
FROM ubuntu
RUN --mount=type=cache,target=/tmp/cache \
    ls -l /tmp/cache
```

--

## Demo: Persisting Cache Directories

<!-- include: cache-0.command -->

<!-- include: cache-2.command -->

<!-- include: cache-4.command -->
