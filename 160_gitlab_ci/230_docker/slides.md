<!-- .slide: id="gitlab_docker" class="vertical-center" -->

<i class="fa-brands fa-docker fa-8x" style="float: right; color: var(--r-heading-color);"></i>

## Docker build

---

## Docker build

Building container image uses services [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_services)

Use `docker:dind` for containerized Docker daemon

The GitLab runner must be configured to run privileged container

### Hands-On

Package binary in container image

1. Create new stage called `package` after `test`
1. Add job `package` in stage `package`
1. Add service to job `package`

(See new `.gitlab-ci.yml`)
