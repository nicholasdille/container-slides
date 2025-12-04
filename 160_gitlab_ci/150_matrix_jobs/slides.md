<!-- .slide: id="gitlab_matrix_jobs" class="vertical-center" -->

<i class="fa-duotone fa-cubes-stacked fa-8x" style="float: right; color: grey;"></i>

## Matrix jobs

---

## Matrix jobs

Matrix jobs execute the same script with different inputs

Defined using `parallel` [](https://docs.gitlab.com/ee/ci/yaml/#parallel)

Inputs are specified using environment variables

The `matrix` keyword under `parallel` defines variables sets

### Example

```yaml
job_name:
  parallel:
    matrix:
    - FOO: bar
      BAR: meh
    - FOO: baz
      BAR: [moo meh]
    - FOO: [ABC CED FGH]
      BAR: ruff
```

---

## Using matrix inputs

Matrix variables can be used for...

- Script blocks
- Runner tags
- Image

Maximum of 200 parallel jobs

### Example

```yaml
job_name:
  parallel:
    matrix:
    - STAGE: [ qa, live ]
  image: reg.comp.org/${STAGE}/image:tag
  script: echo "${STAGE}"
```

---

## Hands-On: Matrix jobs

Go to [exercises](/hands-on/2025-11-27/150_matrix_jobs/exercise/)

---

## Pro tip 1: Runner tags

Execute binary on matching hardware:

```yaml
test:
  needs:
  - build
  parallel:
    matrix:
    - GOOS: linux
      GOARCH: [amd64, arm64]
  script:
  - ./hello-${GOOS}-${GOARCH}
  tags:
  - saas-${GOOS}-small-${GOARCH}
```

---

## Pro tip 2: Matrix jobs and `needs`

Depend on individual jobs of a matrix

Extended syntax for `needs` [](https://docs.gitlab.com/ee/ci/yaml/#needsparallelmatrix)

```yaml
linux:build:
  stage: build
  script: echo "Building linux..."
  parallel:
    matrix:
      - PROVIDER: aws
        STACK: [ monitoring, app1, app2 ]

linux:rspec:
  stage: test
  needs:
    - job: linux:build
      parallel:
        matrix:
          - PROVIDER: aws
            STACK: app1
  script: echo "Running rspec on linux..."
```

<!-- .element: style="height: 21em;" -->

---

## Pro tip 3: Job Groups

Jobs can also be grouped manually [](https://docs.gitlab.com/ci/jobs/#group-similar-jobs-together-in-pipeline-views)

```yaml
job 1/3:
  script: pwd

job 2/3:
  script: pwd

job 3/3:
  script: pwd
```

Instead of `/`, more delimiters are allowed: `:`, ` `
