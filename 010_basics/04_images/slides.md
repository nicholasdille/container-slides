## Image management

### Images are served from Docker Hub

hub.docker.com

### Images are named `[user/]name:tag`

```bash
docker pull ubuntu
docker pull ubuntu:16.04
docker rmi ubuntu
```

### Different distributions

```bash
docker pull centos
docker run -it centos
```

Look and feel of that distribution with host kernel

--

![](images/Containers_like_VMs.png) <!-- .element: style="display: block; margin-left: auto; margin-right: auto;" -->

--

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
RUN curl -Lo /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-`uname -s`-`uname -m` \
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

--

## Image registries

### Docker Hub is not the only source for images

### Private registries based on [Docker Distribution](https://github.com/docker/distribution)

```bash
docker tag java nicholasdille/java
docker push nicholasdille/java
```

You must be logged in to Docker Hub and push to a repository owned by the account

--

## Private registries

### Security

`localhost:5000` is preconfigured as insecure registry

Other registries must be secure (HTTPS)

```bash
docker run -d --name registry -p 5000:5000 registry
docker tag java localhost:5000/java
docker push localhost:5000/java
```
