<!-- .slide: id="gitlab_unit_tests" class="vertical-center" -->

<i class="fa-duotone fa-cubes fa-8x fa-duotone-colors-inverted" style="float: right; color: grey;"></i>

## Unit tests

---

## Unit Tests

XXX https://docs.gitlab.com/ee/ci/testing/unit_test_reports.html

XXX example https://docs.gitlab.com/ee/ci/testing/unit_test_report_examples.html#go

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

---

## Hands-On

XXX
