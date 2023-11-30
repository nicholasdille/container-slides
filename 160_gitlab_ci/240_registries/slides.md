<!-- .slide: id="gitlab_registries" class="vertical-center" -->

<i class="fa-duotone fa-garage fa-8x fa-duotone-colors-inverted" style="float: right; color: grey;"></i>

## Registries

---

## Container registry

Integrated container registry [](https://docs.gitlab.com/ee/user/packages/container_registry/index.html#build-and-push-by-using-gitlab-cicd)

GitLab provides predefined variables [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_variables) for accessing the registry

Images must be named according to the project path

For example in project `bar` in group `foo`:

    gitlab.inmylab.de/foo/bar:latest

CI jobs receive environment variables:

- `CI_REGISTRY`
- `CI_REGISTRY_USER`
- `CI_REGISTRY_PASSWORD`
- `CI_REGISTRY_IMAGE`

---

## Hands-On

See chapter [Registries](/hands-on/2023-11-30/240_registries/exercise/)
