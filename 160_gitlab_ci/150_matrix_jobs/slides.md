<!-- .slide: id="gitlab_matrix_jobs" class="vertical-center" -->

<i class="fa-duotone fa-cubes-stacked fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

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

## Hands-On

See chapter [Matrix jobs](/hands-on/2024-11-21/150_matrix_jobs/exercise/)

---

## Pro tip: Matrix jobs and `needs`

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
