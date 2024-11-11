<!-- .slide: id="gitlab_steps" class="vertical-center" -->

<i class="fa-duotone fa-stairs fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## CI/CD Steps (experimental)

---

## CI/CD Steps (experimental)

Steps are reusable units of a job [](https://docs.gitlab.com/ee/ci/steps/)

The can replace `script` with one or more `steps` under `run` [](https://docs.gitlab.com/ee/ci/yaml/#run)

No more `!reference[]` tags [](https://docs.gitlab.com/ee/ci/yaml/yaml_optimization.html#reference-tags) to merge multiple script blocks

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

Requires `step-runner` binary [](https://gitlab.com/gitlab-org/step-runner)

Steps can also be used to run existing GitHub Actions [](https://docs.gitlab.com/ee/ci/steps/#run-a-github-action)

Eventually steps will be discoverable in the CI/CD Catalog [](https://gitlab.com/gitlab-org/gitlab/-/issues/425891)

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

See chapter [CI/CD Steps](/hands-on/2024-11-12/310_steps/exercise/)
