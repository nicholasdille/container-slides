<!-- .slide: id="gitlab_jobs" class="vertical-center" -->

<i class="fa-duotone fa-arrow-down-1-9 fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Jobs and stages

---

## Jobs and stages

XXX

XXX https://docs.gitlab.com/ee/ci/yaml/#stages

![](160_gitlab_ci/010_jobs_and_stages/jobs_and_stages.drawio.svg)

XXX running on alpine

XXX test script block using `docker run -it --rm -v $PWD:/src -w /src alpine sh`

---

## My first CI job

XXX

### Hands-On

1. Add files from `src/` to root of project
1. Add `build/.gitlab-ci.yml` to root of project
1. Check pipeline

---

## My first stage

XXX

### Hands-On

1. Add `lint/.gitlab-ci.yml` to root of project
1. Check pipeline
