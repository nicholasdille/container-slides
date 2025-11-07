<!-- .slide: id="gitlab_docker" class="vertical-center" -->

<i class="fa-brands fa-docker fa-8x" style="float: right; color: var(--r-heading-color);"></i>

## Docker build

---

## Docker build

Building container image uses services [<i class="fa fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_services)

Use `docker:dind` for containerized Docker daemon

<i class="fa-duotone fa-triangle-exclamation"></i> The GitLab runner must be configured to run privileged container <i class="fa-duotone fa-triangle-exclamation"></i>

```yaml
job_name:
  services:
  - name: docker:dind
  variables:
    DOCKER_TLS_CERTDIR: ""
  script: docker build .
```

Empty `DOCKER_TLS_CERTDIR` disables TLS

---

### Hands-On

See chapter [docker build](/hands-on/2025-11-18/230_docker/exercise/)

---

## Security implications

Privileged containers enable host breakouts

Mitigate using gvisor, kata-containers, sysbox

### Alternatives to Docker-in-Docker

Rootless and/or daeamonless builds using...

- [kaniko](https://github.com/GoogleContainerTools/kaniko) with an [official example](https://docs.gitlab.com/ee/ci/docker/using_kaniko.html)
- podman/[buildah](https://github.com/containers/buildah)
- Moby [BuildKit](https://github.com/moby/buildkit)

Question of security vs. usability
