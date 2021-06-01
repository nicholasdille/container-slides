## Custom images

### Custom behaviour

Based on existing image

Adds tools and functionality

Simple but sufficient scripting language

```Dockerfile
FROM ubuntu:xenial
RUN apt update && apt -y install nginx
```

Build image from `Dockerfile`:

```bash
docker build --tag myimage .
```

--

## Dockerfile

### Specify first process to run

```Dockerfile
FROM openjdk:11-jre
CMD java -version
```

### Use variables

```bash
FROM ubuntu
ENV VERSION=1.24.1
RUN curl --location --output /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-`uname -s`-`uname -m` \
 && chmod +x /usr/local/bin/docker-compose
```

--

## Shell versus Exec Notation

Shell notation wraps command in shell:

```plaintext
RUN java -version   # sh -c 'java -version'
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

## ENTRYPOINT

`ENTRYPOINT` defined process

`CMD` defines parameters

```Dockerfile
FROM openjdk:11-jre
ENTRYPOINT [ "java" ]
CMD [ "-version" ]
```

Override parameters from the command line:

```bash
docker build --tag java .
docker run -it java -help
```
