## Build Secrets

Do not provide secrets using environment variables

`ENV` burns variables into image

Build arguments are only one option

Buildkit can mount secrets using `tmpfs`

Temporary files in `/run/secrets/`

--

## Demo: Build Secrets

Use experimental syntax in `Dockerfile`:

```Dockerfile
# syntax=docker/dockerfile:1.0.0-experimental
FROM alpine
RUN --mount=type=secret,id=mysite.key \
    ls -l /run/secrets
```

<!-- include: mount-0.command -->
