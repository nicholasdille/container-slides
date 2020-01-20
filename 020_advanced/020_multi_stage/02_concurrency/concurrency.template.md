## Multi Stage Builds - Concurrency

### Stages can be built in parallel

`build1` and `build2` are built in parallel

```Dockerfile
FROM alpine AS build1
RUN touch /opt/binary1

FROM alpine AS build2
RUN touch /opt/binary2

FROM alpine AS final
COPY --from=build1 /opt/binary1 /opt/
COPY --from=build2 /opt/binary2 /opt/
```

--

## Demo: Multi Stage Builds - Concurrency

### Stages have a delay of 10 seconds

<!-- include: concurrency-0.command -->

<!-- include: concurrency-1.command -->

Sequential build will take ~20 seconds

Parallel build ~10 seconds
