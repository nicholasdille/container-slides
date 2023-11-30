<!-- .slide: id="gitlab_image" class="vertical-center" -->

<i class="fa-duotone fa-layer-group fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Image

---

## Image

Without `image` you rely on the default container image

Our runner configuration defaults to `alpine` [<i class="fa-brands fa-docker"></i>](https://hub.docker.com/_/alpine) [<i class="fa-duotone fa-globe fa-duotone-colors"></i>](https://alpinelinux.org/)

Choose which container `image` [](https://docs.gitlab.com/ee/ci/yaml/#image) is used for your jobs

Each job can have its own container image

Use official images [<i class="fa-brands fa-docker"></i>](https://hub.docker.com/search?q=&image_filter=official)

Do not use community images 

Avoid maintaining custom image

### Hands-On

See chapter [Image](/hands-on/2023-11-30/040_image/exercise/)

---

## Pro tip: Using private registries

Private container registries are supported [](https://docs.gitlab.com/ee/ci/docker/using_docker_images.html#access-an-image-from-a-private-container-registry)

Credentials must be provided in variable `DOCKER_AUTH_CONFIG` [](https://docs.gitlab.com/ee/ci/docker/using_docker_images.html#use-statically-defined-credentials)

- Either defined in pipeline/job
- Or defined globally in runner

### Fill `DOCKER_AUTH_CONFIG`

Variable context matches `~/.docker/config.json`

```json
{ "auths": { "reg.comp.org": { "auth": "<user:pass-base64-encoded>" } } }
```

Fill from environment variables:

```bash
jq --null-input \
    --arg host "${REG_HOST}" \
    --arg auth "$(echo "${REG_USER}:${REG_PASS}" | base64 -w0)" \
    '{"auths": {$host:{"auth": $auth}}}'
```
