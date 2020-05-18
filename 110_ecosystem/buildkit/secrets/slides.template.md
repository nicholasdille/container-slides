## Build Secrets

Do not provide secrets using environment variables

`ENV` burns variables into image

Build arguments (`ARG`/`--build-arg`) are only one option

### BuildKit to the rescue

Mount [secrets](https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/experimental.md#run---mounttypesecret) using `tmpfs`

Temporary files in `/run/secrets/`

Introduced in Docker 18.09

--

## Demo: Build Secrets

Use experimental syntax in `Dockerfile`:

```plaintext
# syntax=docker/dockerfile:experimental
FROM alpine
RUN --mount=type=secret,id=mysite.key \\
    ls -l /run/secrets
```

<!-- include: mount-1.command -->
