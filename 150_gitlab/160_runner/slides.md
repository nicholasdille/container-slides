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

### Docker / Kubernetes

Jobs are executed in a dedicated container / pod

### Image cleanup

docuum [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://github.com/stepchowfun/docuum) is able to remove least recently used images

---

## Details

<i class="fa-duotone fa-person-running fa-4x fa-duotone-colors" style="float: right;"></i>

Runner can be shared across the instance of GitLab

They can be specific to a group of project

Jobs select runners by specifying a tag

Extensive configuration [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/runner/configuration/advanced-configuration.html)

### Heads-up

New runner registration process [](https://docs.gitlab.com/ee/architecture/blueprints/runner_tokens/)

Implementation completed by v15.11 (April 2023)

Enforcement in v16.6 (November 2023)

---

## Hands-On

Add runner to GitLab instance

```bash
# Switch to directory for this topic
cd ../160_runners

# Deploy GitLab runner
export CI_SERVER_URL=http://gitlab.seatN.inmylab.de
export REGISTRATION_TOKEN=<TOKEN>
export RUNNER_EXECUTOR=docker
docker compose --project-name gitlab \
    --file ../100_reverse_proxy/compose.yml \
    --file compose.yml \
    up -d
```
