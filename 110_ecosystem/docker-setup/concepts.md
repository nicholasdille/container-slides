<!-- .slide: data-transition="none" -->

## Concepts

![](110_ecosystem/docker-setup/architecture.drawio.svg) <!-- .element: style="width: 65%;" -->

### Tools are defined by...

`manifest.yaml` contains metadata about the tool

`Dockerfile` packages the tool into a container image

---

<!-- .slide: data-transition="none" -->

## Concepts

![](110_ecosystem/docker-setup/architecture.drawio.svg) <!-- .element: style="width: 65%;" -->

### Artifacts

`metadata` contains JSON of all `manifest.yaml`

Every tool is stored in a dedicated container image

---

<!-- .slide: data-transition="none" -->

## Concepts

![](110_ecosystem/docker-setup/architecture.drawio.svg) <!-- .element: style="width: 65%;" -->

### `docker-setup`

CLI to discover, install and update tools

Statically linked Go binary

---

<!-- .slide: data-transition="none" -->

## Concepts

![](110_ecosystem/docker-setup/architecture.drawio.svg) <!-- .element: style="width: 65%;" -->

### Updates

Renovate keeps tool versions up-to-date
