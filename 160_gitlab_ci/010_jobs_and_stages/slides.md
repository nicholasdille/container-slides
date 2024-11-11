<!-- .slide: id="gitlab_jobs" class="vertical-center" -->

<i class="fa-duotone fa-arrow-down-1-9 fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Jobs and stages

---

## Pipeline-as-Code

GitLab does not offer a visual pipeline editor

Pipelines are described in YAML [](https://yaml.org/)

Pipelines are stored in `.gitlab-ci.yml`

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

Literal multiline block:

```yaml
job_name:
  script:
  - |
    pwd
    whoami
```

Use this for commands with URLs or the colon will break parsing

Shell here documents:

```yaml
job_name:
  script:
  - |
    tr a-z A-Z <<EOF
    lower case to be converted to upper case
    EOF
```

---

## Jobs and stages

Jobs represent isolated steps in a pipeline

Stages [](https://docs.gitlab.com/ee/ci/yaml/#stages) are executed sequentially

Jobs in the same stage are executed in parallel

![](160_gitlab_ci/010_jobs_and_stages/jobs_and_stages.drawio.svg) <!-- .element: style="width: 60%;" -->

Special stages `.pre` and `.post`

---

## Hands-On

See chapter [Jobs and stages](/hands-on/2024-11-12/010_jobs_and_stages/exercise/)

---

## Pro tip: Skip pipeline for push

Sometimes a pipeline run is not desirable

### Option 1

Skip pipeline by prefixing the commit message:

```plaintext
[skip ci] My awesome commit message
```

### Option 2

Leave commit message untouched

Provide a push option:

```bash
git push -o ci.skip
```
