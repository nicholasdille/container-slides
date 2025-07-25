<!-- .slide: id="gitlab_runners" class="vertical-center" -->

<i class="fa-duotone fa-person-running fa-8x" style="float: right; color: grey;"></i>

## Runners

---

## Runners

![](160_gitlab_ci/260_runners/executor.drawio.svg) <!-- .element: style="float: right; width: 30%;" -->

[Runners](https://docs.gitlab.com/runner/) are used to execute jobs in GitLab CI

Extensive configuration [options](https://docs.gitlab.com/runner/configuration/advanced-configuration.html)

Executors interface with infrastructure

---

## Shell Executor

Jobs are executed in the context of the runner

### Upsides <i class="fa-duotone fa-solid fa-thumbs-up"></i>

No infrastructure requirements

### Downsides <i class="fa-duotone fa-solid fa-thumbs-down"></i>

Jobs use the same execution environment

Pollution by job commands

---

## Using containers

![](160_gitlab_ci/260_runners/containers.drawio.svg) <!-- .element: style="float: right; width: 25%" -->

Dedicated execution environment per job

Executor talks to infrastructure:

1. Creates volume for working directory
1. Run helper container for checkout into volume
1. Run build container for build using volume

Services are executed in separate containers next to the build container

### Docker

Jobs are executed in a dedicated container

### Kubernetes

Jobs are executed in a dedicated container in a pod

---

## Runner scopes

### Instance runners

Shared across all groups and projects

Reserved for instance administrators

Managed from admin area

### Group/project runners

Shared across a group or a project

Accessible to members with **Owner** role

Shared runners can be disabled

---

## Runner tags

Runners can have tags

Tags specify features based on...

- Operating system, e.g. linux, windows
- Networking locations, e.g. datacenter, aws, azure
- Hardware, e.g. compute, gpu
- Executor, e.g. shell, docker, kubernetes

### Selecting runners in pipelines

Each job can use a different runner:

```yaml
job_name:
  tags:
  - foo
```

All features work across different runners

---

## Pro tip 1: Finding existing runners

No single place to discover runners

See the CI/CD settings in the runner section

Applies to groups and projects

The list shows runners available

Offers the option to disable instance runners

---

## Pro tip 2: Special purpose executors

Many builtin [executors](https://docs.gitlab.com/runner/executors/)

### Instance executors for auto-scaling (builtin)

On-demand [creation of VMs](https://docs.gitlab.com/runner/executors/instance.html)

Idle VMs are possible to speed up job execution

Support for AWS, Azure and GCP

### Custom executor

Build your own [custom executor](https://docs.gitlab.com/runner/executors/custom.html)

Examples: [libvirt](https://docs.gitlab.com/runner/executors/custom_examples/libvirt.html), [LXD](https://docs.gitlab.com/runner/executors/custom_examples/lxd.html), [AWS Fargate](https://gitlab.com/gitlab-org/ci-cd/custom-executor-drivers/fargate)
