<!-- .slide: id="gitlab_ci_configuration" class="vertical-center" -->

<i class="fa-duotone fa-calendar-clock fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## CI configuration

---

## CI configuration 1/

Some useful settings

### General pipelines

Git strategy is not relevant for executors like Docker and Kubernetes

Get badges for pipelines status, coverage report and the latest release

### Auto DevOps

Audo DevOps [](https://docs.gitlab.com/ee/topics/autodevops/) provides preconfigured jobs for building, testing and scanning software projects

### Runners

Connect specific runners

Disable shared runners

---

## CI configuration 2/2

More useful settings

### Deploy freezes

Prevent unintentional deployments using Deploy Freeze [](https://docs.gitlab.com/ee/user/project/releases/index.html#prevent-unintentional-releases-by-setting-a-deploy-freeze)

Use `$CI_DEPLOY_FREEZE` to check for deploy freeze
