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
    - FOO: baz
    - FOO: [ABC CED FGH]
```

---

## Using matrix inputs

Matrix variables can be used for...

- Script blocks
- Runner tags
- Image

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

See chapter [Matrix jobs](/hands-on/2023-11-30/150_matrix_jobs/exercise/)
