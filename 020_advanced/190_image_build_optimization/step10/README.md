# Image Build Optimization

Demo for [my talk about optimizing container image builds at ContainerConf 2021]().

## Usage

This repository contains a series of examples what can be done to optimize a container image. The examples demonstrate how to achieve faster builds, smaller images, more secure contents as well as easier maintenance.

Switching through the individual demos works by checking out the tags `step01` to `step16`:

```bash
git checkout step1
```

Most demos require [BuildKit](https://github.com/moby/buildkit) to be enabled:

```bash
export DOCKER_BUILDKIT=1
```

## Commands

**Limits processes to user `nobody` inside the container.**

Build image:

```bash
docker build --tag hello .
```

Test image:

```bash
docker run -it hello hello
```

Check permissions

```bash
docker run -i hello bash <<EOF
rm /etc/resolv.conf
EOF
```
