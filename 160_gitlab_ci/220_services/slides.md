<!-- .slide: id="gitlab_services" class="vertical-center" -->

<i class="fa-duotone fa-gears fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Services

---

## Services

Services [](https://docs.gitlab.com/ee/ci/services/index.html) run side-by-side with CI jobs

Useful for integration tests, e.g. database and other backend services

Services can be declared using the `services` keyword [](https://docs.gitlab.com/ee/ci/yaml/#services)

- For all jobs
- Per job

Services are accessed using the `image` name (or an `alias`)

Services are available for runners with Docker/Kubernetes executor

GitLab only starts the service

No guarantee of availability

---

## Example

### Services for the whole pipeline

```yaml
services:
- name: nginx:stable
job_name:
  script: curl -sv http://nginx
```

### Services for a single job

```yaml
job_name:
  services:
  - name: nginx:stable
  script: curl -sv http://nginx
```

---

### Hands-On

See chapter [Services](/hands-on/2025-05-14/220_services/exercise/)

---

## Pro tip: Service logs

Not available in the job log by default

Capture and display them when `CI_DEBUG_TRACE` is set to `true`:

```yaml
job_name:
  variables:
    CI_DEBUG_TRACE: "true"
  services:
  - name: nginx:stable
  script: curl -sv http://nginx
```
