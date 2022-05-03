<!-- .slide: id="gitlab_runner" class="vertical-center" -->

<i class="fa-duotone fa-person-running fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Runner

---

## Overview

<i class="fa-duotone fa-person-running fa-4x fa-duotone-colors" style="float: right;"></i>

Runners [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/runner/) are used to execute jobs in GitLab CI

Supported executors: `shell`, `docker`, `docker-windows`, `docker-ssh`, `ssh`, `parallels`, `virtualbox`, `docker+machine`, `docker-ssh+machine`, `kubernetes`

### Shell

Jobs are executed in the context of the runner

### Docker

Jobs are executed in a dedicated container

### Kubernetes

Jobs are executed in a dedicated pod

---

## Details

Runner can be shared across the instance of GitLab

They can be specific to a group of project

Jobs select runners by specifying a tag

Extensive configuration [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/runner/configuration/advanced-configuration.html)

### Hands-On

Add runner to GitLab instance:

```bash
docker compose --project-name gitlab \
    --file ../100_reverse_proxy/compose.traefik.yml \
    --file ../100_reverse_proxy/compose.gitlab.yml \
    --file compose.yml \
    up -d
```
