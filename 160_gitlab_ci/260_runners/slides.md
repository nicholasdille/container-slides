<!-- .slide: id="gitlab_runners" class="vertical-center" -->

<i class="fa-duotone fa-person-running fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Runners

---

## Runners

Runners [](https://docs.gitlab.com/runner/) are used to execute jobs in GitLab CI

Extensive configuration [](https://docs.gitlab.com/runner/configuration/advanced-configuration.html)

Executors interface with infrastructure

### Shell

Jobs are executed in the context of the runner

### Docker

Jobs are executed in a dedicated container

### Kubernetes

Jobs are executed in a dedicated pod

---

## Using containers

![](160_gitlab_ci/260_runners/containers.drawio.svg) <!-- .element: style="float: right; width: 25%" -->

Dedicated container/pod per job

Executor talks to Docker / Kubernetes:

1. Creates volume for working directory
1. Run helper container for checkout into volume
1. Run build container for build using volume

Services are executed in separate containers next to build container
