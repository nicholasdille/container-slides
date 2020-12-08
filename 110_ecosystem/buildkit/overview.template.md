## BuildKit

### The project

![](images/moby.svg) <!-- .element: style="width: 5em; float: right;" -->

[BuildKit](https://github.com/moby/buildkit) is part of the [Moby project](https://github.com/moby)

Initiated by Docker

Community driven

### The features

Multi-stage builds

Concurrent and distributed execution

Remote build cache

Builds secrets

Unprivileged execution

---

## BuildKit

### How

Frontends are parsers for an input language

The input is translated into an intermediate representation

This is a dependency graph

The **L**ow **L**evel **B**uilders represent a single operation in the graph

LLBs are executed by workers on runc or containerd

LLBs can be executed in parallel

The build result is offered in a variaty of output formats

![Frontend is parsed into LLB and written to Output](110_ecosystem/buildkit/overview.drawio.svg)
