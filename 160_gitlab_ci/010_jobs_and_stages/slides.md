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
  - printenv
```

### Testing job scripts

XXX test script block using

```bash
docker run -it --rm -v $PWD:/src -w /src alpine sh
```

---

## Example code

XXX golang

XXX see `src/main.go`

XXX build: `go build -o hello .`

XXX dep management init: `go mod init`

XXX dep management update: `go mod tidy`

XXX testing: `docker run -it --rm -v ${PWD}/src:/src -w /src golang:1.18 bash`

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
