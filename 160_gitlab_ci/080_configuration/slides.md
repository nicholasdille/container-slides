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

### Artifacts

Keep most recent artifacts [](https://docs.gitlab.com/ci/jobs/job_artifacts/#keep-artifacts-from-most-recent-successful-jobs) of successful job

Enabled by default

Artifacts are maintained for branches separately

---

## CI configuration 3/

### Variables

Covered in chapter about variables [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_variables)

### Pipeline trigger tokens

Will be covered in a later chapter about triggers [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_triggers)

### Deploy freezes

Prevent unintentional deployments using Deploy Freeze [](https://docs.gitlab.com/ee/user/project/releases/index.html#prevent-unintentional-releases-by-setting-a-deploy-freeze)

Additional pipeline variable called `CI_DEPLOY_FREEZE` during deploy freeze

Job scripts must implement freeze

---

## CI configuration 4/4

### Job token permissions

Will be covered in a later chapter about the job token [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_job_token)

### Secure files

Will be covered in a later chapter about secure files [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_secure_files)

---

## Pro tip: Keep most recent artifact and artifact expiry

Artifacts are maintained for branches separately

### If enabled (default)

`expire_in` does not apply to the most recent artifact

Outdated artifacts are removed after the specified time

### If disabled

`expire_in` applies to all artifacts

All artifacts are removed after the specified time

---

## Custom CI/CD configuration file

Instead of `.gitlab-ci.yml`, you can... [](https://docs.gitlab.com/ci/pipelines/settings/#custom-cicd-configuration-file-examples)

- Use a different file name - even in a subdirectory

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
