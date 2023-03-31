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

## Hands-On 1/ [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/160_gitlab_ci/230_docker "230_docker")

Package binary in container image

1. Add `Dockerfile` to repository
1. Create new stage called `package` after `test`
1. Add job `package` in stage `package`

    ```yaml
    package:
      image: docker:20.10.21
      stage: package
      script:
      - docker build --tag hello .
    ```
    <!-- .element: style="width: 35em;" -->

---

## Hands-On 2/2 [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/160_gitlab_ci/230_docker "230_docker")

Package binary in container image

4. Add service to job `package`

    ```yaml
    package:
      services:
      - name: docker:20.10.21-dind
        command: [ "dockerd", "--host", "tcp://0.0.0.0:2375" ]
      #...
    ```
    <!-- .element: style="width: 35em;" -->

See new `.gitlab-ci.yml`:

```bash
git checkout 160_gitlab_ci/230_docker -- '*'
```
