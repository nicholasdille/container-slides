<!-- .slide: class="center" style="text-align: center; vertical-align: middle" -->

## Remote builders

--

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

<!-- include: manual-0.command -->

<!-- include: manual-2.command -->

<!-- include: manual-3.command -->

--

## Managing BuildKit using buildx

<!-- include: buildx-1.command -->

<!-- include: buildx-2.command -->

<!-- include: buildx-4.command -->
