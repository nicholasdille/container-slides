<!-- .slide: class="center" style="text-align: center; vertical-align: middle" -->

## BuildKit and Kubernetes

---

## BuildKit and Kubernetes

BuildKit can be used as a build service in Kubernetes

Multiple [examples available](https://github.com/moby/buildkit/tree/master/examples/kubernetes)

### Pod

Proof-of-concept

BuildKit understands the schema `kube-pod://`

### Deployment

Multiple pods can run simultaneously

Build is passed to any one of them by the service

--

## Demo: BuildKit and Kubernetes

Pass build to remote pod

<!-- include: kubernetes-0.command -->

<!-- include: kubernetes-2.command -->

<!-- include: kubernetes-3.command -->

--

## Using BuildKit with GitLab CI

Described in my [blog post](https://dille.name/blog/2020/06/01/using-buildkit-for-cloud-native-builds-in-gitlab/)

Published [demo on gitlab.com](https://gitlab.com/nicholasdille/demo-buildkit)

### Option 1: BuildKit daemon as service

Service is running next to build job

Connection is configured through variable `BUILDKIT_HOST`

### Option 2: BuildKit daemonless

Using the `buildctl-daemonless.sh` script

BuildKit daemon is started on-the-fly

--

## Using BuildKit in GitHub Actions

Official actions provided by Docker

Based on [buildx](https://github.com/docker/buildx)

[Comprehensive example](https://github.com/nicholasdille/image-pull-secrets-controller/blob/main/.github/workflows/image-pull-secrets-controller.yml)

### Actions

[Obtain metadata](https://github.com/crazy-max/ghaction-docker-meta) for tagging and labels

[Install qemu static binaries](https://github.com/docker/setup-qemu-action) for buildx

[Setup buildx](https://github.com/docker/setup-buildx-action) for multi-platform builds

[Login to Docker Hub](https://github.com/docker/login-action) for pushing images

[Build and push](https://github.com/docker/build-push-action) container image
