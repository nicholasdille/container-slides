<!-- .slide: id="gitlab_ci_manual" class="vertical-center" -->

<i class="fa-duotone fa-light-switch-on fa-8x fa-duotone-colors-inverted" style="float: right; color: grey;"></i>

## Manual Pipelines

---

## Manual Pipelines

<i class="fa-duotone fa-solid fa-4x fa-light-switch-on"></i> <!-- .element: style="float: right;" -->

Manual trigger from the pipeline overview in the web UI

Pipeline variables can be added manually

But simple forms are also possible [](https://docs.gitlab.com/ci/pipelines/#prefill-variables-in-manual-pipelines)

Global variables can have...

- Description in `variables:description` [](https://docs.gitlab.com/ci/yaml/#variablesdescription)
- Default value in `variables:value` [](https://docs.gitlab.com/ci/yaml/#variablesvalue)
- Dropdown options in `variables:options` [](https://docs.gitlab.com/ci/yaml/#variablesoptions)

### See also

Pipeline inputs in a later chapter [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_ci_inputs)

---

## Example

Use global variables for basic forms:

```yaml
variables:
  favorite_fruit:
    description: "My favorite fruit"
    value: apple
    options:
    - apple
    - banana
    - strawberry

job_name:
  script: |
    echo "My favorite fruit is $favorite_fruit"
```
