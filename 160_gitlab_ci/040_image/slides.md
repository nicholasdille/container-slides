<!-- .slide: id="gitlab_image" class="vertical-center" -->

<i class="fa-duotone fa-layer-group fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Image

---

## Image

Choose which container image [](https://docs.gitlab.com/ee/ci/yaml/#image) is used for your job

Our runner configuration defaults to `alpine` [<i class="fa-brands fa-docker"></i>](https://hub.docker.com/_/alpine) [<i class="fa-duotone fa-globe fa-duotone-colors"></i>](https://alpinelinux.org/)

Use official images [<i class="fa-brands fa-docker"></i>](https://hub.docker.com/search?q=&image_filter=official)

Do not use community images 

Avoid maintaining custom image

### Image allowlist

XXX [](https://docs.gitlab.com/runner/executors/kubernetes.html#restrict-docker-images-and-services)

---

## Hands-On [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/160_gitlab_ci/040_image "040_image")

Use `image` instead of `before_script`

1. Add `image: golang:1.19.2` to all jobs
1. Remove `before_script` from all jobs

See new `.gitlab-ci.yml`:

```bash
git checkout origin/160_gitlab_ci/040_image -- '*'
```
