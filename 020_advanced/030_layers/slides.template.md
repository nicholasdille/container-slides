<!-- .slide: class="center" style="text-align: center; vertical-align: middle" -->

## Images and Layers

---

## Naming scheme

Format: `<registry>/<repository>:<tag>`

`<repository>` describes purpose

`<tag>` describes variant or version

`<repository>:<tag>` is called an image

### Docker Hub

On Docker Hub: `<repository>:<tag>`

Official image: `alpine:stable`

Community image: `nicholasdille/insulatr`

--

## Images and layers

Images consist of layers

Layers improve download performance

Layers enable reusability

---

## Image Manifest

Lists layers in the image

Layers are referenced as blobs

References are SHA256 hashed: `sha256:...`

### Image configuration

Contains command used to create layers

Stored as blob

![](020_advanced/030_layers/image.svg) <!-- .element: style="display: block; margin-left: auto; margin-right: auto;" -->

--

## Demo: Layers

### Preparation

Upload image to local registry

<!-- include: layers-0.command -->

### Investigate layers locally

<!-- include: layers-1.command -->

<!-- include: layers-2.command -->

https://github.com/wagoodman/dive

--

## Demo: Image Manifest

<!-- include: layers-3.command -->

--

## Demo: Image Configuration

<!-- include: layers-4.command -->

--

## Demo: Download image layer

<!-- include: layers-5.command -->

<!-- include: layers-6.command -->

--

## Demo: Verifying a layer

<!-- include: layers-7.command -->

<!-- include: layers-8.command -->

---

## Registries

REST API

No UI

Manage images, layers, configurations

Upload, list, update, delete

### Usage

Registries are accessed using HTTPS

Insecure registries must be defined expicitly

Accepted insecure registry: `127.0.0.1/8`

### Further reading

[Registry API](https://docs.docker.com/registry/spec/api/)

[Image Manifest Specification v2.2](https://docs.docker.com/registry/spec/manifest-v2-2/)

--

## Demo: Registries

### Tagging images remotely

<!-- include: tagging-0.command -->

<!-- include: tagging-1.command -->

<!-- include: tagging-2.command -->
