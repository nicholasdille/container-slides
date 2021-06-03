## Custom images
<!-- .slide: id="build" -->

Custom behaviour

Based on existing image

Adds tools and functionality

Simple but sufficient language

Create `Dockerfile`:

```Dockerfile
$ cat >Dockerfile <<EOF
FROM ubuntu:20.04
RUN apt update && apt -y install nginx
EOF
```

Build image from `Dockerfile`:

```bash
docker build --tag myimage .
```

--

## Dockerfile 1/4

### Specify first process to run

```Dockerfile
$ cat >Dockerfile <<EOF
FROM openjdk:11-jre
CMD java -version
EOF
$ docker build --tag cmd .
$ docker run cmd
```

### Use variables

Many containerized services use environment variables for configuration:

```bash
$ cat >Dockerfile <<EOF
FROM postgres
ENV POSTGRES_PASSWORD=foobar
EOF
$ docker build --tag my_postgres .
$ docker run my_postgres
```

--

## Dockerfile 2/4

### Use build arguments

```bash
$ cat >Dockerfile <<EOF
FROM ubuntu
ARG VERSION=1.24.1
RUN apt-get update \
 && apt-get -y install --no-install-recommends curl ca-certificates
RUN curl --location --output /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-`uname -s`-`uname -m` \
 && chmod +x /usr/local/bin/docker-compose
CMD /usr/local/bin/docker-compose
EOF
$ docker build --build-arg VERSION=1.29.2 --tag docker-compose .
$ docker run docker-compose
```

--

## Dockerfile 3/4

### Shell versus Exec Notation

Applies to `RUN`, `CMD`, `ENTRPOINT`

Shell notation wraps command in shell:

```Dockerfile
FROM openjdk:11-jre
CMD java -version
```

...is equivlent to...

```bash
docker run -it openjdk:11-jre sh -c 'java version'
```

Exec notation starts process without shell:

```Dockerfile
FROM openjdk:11-jre
CMD [ "java", "-version" ]
```

Equivalent to...

```bash
docker run -it openjdk:11-jre java -version
```

--

## Dockerfile 4/4

### ENTRYPOINT

`ENTRYPOINT` hardcodes the process to run

`CMD` defines parameters

Command line overrides `CMD`

```bash
$ cat >Dockerfile <<EOF
FROM openjdk:11-jre
ENTRYPOINT [ "java" ]
CMD [ "-version" ]
EOF
$ docker build --tag java .
$ docker run -it java -help
```

--

## Tagging images

Create `Dockerfile`

```bash
$ cat >Dockerfile <<EOF
FROM ubuntu
ARG VERSION=1.29.2
RUN apt-get update \
 && apt-get -y install --no-install-recommends curl ca-certificates
RUN curl --location --output /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-`uname -s`-`uname -m` \
 && chmod +x /usr/local/bin/docker-compose
CMD /usr/local/bin/docker-compose
EOF
```

Build image and assign multiple tags:

```bash
docker build . \
    --tag docker-compose:1.29.2 \
    --tag docker-compose:1.29 \
    --tag docker-compose:1
```

Assign alternative names:

```bash
docker tag docker-compose:1.29.2 docker-compose:latest
```
