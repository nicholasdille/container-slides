<!-- .slide: id="gitlab_releases" class="vertical-center" -->

<i class="fa-duotone fa-rectangle-history-circle-plus fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Releases

---

## Releases

XXX [](https://docs.gitlab.com/ee/ci/yaml/#release)

XXX [](https://docs.gitlab.com/ee/user/project/releases/index.html)

XXX shell executor requires [release-cli](https://docs.gitlab.com/ee/user/project/releases/release_cli.html)

### Hands-On

1. Extends `deploy` in `.gitlab-ci.yml`:

    ```yaml
    deploy:
      #...
      release:
        tag_name: ${CI_PIPELINE_IID}
        name: Release ${CI_PIPELINE_IID}
        description: |
          Some multi
          line text
        ref: ${CI_COMMIT_SHA}
    ```
