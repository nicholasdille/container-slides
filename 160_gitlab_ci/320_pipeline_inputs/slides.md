<!-- .slide: id="gitlab_ci_inputs" class="vertical-center" -->

<i class="fa-duotone fa-pen-field fa-8x" style="float: right; color: grey;"></i>

## Pipeline Inputs

---

## Pipeline Inputs

<i class="fa-duotone fa-solid fa-4x fa-pen-field"></i> <!-- .element: style="float: right;" -->

Supercedes variable-based forms for [manual pipelines](#/gitlab_ci_manual)

GA since GitLab 17.0 (May 2024)

Pipeline is expressed with...
- New header for supported [inputs](https://docs.gitlab.com/ci/inputs/) (see below)
- Body with jobs

Introduces a new [`spec:inputs`](https://docs.gitlab.com/ci/yaml/#specinputs) section in the header

### Example

  ```yaml
  spec:
    inputs: {}
  ---
  job_name:
    script: pwd
  ```

---

## Inputs

Inputs are templated into the jobs:

  ```yaml
  spec:
    inputs:
      favorite_fruit:
        type: string
        default: apple
        options:
        - apple
        - banana
        - strawberry
  ---
  job_name:
    script: |
      echo "My favorite fruit is $[[ inputs.favorite_fruit ]]"
  ```

Functions are available to [manipulate the inputs](https://docs.gitlab.com/ci/inputs/#predefined-interpolation-functions)

Functions are added as pipes: `$[[ inputs.favorite_fruit | <func> ]]`

Example: Support nested variables using the `expand_vars` function
