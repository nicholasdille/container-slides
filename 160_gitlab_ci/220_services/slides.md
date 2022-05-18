<!-- .slide: id="gitlab_services" class="vertical-center" -->

<i class="fa-duotone fa-gears fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Services

---

## Services

Services [](https://docs.gitlab.com/ee/ci/services/index.html) run side-by-side with CI jobs

Services can be declared using the `services` keyword [](https://docs.gitlab.com/ee/ci/yaml/#services)

- For all job (top-level)
- Per job

Services are access using the `image` name (or an `alias`)

### Hands-On

Recommendation: Implement in dedicated project

1. Add top-level service based on `nginx`
1. Access service from job

(See `.gitlab-ci.yaml`)
