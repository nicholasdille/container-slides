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

## Hands-On 1/

Upload the previously built container image

1. Add `before_script` to login to registry using `docker login`

    ```yaml
    job_name:
      before_script:
      - docker login -u "${CI_REGISTRY_USER}" -p "${CI_REGISTRY_PASSWORD}" "${CI_REGISTRY}"
    ```

1. Update build command to assign a proper tag

    ```yaml
    job_name:
      script:
      - docker build --tag "${CI_REGISTRY_IMAGE}:${CI_COMMIT_REF_NAME}" .
    ```

---

## Hands-On 2/2

1. Add push command to upload container image

    ```yaml
    job_name:
      script:
      # ...
      - docker push "${CI_REGISTRY_IMAGE}:${CI_COMMIT_REF_NAME}"
    ```

1. Go to **Packages & Registries > Container Registry**
1. Check root image

(See new `.gitlab-ci.yml`)
