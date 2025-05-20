<!-- .slide: id="gitlab_ci_configuration" class="vertical-center" -->

<i class="fa-duotone fa-calendar-clock fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## CI configuration

---

## CI configuration 1/

Some useful settings

### General pipelines

Git strategy is not relevant for executors like Docker and Kubernetes

Get badges for pipelines status, coverage report and the latest release

Shallow clones with 20 depth

Job timeout defaults to 1h ...

...but can be overridden in `.gitlab-ci.yml` using `timeout` [](https://docs.gitlab.com/ee/ci/yaml/#timeout)

Automatic pipeline cleanup removes old pipelines (disabled by default)

### Auto DevOps

Auto DevOps [](https://docs.gitlab.com/ee/topics/autodevops/) provides preconfigured jobs for building, testing and scanning software projects

---

## CI configuration 2/

More useful settings

### Runners [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_runners)

Connect specific runners

Disable shared runners

### Deploy freezes

Prevent unintentional deployments using Deploy Freeze [](https://docs.gitlab.com/ee/user/project/releases/index.html#prevent-unintentional-releases-by-setting-a-deploy-freeze)

Job scripts must implement freeze

Use `$CI_DEPLOY_FREEZE` to check for active deploy freeze

We will come back to this later!

---

## Custom CI/CD configuration file

Instead of `.gitlab-ci.yml`, you can... [](https://docs.gitlab.com/ci/pipelines/settings/#custom-cicd-configuration-file-examples)

- Use a different file name

    ```plaintext
    pipeline.yaml
    ```

- Move it to a subdirectory

    ```plaintext
    pipeline/definition.yaml
    ```

- Fetch it from a URL

    ```plaintext
    https://www.my-company.de/gitlab-ci.yml
    ```

- Fetch it from a file in another repository

    ```plaintext
    path/to/.gitlab-ci.yml@group/subgroup/project
    ```

<i class="fa-duotone fa-triangle-exclamation"></i> Use with care and communicate propery <i class="fa-duotone fa-triangle-exclamation"></i>
