<!-- .slide: id="gitlab_predefined_variables" -->

## Predefined variables

GitLab offers many predefined variables [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html)

Most describe the current job, stage and pipeline

Some describe the GitLab server

Some help interacting with the GitLab server

### Hands-On

1. Remove `variables` directive
1. Update build command:

    ```bash
    go build \
        -ldflags "-X main.Version=${CI_COMMIT_REF_NAME}" \
        -o hello \
        .
    ```
    <!-- .element: style="width: 35em;" -->
