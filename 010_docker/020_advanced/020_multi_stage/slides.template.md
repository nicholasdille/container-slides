## Multi Stage Builds

Multiple `FROM` sections in `Dockerfile`

Last section represents (default) final image

Copy files between stages

```plaintext
FROM openjdk:8-jdk AS builder
#...

FROM openjdk:8-jre
COPY --from=builder ...
#...
```

Build intermediate images using `--target <name>`

Prerequisites: Docker 17.09
