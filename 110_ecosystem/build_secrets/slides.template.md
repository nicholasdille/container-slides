## Build Secrets

Do not provide secrets using environment variables

`ENV` burns variables into image

Build arguments (`ARG`) are only one option

### BuildKit to the rescue

Mount secrets using `tmpfs`

Temporary files in `/run/secrets/`

Introduced in Docker 18.09

--

## Demo: Build Secrets

Use experimental syntax in `Dockerfile`:

```plaintext
# syntax=docker/dockerfile:1.0.0-experimental
FROM alpine
RUN --mount=type=secret,id=mysite.key \
    ls -l /run/secrets
```

<!-- include: mount-0.command -->
