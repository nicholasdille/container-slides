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

## Hands-On

See chapter [Services](/hands-on/2023-11-30/220_services/exercise/)
