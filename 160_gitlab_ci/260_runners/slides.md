<!-- .slide: id="gitlab_runners" class="vertical-center" -->

<i class="fa-duotone fa-person-running fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Runners

---

## Runners

![](160_gitlab_ci/260_runners/executor.drawio.svg) <!-- .element: style="float: right; width: 30%;" -->

Runners [](https://docs.gitlab.com/runner/) are used to execute jobs in GitLab CI

Extensive configuration [](https://docs.gitlab.com/runner/configuration/advanced-configuration.html)

Executors interface with infrastructure

### Shell

Jobs are executed in the context of the runner

---

## Using containers

![](160_gitlab_ci/260_runners/containers.drawio.svg) <!-- .element: style="float: right; width: 30%" -->

Dedicated execution environment per job

Executor talks to infrastructure:

1. Creates volume for working directory
1. Run helper container for checkout into volume
1. Run build container for build using volume

Services are executed in separate containers next to the build container

### Docker

Jobs are executed in a dedicated container

### Kubernetes

Jobs are executed in a dedicated containers in a pod per pipeline

---

## Runner scopes

## Instance runners

Shared across all groups and projects

Reserved for instance administrators

Managed from admin area

## Group/project runners

Shared across a group or a project

Accessible to members with **Owner** role

Shared runners can be disabled
