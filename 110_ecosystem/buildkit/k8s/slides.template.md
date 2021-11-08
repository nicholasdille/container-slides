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

## Demo: BuildKit and Kubernetes <!-- directory -->

<!-- include: manual-0.command -->

<!-- include: manual-2.command -->

<!-- include: manual-3.command -->

<!-- include: manual-4.command -->

---

## Demo: Managing BuildKit using `buildx` <!-- directory -->

<!-- include: buildx-2.command -->

<!-- include: buildx-3.command -->

<!-- include: buildx-5.command -->

---

## Demo: Making `buildx`the default builder

```bash
docker buildx install
```

`uninstall` to revert

Must push during build:

```bash
docker build --tag X --push .
```

`docker push` and `docker tag` do not work

Similar but not identical DX
