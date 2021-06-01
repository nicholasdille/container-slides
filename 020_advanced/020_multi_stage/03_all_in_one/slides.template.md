## Multi Stage Builds

Use BuildKit for advanced features like multi-stage builds

### Separate build and runtime environments

| Build environment | Runtime environment |
|-------------------|---------------------|
| Compilers (e.g. `javac`) | Runtime (e.g. `java`) |
| Build dependencies | Execution dependencies |
| Build tools (e.g. `make`) | - |
| Large image | Smaller attack surface |

--

## Multi Stage Builds

Use BuildKit for advanced features like multi-stage builds

### Build in parallel

```Dockerfile
FROM alpine AS build1
RUN touch /opt/binary1

FROM alpine AS build2
RUN touch /opt/binary2

FROM alpine AS final
COPY --from=build1 /opt/binary1 /opt/
COPY --from=build2 /opt/binary2 /opt/
```

![](020_advanced//020_multi_stage/02_concurrency/dependency_graph.drawio.svg) <!-- .element: style="float: right; padding-left: 1em;" -->

`build1` and `build2` are built at the same time

Concurrency is determined based on the dependency graph

--

## Demo: Multi Stage Builds

Compile in parallel using JDK

Combine in final image using JRE

### Commands

<!-- include: all_in_one-0.command -->

<!-- include: all_in_one-1.command -->

<!-- include: all_in_one-2.command -->
