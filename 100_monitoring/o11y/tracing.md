## Tracing

<i class="fa fa-shoe-prints fa-5x"></i><!-- .element: style="float: right;" -->

Understanding data paths through infrastructure

Especially applicable to microservice architectures

### Terminology

Transaction: end-to-end request-response flow

Trace: record of a transaction (same trace ID)

Span: connection between two services

--

## Tracing in Software Development

<i class="fa fa-shoe-prints fa-5x"></i><!-- .element: style="float: right;" -->

Instrumentation required

Libraries available for multiple languages

Additional dependencies and code

OpenTracing is the defacto standard with many [supported tracers](https://opentracing.io/docs/supported-tracers/)

### Service Mesh

Usually includes (distributed) tracing

Proxy injection provides information about spans

Header propagation usually requires code change

(What is a [service mesh](https://servicemesh.es/) and which are available?)

--

## Tracing in Operations

<i class="fa fa-shoe-prints fa-5x"></i><!-- .element: style="float: right;" -->

Little to no advantages from service meshes

Networking topology

More features from CNI vendors