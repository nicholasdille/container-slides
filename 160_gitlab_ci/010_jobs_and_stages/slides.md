<!-- .slide: id="gitlab_jobs" class="vertical-center" -->

<i class="fa-duotone fa-arrow-down-1-9 fa-8x" style="float: right; color: grey;"></i>

## Jobs and stages

---

## Pipeline-as-Code

GitLab does not offer a visual pipeline editor

Pipelines are described in YAML [](https://yaml.org/)

Pipelines are stored in `.gitlab-ci.yml`

---

## YAML Ain't Markup Language

Human-readable data serialization format [](https://yaml.org/)

```yaml
# Commends are allowed
firstname: Nicholas
lastname: Dille
# Hash array keys are indented
# YAML usually uses two spaces for indentation
contact:
  email: you@wish.dev
  linkedin: https://www.linkedin.com/in/nicholasdille
  bsky: https://bsky.app/profile/nicholas.dille.name

# Empty lines are allowed
web:
- title: Blog
  link: https://dille.name
- title: GitHub
  link: https://github.com/nicholasdille
- title: GitLab
  link: https://gitlab.com/nicholasdille

# Array elements may be indented
# You must be consistent in one array
projects:
  - name: uniget
    homepage: https://uniget.dev
    code: https://gitlab.com/uniget-org
```

<!-- .element: style="height: 30em;" -->

---

## YAML...

```yaml
top:
- item1: value1
- item2:
    subitem1: value2
    subitem2: value3
- item3: value
  subitem1: value4
```

### ...to JSON

```json
{
  "top:" [
    { "item1": "value1" },
    { "item2": { "subitem1": "value2", "subitem2": "value3" } },
    { "item3": "value", "subitem1": "value4" }
  ]
}
```

---

## Tools for YAML/JSON

- JSON query `jq` [](https://github.com/jqlang/jq)
- JSON viewer `jless` [](https://jless.io)
- YAML query `yq` [](https://github.com/mikefarah/yq)
- Linter
  - `yamllint` [](https://github.com/adrienverge/yamllint)
  - Stoplight `Spectral` [](https://stoplight.io/spectral)
---

## Jobs

Minimal job:

```yaml
job_name:
  script: pwd
```

`script` can be a string but is mostly an array:

```yaml
job_name:
  script:
  - pwd
  - whoami
```

Jobs fail if any command fails (exit code > 0)

---

## Jobs with herestrings

`script` supports all herestring variants of YAML [](https://docs.gitlab.com/ee/ci/yaml/script.html#split-long-commands)

Literal multiline block where line breaks are preserved:

```yaml
job_name:
  script:
  - |
    pwd
    whoami
```

Use this for commands with URLs or the colon will break parsing

Multiline block where line breaks are removed:

```yaml
job_name:
  script:
  - >
    ls
    -l
```

---

## Jobs and stages

Jobs represent isolated steps in a pipeline

Stages [](https://docs.gitlab.com/ee/ci/yaml/#stages) are executed sequentially

Jobs in the same stage are executed in parallel

![](160_gitlab_ci/010_jobs_and_stages/jobs_and_stages.drawio.svg) <!-- .element: style="width: 45%;" -->

Special stages `.pre` and `.post`

---

## Hands-On: Job and stages

Go to [exercises](/hands-on/2025-11-27/010_jobs_and_stages/exercise/)

---

## Pro tip 1: Skip pipeline for push

Sometimes a pipeline run is not desirable

### Option 1

Skip pipeline by adding `[skip ci]` in the commit message:

```plaintext
[skip ci] My awesome commit message
OR
My awesome commit message [skip ci]
```

Anywhere in the title or body of the commit message

### Option 2

Leave commit message untouched

Provide a push option:

```bash
git push -o ci.skip
```

---

## Pro tip 2: Pipeline Editor

The web UI offers a pipeline editor

Integrated syntax checking

---

## Pro tip 3: Collapsed multi-line string

Multi-line commands are collapsed by default

Feature flag `FF_SCRIPT_SECTIONS` to print full command in logs:

```yaml
my_job:
  variables:
    FF_SCRIPT_SECTIONS: true
  script:
  - echo START
  - |
    if test -f foo; then
        echo "File foo found"
    fi
  - echo END
```

---

## Fun fact: Pushing the boundaries of multi-line

The following works:

```yaml
my_job:
  script:
  - if test -f foo; then
  -   echo "File foo found"
  - fi
```

### Reason

The commands are copied into the `step_script` line by line
