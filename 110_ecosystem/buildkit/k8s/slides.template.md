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
