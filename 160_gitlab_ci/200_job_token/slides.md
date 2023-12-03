<!-- .slide: id="gitlab_job_token" class="vertical-center" -->

<i class="fa-duotone fa-key-skeleton fa-8x fa-duotone-colors-inverted" style="float: right; color: grey;"></i>

## Job token

---

## Job token

Every job has a dedicated job token [](https://docs.gitlab.com/ee/ci/jobs/ci_job_token.html)

Job tokens can be used to authenticate

- Access the package registry [](https://docs.gitlab.com/ee/user/packages/package_registry/index.html#use-gitlab-cicd-to-build-packages)
- Access the container registry (see later [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_registries))
- Download job artifacts [](https://docs.gitlab.com/ee/api/job_artifacts.html#get-job-artifacts)
- Get details of corresponding job [](https://docs.gitlab.com/ee/api/jobs.html#get-job-tokens-job)
- Access job artifacts
- Environment

Job token inherits permissions of triggering user

When using schedules the creator of the schedule is used

Configure the job token to limit access to projects [](https://docs.gitlab.com/ee/ci/jobs/ci_job_token.html#configure-the-job-token-scope-limit)

---

## Heads-Up: Deprecation in GitLab 16.6

Breaking change in behavior of token scope

### Before 16.6

Allowlist of projects a token is allowed to access

Defined outgoing permissions

### Starting with 16.6

Allowlist of projects to allow access from [](https://docs.gitlab.com/ee/ci/jobs/ci_job_token.html#add-a-project-to-the-job-token-scope-allowlist)

Defines incoming access
