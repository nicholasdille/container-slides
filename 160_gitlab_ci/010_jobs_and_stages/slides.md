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
    multi
    line
```

Shell here documents:

```yaml
job_name:
  script:
  - |
    tr a-z A-Z <<EOF
    lower case to be converted to upper case
    EOF
```

--

### Testing job scripts

Script blocks can be testing using a container based on `alpine`:

```bash
docker run -it --rm -v $PWD:/src -w /src alpine sh
```

---

## Jobs and stages

Jobs represent isolated steps in a pipeline

Stages [](https://docs.gitlab.com/ee/ci/yaml/#stages) are executed sequentially

Jobs in the same stage are executed in parallel

![](160_gitlab_ci/010_jobs_and_stages/jobs_and_stages.drawio.svg) <!-- .element: style="width: 60%;" -->

Special stages `.pre` and `.post`

---

## Example code

Based on Go [](https://go.dev/)

See `main.go`

Initialize dependency information: `go mod init`

Update dependency information: `go mod tidy`

Build command: `go build -o hello .`

### Playground for experts

Use docker to play:

```bash
docker run --interactive --tty --rm \
    --volume ${PWD}:/project --workdir /project \
    golang bash
```

---

## Hands-On (1)

### First CI job [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/010_jobs_and_stages/build "010_jobs_and_stages/build")

1. Create project
1. Add files to root of project:

    ```bash
    git checkout 010_jobs_and_stages/build -- '*'
    ```
    <!-- .element: style="width: 40em;" -->

1. Check pipeline

---

## Hands-On (2)

### Add a stage [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/010_jobs_and_stages/lint "010_jobs_and_stages/lint")

1. Add `lint/.gitlab-ci.yml` to root of project:

    ```bash
    git checkout 010_jobs_and_stages/lint -- '*'
    ```
    <!-- .element: style="width: 40em;" -->

1. Check pipeline

---

## Hands-On (3)

### Add parallel jobs [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/010_jobs_and_stages/parallel "010_jobs_and_stages/parallel")

1. Add `parallel/.gitlab-ci.yml` to root of project:

    ```bash
    git checkout 010_jobs_and_stages/parallel -- '*'
    ```
    <!-- .element: style="width: 40em;" -->

1. Check pipeline

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
