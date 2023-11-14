<!-- .slide: id="gitlab_predefined_variables" -->

## Predefined variables

GitLab offers many predefined variables [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html)

Most describe the current job, stage and pipeline

Some describe the GitLab server

Some help interacting with the GitLab server

### Hands-On [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/160_gitlab_ci/020_variables/predefined "020_variables/predefined")

1. Remove `variables` directive

    ```bash
    git checkout origin/160_gitlab_ci/020_variables/predefined -- '*'
    ```
    <!-- .element: style="width: 35em;" -->

1. Update build command:

    ```bash
    go build \
        -ldflags "-X main.Version=${CI_COMMIT_REF_NAME}" \
        -o hello \
        .
    ```
    <!-- .element: style="width: 35em;" -->
