<!-- .slide: id="gitlab_unit_tests" class="vertical-center" -->

<i class="fa-duotone fa-magnifying-glass-chart fa-8x" style="float: right; color: grey;"></i>

## Unit tests

---

## Unit Tests

GitLab is able to consume JUnit XML formatted [reports](https://docs.gitlab.com/ee/ci/testing/unit_test_reports.html)

Reports must be defined as a special type of artifact

Reports will be displayed in the summary view of a pipeline

The following example was taken from the [official one](https://docs.gitlab.com/ee/ci/testing/unit_test_report_examples.html#go):

```yaml
golang:
  stage: test
  script:
    - go install gotest.tools/gotestsum@latest
    - gotestsum --junitfile report.xml --format testname
  artifacts:
    when: always
    reports:
      junit: report.xml
```

### Hands-On

See chapter [Unit tests](/hands-on/2025-11-27/090_unit_tests/exercise/)
