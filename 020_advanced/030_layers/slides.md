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

Upload image to local registry:

```
docker run -d -p 5000:5000 registry:2
docker build --tag localhost:5000/hello-world-java .
docker push localhost:5000/hello-world-java
```

### Investigate layers locally

```
docker history hello-world-java
```

--

## Demo: Image Manifest

Download image manifest:

```bash
curl \
  -sL \
  -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
  http://localhost:5000/v2/hello-world-java/manifests/latest \
| jq
```

--

## Demo: Image Configuration

Download image configuration:

```bash
curl \
  -sL \
  -H "Accept: application/vnd.docker.container.image.v1+json" \
  http://localhost:5000/v2/hello-world-java/manifests/latest \
| jq
```

--

## Demo: Download image layer

```bash
DIGEST=$(
  curl \
    -sL \
    -H "Accept: application/vnd.docker.container.image.v1+json" \
    http://localhost:5000/v2/hello-world-java/manifests/latest \
  | jq --raw-output '.layers[-1].digest'
)

curl \
  -sL \
  -H "Accept: application/vnd.docker.image.rootfs.diff.tar.gzip" \
  http://localhost:5000/v2/hello-world-java/blobs/${DIGEST} \
| tar -tvz
```

--

## Demo: Verifying a layer's digest

```bash
DIGEST=$(
  curl \
    -sL \
    -H "Accept: application/vnd.docker.container.image.v1+json" \
    http://localhost:5000/v2/hello-world-java/manifests/latest \
  | jq --raw-output '.layers[-1].digest'
)

curl \
  -sL \
  -H "Accept: application/vnd.docker.image.rootfs.diff.tar.gzip" \
  http://localhost:5000/v2/hello-world-java/blobs/${DIGEST} \
| sha256sum
```

--

## Demo: Determining the content length

```bash
DIGEST=$(
  curl \
    -sL \
    -H "Accept: application/vnd.docker.container.image.v1+json" \
    http://localhost:5000/v2/hello-world-java/manifests/latest \
  | jq --raw-output '.layers[-1].digest'
)

curl \
  -sL \
  -H "Accept: application/vnd.docker.image.rootfs.diff.tar.gzip" \
  http://localhost:5000/v2/hello-world-java/blobs/${DIGEST} \
| wc -c
```

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

```bash
# Download manifest from old name
MANIFEST=$(curl --silent --location \
    -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
    localhost:5000/v2/hello-world-java/manifests/latest
)

# Push manifest with new name
curl --request PUT \
  -H "Content-Type: application/vnd.docker.distribution.manifest.v2+json" \
  -d "${MANIFEST}" \
  localhost:5000/v2/hello-world-java/manifests/new

# Test
docker pull localhost:5000/v2/hello-world-java/manifests/new
```
