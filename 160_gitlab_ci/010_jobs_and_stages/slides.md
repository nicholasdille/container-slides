<!-- .slide: id="gitlab_jobs" class="vertical-center" -->

<i class="fa-duotone fa-arrow-down-1-9 fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Jobs and stages

---

## Jobs and stages

Jobs represent isolated steps in a pipeline

Stages [](https://docs.gitlab.com/ee/ci/yaml/#stages) are executed sequentially

Jobs in the same stage are executed in parallel

![](160_gitlab_ci/010_jobs_and_stages/jobs_and_stages.drawio.svg) <!-- .element: style="width: 60%;" -->

Special stages `.pre` and `.post`

---

## Job layout

Minimal job:

```yaml
job_name:
  script:
  - whoami
  - pwd
  - printenv | sort
```

`script` is a string and supports all herestring variants of YAML

### Testing job scripts

Script blocks can be testing using a container based on `alpine`:

```bash
docker run -it --rm -v $PWD:/src -w /src alpine sh
```

---

## Example code

Based on Go [](https://go.dev/)

See `src/main.go`

Build command: `go build -o hello .`

### Playground

Use docker to play:

```bash
docker run --interactive --tty --rm \
    --volume ${PWD}:/project --workdir /project \
    golang:1.18 bash
```

### Dependency management

Initialize dependency information: `go mod init`

Update dependency information: `go mod tidy`

---

## My first CI job

XXX

### Hands-On

1. Create project
1. Add files from `src/` to root of project
1. Add `build/.gitlab-ci.yml` to root of project
1. Check pipeline

---

## My first stage

XXX

### Hands-On

1. Add `lint/.gitlab-ci.yml` to root of project
1. Check pipeline
