<!-- .slide: id="gitlab_releases" class="vertical-center" -->

<i class="fa-duotone fa-rectangle-history-circle-plus fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Releases

---

## Releases

Pipeline jobs can create releases [](https://docs.gitlab.com/ee/user/project/releases/index.html)

...by adding the `release` keyword [](https://docs.gitlab.com/ee/ci/yaml/#release)

Release assets can be linked but must be stored elsewhere

`release-cli` [](https://gitlab.com/gitlab-org/release-cli) must be available

Container images are publicly available [](https://gitlab.com/gitlab-org/release-cli/container_registry)

`registry.gitlab.com/gitlab-org/release-cli:v0.14.0`

Runners using the shell executor must have `release-cli` installed

See official documentation [](https://docs.gitlab.com/ee/user/project/releases/release_cli.html)

---

## Hands-On

See chapter [Releases](/hands-on/2023-11-30/250_releases/exercise/)

---

## Pro tip: Publish asset in package registry

asset in package registry

https://docs.gitlab.com/ee/user/packages/generic_packages/
