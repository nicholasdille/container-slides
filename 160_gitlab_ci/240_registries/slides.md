<!-- .slide: id="gitlab_registries" class="vertical-center" -->

<i class="fa-duotone fa-garage fa-8x fa-duotone-colors-inverted" style="float: right; color: grey;"></i>

## Registries

---

## Container registry

Integrated container registry [](https://docs.gitlab.com/ee/user/packages/container_registry/index.html#build-and-push-by-using-gitlab-cicd)

GitLab provides predefined variables [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_variables) for accessing the registry

Images must be named according to the project path, e.g. ...

...for project `bar` in group `foo`: gitlab.seatN.inmylab.de/foo/bar:latest

CI jobs receive environment variables:

- `CI_REGISTRY`
- `CI_REGISTRY_USER`
- `CI_REGISTRY_PASSWORD`
- `CI_REGISTRY_IMAGE`

---

## Hands-On

Upload the previously built container image

1. Add `before_script` to login to registry using `docker login`
1. Update build command to assign a proper tag
1. Add push command to upload container image

(See new `.gitlab-ci.yml`)
