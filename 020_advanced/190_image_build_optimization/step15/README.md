# Image Build Optimization

Demo for [my talk about optimizing container image builds at ContainerConf 2022]().

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

**Sometimes the image scan fails when the base image contains an outdated package. The stage `prepare` executes a job to scan the base image and install updates for vulnerable packages as part of the build process.**

See the [pipeline runs](https://gitlab.com/nicholasdille/cc21_container_image_build_optimization/-/pipelines).
