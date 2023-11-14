<!-- .slide: id="gitlab_services" class="vertical-center" -->

<i class="fa-duotone fa-gears fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Services

---

## Services

Services [](https://docs.gitlab.com/ee/ci/services/index.html) run side-by-side with CI jobs

Services can be declared using the `services` keyword [](https://docs.gitlab.com/ee/ci/yaml/#services)

- For all jobs
- Per job

Services are accessed using the `image` name (or an `alias`)

Services are available for runners with Docker/Kubernetes executor

GitLab only starts the service

No guarantee of availability

---

## Hands-On [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/160_gitlab_ci/220_services "220_services")

Recommendation: Implement in dedicated project

1. Add top-level service based on `nginx`

    ```yaml
    services:
    - nginx:1.20.2
    ```

1. Access service from job

    ```yaml
    test:
      script:
      - curl -s http://nginx
    ```

1. Check pipeline

See new `.gitlab-ci.yml`:

```bash
git checkout origin/160_gitlab_ci/220_services -- '*'
```
