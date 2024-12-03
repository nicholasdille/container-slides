<!-- .slide: id="gitlab_merge_requests" class="vertical-center" -->

<i class="fa-duotone fa-merge fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Merge requests

---

## Merge requests

Merge requests enable collaboration

Pipelines can automatically test merge requests [](https://docs.gitlab.com/ee/ci/pipelines/merge_request_pipelines.html)

Commits to a branch with a merge request cause multiple events:

1. Push event to branch -> **branch pipeline** <i class="fa-duotone fa-solid fa-code-branch"></i>
1. Merge request event -> **merge request pipeline** <i class="fa-duotone fa-solid fa-code-pull-request"></i>

Use rules [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_rules) to decide which jobs to run when

GitLab offers `$CI_PIPELINE_SOURCE` with event name

---

## Merge request pipelines

### What make them different

Only run when configured using the `rules` keyword [](https://docs.gitlab.com/ee/ci/pipelines/merge_request_pipelines.html#use-rules-to-add-jobs)

Have access to more pre-defined variables [](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html#predefined-variables-for-merge-request-pipelines)

Do not have access to protected variables

---

## Hands-On

See chapter [Merge requests](/hands-on/2024-11-21/140_merge_requests/exercise/)

---

## Pro tip 1: Rule templates

Pipelines often have many jobs

Rules will be repeated multiple times

Combine rules with templates to prevent repetition

```yaml
.rule-only-web:
  rules:
  - if: $CI_PIPELINE_SOURCE == 'web'

job_name:
  extends:
  - .rule-only-web
  #...
```

---

## Pro tip 2: Integration with SonarQube

### Merge request decoration

Write scan results into merge request [](https://docs.sonarsource.com/sonarqube/latest/devops-platform-integration/gitlab-integration/)

Requires Developer Edition

### Quality Gates

Wait for quality gates:

```bash
sonar-scanner -Dsonar.qualitygate.wait=true
```

---

## Pro tip 3: Pipelines and multiple branches

Pipeline is executed from `.gitlab-ci.yml` in the branch

Test changes to pipeline in a branch

---

## Pro tip 4: Merged results pipelines

Runs after a merge [](https://docs.gitlab.com/ee/ci/pipelines/merged_results_pipelines.html)

Only available in Premium subscription
