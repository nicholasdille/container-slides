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

**This step adds two stages. The stage called `test` runs tests against the container image. The last stage called `promote` marks a container image as `stable` only when the tests have run successfully.**

See the [pipeline runs](https://gitlab.com/nicholasdille/cc21_container_image_build_optimization/-/pipelines).
