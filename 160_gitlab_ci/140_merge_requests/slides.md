<!-- .slide: id="gitlab_merge_requests" class="vertical-center" -->

<i class="fa-duotone fa-merge fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Merge requests

---

## Merge requests

Merge requests enable collaboration

Pipelines can automatically test merge requests [](https://docs.gitlab.com/ee/ci/pipelines/merge_request_pipelines.html)

Commits to a branch with a merge request cause multiple events:

1. Push event to branch -> **branch pipeline**
1. Merge request event -> **merge request pipeline**

Use rules [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_rules) to decide which jobs to run when

GitLab offers `$CI_PIPELINE_SOURCE` with event name

---

## Merge request pipelines

### What make them different

Only run when configured using the `rules` keyword [](https://docs.gitlab.com/ee/ci/pipelines/merge_request_pipelines.html#use-rules-to-add-jobs)

Have access to more pre-defined variables [](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html#predefined-variables-for-merge-request-pipelines)

Do not have access to protected variables

---

## Rule templates

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

## Hands-On

See chapter [Merge requests](/hands-on/2024-11-21/140_merge_requests/exercise/)

---

## Integration with SonarQube

### Merge request decoration

Write scan results into merge request [](https://docs.sonarsource.com/sonarqube/latest/devops-platform-integration/gitlab-integration/)

Requires Developer Edition

### Quality Gates

Wait for quality gates:

```bash
sonar-scanner -Dsonar.qualitygate.wait=true
```
