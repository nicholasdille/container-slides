<!-- .slide: id="gitlab_runner" class="vertical-center" -->

<i class="fa-duotone fa-person-running fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Runner

---

## Overview

<i class="fa-duotone fa-person-running fa-4x fa-duotone-colors" style="float: right;"></i>

Runners [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/runner/) are used to execute jobs in GitLab CI

Runner can be shared across the instance of GitLab

They can be specific to a group or project

Extensive configuration [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/runner/configuration/advanced-configuration.html)

### Tags

Jobs select runners by specifying a tag

---

## Heads-up

New runner registration process [](https://docs.gitlab.com/ee/architecture/blueprints/runner_tokens/)

New default in 16.0 (May 2023)

Enforcement in 16.6 (November 2023)

Removal of old runne registration in 17.0 (May 2024)

### Old process

One token per instance, per group and per project

Credential leak causes a lot of work

### New process

Create a runner through the UI or the API

One token per runner

---

## Details

<i class="fa-duotone fa-person-running fa-4x fa-duotone-colors" style="float: right;"></i>

Supported executors: `shell`, `docker`, `docker-windows`, `docker-ssh`, `ssh`, `parallels`, `virtualbox`, `docker+machine`, `docker-ssh+machine`, `kubernetes`

### Shell

Jobs are executed in the context of the runner

### Docker / Kubernetes

Jobs are executed in a dedicated container / pod

### Image cleanup

docuum [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://github.com/stepchowfun/docuum) is able to remove least recently used images

---

## Hands-On

1. Add runner to GitLab instance: Admin Area <i class="fa-regular fa-arrow-right"></i> CI/CD <i class="fa-regular fa-arrow-right"></i> Runners <i class="fa-regular fa-arrow-right"></i> New instance runner

1. Configure runner: Check "Run untagged jobs"

1. Start runner (substitute token below)

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

    <!-- .element: style="width: 35em;" -->
