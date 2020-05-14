## Multi Stage Builds - Concurrency

Stages can be built in parallel *when using BuildKit*

`build1` and `build2` are built at the same time

```plaintext
FROM alpine AS build1
RUN touch /opt/binary1

FROM alpine AS build2
RUN touch /opt/binary2

FROM alpine AS final
COPY --from=build1 /opt/binary1 /opt/
COPY --from=build2 /opt/binary2 /opt/
```

![](020_advanced//020_multi_stage/02_concurrency/dependency_graph.drawio.svg) <!-- .element: style="float: right; padding-left: 1em;" -->

Concurrency is determined based on the dependency graph

--

## Demo: Multi Stage Builds - Concurrency

Stages have a delay of 10 seconds

<!-- include: concurrency-0.command -->

<!-- include: concurrency-1.command -->

Sequential build will take ~20 seconds

Parallel build ~10 seconds
