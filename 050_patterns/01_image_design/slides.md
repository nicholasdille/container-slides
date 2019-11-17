## Tagging strategies

### Tags are aliases for image versions

### `Latest` has no universal meaning

### Individual version / build number

### Meaningful named tags

stable for tested images

dev or vnext for untested images

master for builds of master branch

### More tags = choice

Latest v1.1.x should also be tagged as v1.1, v1 and stable

Latest v1.1.x-alpine should also be tagged as stable-alpine

Latest build of `master` branch should be tagged master

### Options for tagging

1. Tagging requires pull

1. Tagging after build is cheap

1. Tagging against Registry API is always cheap

--

## One process per container

### The optimist

Separating functionality

Enabling scalability

### The realist

Multiple processes in a container may make sense

Depends on service

### Thinking in pods

Separate containers even if 1:1 relation

Share network namespace (see advanced topics)

--

## Build versus Runtime

### Build parameters

Versions of tools to be installed

Features to enable

Use build arguments

Define with `ARG` statement in Dockerfile

Supply on build: docker build --build-arg NAME=VALUE

```Dockerfile
FROM alpine
RUN apk add --update-cache --no-cache \
        curl \
        git \
        make \
        bash
ARG VERSION=6.0.0
RUN cd $(mktemp -d) \
 && git clone https://github.com/dylanaraps/neofetch . \
 && git checkout ${VERSION} \
 && make install \
 && cd /tmp \
 && rm -rf tmp.*
ENTRYPOINT ["/usr/bin/neofetch"]
```

### Runtime parameters

Configure behaviour

Use environment variables

`ENV` statement in Dockerfile

See tweaking runtime behaviour

XXX example

--

## Using proxy servers

### Do not hardcore in Dockerfile

### During build

```bash
docker run --build-arg http_proxy --build-arg https_proxy .
```

### During runtime

```bash
docker run --env http_proxy --env https_proxy ubuntu
```

### Docker daemon

Honours environment variables `http_proxy`, `https_proxy` and `no_proxy`

--

## Tweaking runtime behaviour

## ENV

Do not hardcode values into commands

Use environment variables

Set reasonable defaults

Available to all processes inside the container

```Dockerfile
FROM openjdk:11-jre

ENV JAVA_OPTS="-Xms256m -Xmx1024m -server"
ENTRYPOINT [ "java" ]
```

### CMD and ENTRYPOINT

Changes behaviour on start

```Dockerfile
FROM alpine
COPY entrypoint.sh /
ENTRYPOINT /entrypoint.sh
```

### Shell and exec notation

Determines whether a command is wrapped by a new shell

```bash
#!/bin/bash

# DO YOU MAGIC HERE

exec nginx -g "daemon off;"
```

Running from command line:

```bash
#!/bin/bash

# DO YOUR MAGIC HERE

exec "$@"
```

--

## Version pinning versus `latest`

### Downsides of using `latest`

Breaks reproducibility

Causes conflict with two services based on the same image

Version pinning in Dockerfile

Hard/impossible to determine running image version (see microlabeling)

### Upsides of using `latest`

No need for version pinning

Always receive updates

### Strong downs but weak ups for using `latest`

Manage versions explicitly:

```Dockerfile
FROM ubuntu:bionic-20181018

RUN apt-get update \
 && apt-get -y install docker-ce=18.09.*
```

Update on every build:

```Dockerfile
FROM ubuntu:bionic

RUN apt-get update \
 && apt-get -y install docker-ce
```

--

## Do not use latest

XXX

--

## Derive from code

### Using community images is like buying a pig in a poke

Community images may not receive updates

Community images may follow undesirable paths

Community images may introduce security issues

Community images may not be updated at all

### Solution

Fork code repository and build yourself
