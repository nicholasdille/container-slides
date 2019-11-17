## Multi Stage Builds - Concurrency

### Stages are built in parallel

```Dockerfile
FROM alpine as build1
RUN touch /opt/binary1

FROM alpine as build2
RUN touch /opt/binary2

FROM alpine
COPY --from=build1 /opt/binary1 /opt/
COPY --from=build2 /opt/binary2 /opt/
```

--

## Demo: Multi Stage Builds - Concurrency

### Stages have a delay of 10 seconds

* Sequential build will take ~20 seconds
* Parallel build ~10 seconds

```bash
# Builds sequentially
docker build .

# Builds in parallel
DOCKER_BUILDKIT=1 docker build .
```
