<!-- .slide: class="center" style="text-align: center; vertical-align: middle" -->

## Multi-Architecture Images

--

## Multi-Arch Image

### Images only work on a single platform

But containers are supported on multiple architectures and operating systems

### Virtual images to the rescue

Manifest links to separate image per platform

Now integrated in Docker CLI (docker manifest)

Based on manifest-tool (by Docker Captain Phil Estes)

### Official images are already multi-arch

--

## Multi-Arch Image: hello-world

```bash
$ docker run mplatform/mquery hello-world
Image: hello-world
 * Manifest List: Yes
 * Supported platforms:
   - linux/amd64
   - linux/arm/v5
   - linux/arm/v7
   - linux/arm64
   - linux/386
   - linux/mips64le
   - linux/ppc64le
   - linux/s390x
   - windows/amd64:10.0.17763.1577
```

--

## Multi-Arch Image: docker

```bash
$ docker run mplatform/mquery docker
Image: docker
 * Manifest List: Yes
 * Supported platforms:
   - linux/amd64
   - linux/arm/v6
   - linux/arm/v7
   - linux/arm64
```

--

## Demo: Building for other Architectures

Prepare for new sub command `buildx`

<!-- include: buildx-0.command -->

<!-- include: buildx-1.command -->

--

## Demo: Building for other Architectures

<!-- include: buildx-3.command -->

<!-- include: buildx-4.command -->

--

## Demo: Build multi-arch with proper tags (1)

Build individual images to control tagging

<!-- include: manifest-0.command -->

<!-- include: manifest-1.command -->

This allows for proper versioning

--

## Demo: Build multi-arch with proper tags (2)

<!-- include: manifest-2.command -->
