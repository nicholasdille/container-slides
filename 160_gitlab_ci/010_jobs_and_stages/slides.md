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

See `src/main.go`

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

## Hands-On

Follow in web UI or IDE

### First CI job [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/master/160_gitlab_ci/010_jobs_and_stages/src "160_gitlab_ci/010_jobs_and_stages/src")

1. Create project
1. Add files from `src/` to root of project
1. Add `build/.gitlab-ci.yml` to root of project
1. Check pipeline

### Add a stage [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/master/160_gitlab_ci/010_jobs_and_stages/lint "160_gitlab_ci/010_jobs_and_stages/lint")

1. Add `lint/.gitlab-ci.yml` to root of project
1. Check pipeline

### Add parallel jobs [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/master/160_gitlab_ci/010_jobs_and_stages/parallel "160_gitlab_ci/010_jobs_and_stages/parallel")

1. Add `parallel/.gitlab-ci.yml` to root of project
1. Check pipeline
