<!-- .slide: id="multi-arch" class="center" style="text-align: center; vertical-align: middle" -->

## Multi-Architecture Images

---

## Multi-arch images

### Images only work on a single platform

But containers are supported on multiple architectures and operating systems

### Virtual images to the rescue

Manifest links to separate image per platform

Now integrated in Docker CLI (docker manifest)

Based on manifest-tool (by Docker Captain Phil Estes)

### Official images are already multi-arch

---

## Multi-Arch Image: hello-world

```bash
$ regctl manifest get --list hello-world
Name:        hello-world
Manifests:
  Platform:  linux/amd64
  Platform:  linux/arm/v5
  Platform:  linux/arm/v7
  Platform:  linux/arm64/v8
  Platform:  linux/386
  Platform:  linux/mips64le
  Platform:  linux/ppc64le
  Platform:  linux/riscv64
  Platform:  linux/s390x
  Platform:  windows/amd64
  OSVersion: 10.0.20348.288
  Platform:  windows/amd64
  OSVersion: 10.0.17763.2237
```

---

## Multi-Arch Image: docker

```bash
$ regctl manifest get --list docker:latest
Name:        docker:latest
Manifests:
  Platform:  linux/amd64
  Platform:  linux/arm64/v8
```

---

## Demo: Building for other Architectures <!-- directory -->

Prepare for new sub command [`buildx`](https://github.com/docker/buildx)

<!-- include: buildx-0.command -->

<!-- include: buildx-1.command -->

---

## Demo: Building for other Architectures <!-- directory -->

<!-- include: buildx-3.command -->

<!-- include: buildx-4.command -->

---

## Demo: Build multi-arch with proper tags (1) <!-- directory -->

Build individual images to control tagging

<!-- include: manifest-0.command -->

<!-- include: manifest-1.command -->

This allows for proper versioning

---

## Demo: Build multi-arch with proper tags (2) <!-- directory -->

<!-- include: manifest-2.command -->
