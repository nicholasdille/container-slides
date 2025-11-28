<!-- .slide: id="gitlab_registries" class="vertical-center" -->

<i class="fa-duotone fa-garage fa-8x" style="float: right; color: grey;"></i>

## Registries

---

## Container registry

Integrated container registry [](https://docs.gitlab.com/ee/user/packages/container_registry/index.html#build-and-push-by-using-gitlab-cicd)

Images must be named according to the project path

For example in project `bar` in group `foo`:

    gitlab.inmylab.de/seatN/demo:latest

### Availability

Automatically enabled for the instance if using Let's Encrypt

Enable [](https://docs.gitlab.com/ee/administration/packages/container_registry.html#enable-the-container-registry) the registry

- Set a URL using `registry_external_url`
- Configure certificates (integrated or in reverse proxy)

Can be disabled per project [](https://docs.gitlab.com/ee/user/packages/container_registry/index.html#disable-the-container-registry-for-a-project)

---

## Authentication

GitLab provides predefined variables [<i class="fa fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_variables) for accessing the registry

CI jobs receive environment variables:

- `CI_REGISTRY`
- `CI_REGISTRY_USER`
- `CI_REGISTRY_PASSWORD`
- `CI_REGISTRY_IMAGE`

---

## Hands-On

See chapter [Registries](/hands-on/2025-11-27/240_registries/exercise/)

---

## Pro tip: Cleanup Policy

Configure how container images are removed

Define...

- How many tags are kept per image
- Which tags are not removed
- How old image can be
- Which tags are removed
