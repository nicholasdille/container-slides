<!-- .slide: id="gitlab_var_precedence" class="vertical-center" -->

<i class="fa-duotone fa-arrow-down-short-wide fa-8x" style="float: right; color: grey;"></i>

## Variable precedence

---

## Variable precedence

Variables can be defined on many different levels

The order from lowest to highest precedence [](https://docs.gitlab.com/ee/ci/variables/#cicd-variable-precedence) is:

- Predefined variables [](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html)
- Deployment variables [](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html#deployment-variables)
- Global variables in `.gitlab-ci.yml` (including workflow rules)
- Job variables in `.gitlab-ci.yml` (after template and rule resolution)
- Variables from `dotenv` reports [](https://docs.gitlab.com/ee/ci/variables/#pass-an-environment-variable-to-another-job)
- Instance variables [](https://docs.gitlab.com/ee/ci/variables/#for-an-instance)
- Group variables [](https://docs.gitlab.com/ee/ci/variables/#for-a-group)
- Project variables [](https://docs.gitlab.com/ee/ci/variables/#for-a-project)
- Pipeline variables (more on next slide)
- Scan execution policy variables [](https://docs.gitlab.com/ee/user/application_security/policies/scan_execution_policies.html)
- Pipeline execution policy variables [](https://docs.gitlab.com/ee/user/application_security/policies/pipeline_execution_policies.html#cicd-variables)

<!-- .element: style="font-size: smaller" -->

<i class="fa-duotone fa-solid fa-triangle-exclamation"></i> Note that CI/CD variables take precedence over `variables` <i class="fa-duotone fa-solid fa-triangle-exclamation"></i>

---

## More about pipeline variables

Variables that are passed when starting a pipeline [](https://docs.gitlab.com/ee/ci/variables/#use-pipeline-variables)

They have the same precedence:

- Manual job variables [](https://docs.gitlab.com/ee/ci/jobs/index.html#specifying-variables-when-running-manual-jobs)
- Creating a pipeline trough the API [](https://docs.gitlab.com/ee/api/pipelines.html#create-a-new-pipeline)
- Manual pipeline run [](https://docs.gitlab.com/ee/ci/pipelines/index.html#run-a-pipeline-manually)
- Scheduled pipeline variables [](https://docs.gitlab.com/ee/ci/pipelines/schedules.html#add-a-pipeline-schedule)
- Trigger variables [](https://docs.gitlab.com/ee/ci/triggers/index.html#pass-cicd-variables-in-the-api-call)
- Variables passed downstream [](https://docs.gitlab.com/ee/ci/pipelines/downstream_pipelines.html#pass-cicd-variables-to-a-downstream-pipeline)

Only one is possible at any time
