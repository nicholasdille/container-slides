<!-- .slide: id="gitlab_matrix_jobs" class="vertical-center" -->

<i class="fa-duotone fa-cubes-stacked fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Matrix jobs

---

## Matrix jobs

Matrix jobs execute the same script with different inputs

Defined using `parallel` [](https://docs.gitlab.com/ee/ci/yaml/#parallel)

Inputs are specified using environment variables

The `matrix` keyword under `parallel` defines variables sets

Matrix variables can be used for...

- Script blocks
- Runner tags
- Image

---

## Hands-On

See chapter [Matrix jobs](/hands-on/2023-11-30/150_matrix_jobs/exercise/)
