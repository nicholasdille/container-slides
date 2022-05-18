<!-- .slide: id="gitlab_releases" class="vertical-center" -->

<i class="fa-duotone fa-rectangle-history-circle-plus fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Releases

---

## Releases

Pipeline jobs can create releases [](https://docs.gitlab.com/ee/user/project/releases/index.html)

...by adding the `release` keyword [](https://docs.gitlab.com/ee/ci/yaml/#release)

Release assets can be linked but must be stored elsewhere

`release` uses `release-cli` [](https://docs.gitlab.com/ee/user/project/releases/release_cli.html) internally

Container images are publicly available [](https://gitlab.com/gitlab-org/release-cli/container_registry)

`registry.gitlab.com/gitlab-org/release-cli:v0.11.0`

Runners using the shell executor must have `release-cli` installed

---

## Hands-On

1. Extends `pages` in `.gitlab-ci.yml`:

    ```yaml
    pages:
      #...
      release:
        tag_name: ${CI_PIPELINE_IID}
        name: Release ${CI_PIPELINE_IID}
        description: |
          Some multi
          line text
        ref: ${CI_COMMIT_SHA}
    ```

1. Go to **Deployments > Releases**
