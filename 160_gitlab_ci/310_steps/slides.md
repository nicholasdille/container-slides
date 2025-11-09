<!-- .slide: id="gitlab_steps" class="vertical-center" -->

<i class="fa-duotone fa-stairs fa-8x" style="float: right; color: grey;"></i>

## CI/CD Steps (experimental)

---

## CI/CD Steps (experimental)

[Steps](https://docs.gitlab.com/ee/ci/steps/) are reusable units of a job

The can replace `script` with one or more `steps` under [`run`](https://docs.gitlab.com/ee/ci/yaml/#run)

No more [`!reference[]`](https://docs.gitlab.com/ee/ci/yaml/yaml_optimization.html#reference-tags) tags to merge multiple script blocks

```yaml
job:
  variables:
    MESSAGE: "GitLab workshop"
  run:
    - name: say_hi
      step: gitlab.inmylab.de/steps/message@v1.0.0
      inputs:
        message: "hello, ${{ job.MESSAGE }}"
```

Steps can be combined with CI/CD Components [<i class="fa fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_components)

GitLab Runner <17.11 requires [`step-runner`](https://gitlab.com/gitlab-org/step-runner) binary

GitLab Runner >= 17.11 injects `step-runner`

Steps can also be used to [run existing GitHub Actions](https://docs.gitlab.com/ee/ci/steps/#run-a-github-action)

Eventually [steps will be discoverable in the CI/CD Catalog](https://gitlab.com/gitlab-org/gitlab/-/issues/425891)

---

## Comparison

Smaller units than jobs

### Steps vs. Components

Both are self-contained

Both are configurable through `inputs`

Common layout, i.e. header and body

### Steps vs. Templates

Steps are a smaller unit than templates

Steps are easier to compose...

...compared to `!reference[]` tags

---

## Hands-On

See chapter [CI/CD Steps](/hands-on/2025-11-18/310_steps/exercise/)
