<!-- .slide: id="gitlab_renovate" class="vertical-center" -->

<i class="fa-duotone fa-paint-roller fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Renovate

---

## Renovate

Automated updates of dependencies [](https://www.whitesourcesoftware.com/free-developer-tools/renovate/) [<i class="fa-brands fa-github"></i>](https://github.com/renovatebot/renovate) [<i class="fa-solid fa-book"></i>](https://docs.renovatebot.com/)

Not integrated into GitLab

### Options

XXX pipeline-integrated

XXX cron job

XXX https://www.whitesourcesoftware.com/free-developer-tools/renovate/on-premises/

---

## Hands-On: Pipeline-integrated

XXX job token should be sufficient

1. Add `renovate.json` to root of project
1. Add job to `.gitlab-ci.yml`:

    ```yaml
    renovate:
      stage: prepare
      rules:
      - if: $CI_PIPELINE_SOURCE == 'schedule` && $RENOVATE
      image: renovate/renovate:32.52.2
      script: |
        XXX
    ```
1. Check job logs
1. Check merge requests
1. Check pipelines
1. Merge at least one change
