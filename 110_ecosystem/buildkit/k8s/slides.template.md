<!-- .slide: id="builders" class="center" style="text-align: center; vertical-align: middle" -->

## Remote builders

---

## BuildKit and Kubernetes

BuildKit can be used as a [build service in Kubernetes](https://github.com/moby/buildkit/tree/master/examples/kubernetes)

### Pod

BuildKit understands the schema `kube-pod://`

### Deployment

Load balancing works

### CLI

`buildx` comes with options to deploy BuildKit based pods

---

## Demo: BuildKit and Kubernetes

<!-- include: manual-0.command -->

<!-- include: manual-2.command -->

<!-- include: manual-3.command -->

<!-- include: manual-4.command -->

---

## Managing BuildKit using `buildx`

<!-- include: buildx-2.command -->

<!-- include: buildx-3.command -->

<!-- include: buildx-5.command -->
