<!-- .slide: id="gitlab_docker" class="vertical-center" -->

<i class="fa-brands fa-docker fa-8x" style="float: right; color: var(--r-heading-color);"></i>

## Docker build

---

## Docker build

Building container image uses services [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_services)

Use `docker:dind` for containerized Docker daemon

The GitLab runner must be configured to run privileged container

Alternatives: Rootless and or daeamonless builds using...

- kaniko [](https://github.com/GoogleContainerTools/kaniko)
- podman/buildah [](https://github.com/containers/buildah)
- BuildKit [](https://github.com/moby/buildkit)

---

## Hands-On

See chapter [Jobs and stages](/hands-on/20231130/230_docker/exercise/)
