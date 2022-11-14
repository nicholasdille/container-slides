<!-- .slide: id="gitlab_variables" class="vertical-center" -->

<i class="fa-duotone fa-square-root-variable fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Variables

---

## Flavors

Variables can be...

- defined in the pipeline definition
- predefined by GitLab
- defined in the UI

### Hands-On [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/master/160_gitlab_ci/020_variables/src "160_gitlab_ci/020_variables/src")

1. Update files from `src/`
1. `variables` in definition:

    ```yaml
    job_name:
      variables:
        version: dev
      script:
      #...
      - go build -o hello -ldflags "-X main.Version=${version}" .
    ```
    <!-- .element: style="width: 35em;" -->
