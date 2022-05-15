<!-- .slide: id="gitlab_docker" class="vertical-center" -->

<i class="fa-brands fa-docker fa-8x" style="float: right; color: var(--r-heading-color);"></i>

## Docker build

---

## Docker build

XXX

### Hands-On

XXX

```yaml
docker-build:
  image: docker:20.10.16
  stage: build
  services:
  - name: docker:20.10.16-dind
    command:
    - dockerd
    - --host
    - tcp://0.0.0.0:2375
  before_script:
  - printenv
  - docker login -u "${CI_REGISTRY_USER}" -p "${CI_REGISTRY_PASSWORD}" ${CI_REGISTRY}
  script:
  - docker build --tag "${CI_REGISTRY_IMAGE}:latest" .
  - docker push "${CI_REGISTRY_IMAGE}:latest"
```
