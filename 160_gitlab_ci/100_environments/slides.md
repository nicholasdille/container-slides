<!-- .slide: id="gitlab_environments" class="vertical-center" -->

<i class="fa-duotone fa-fence fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Environments

---

## Environments

Environments are deployment targets [](https://docs.gitlab.com/ee/ci/environments/)

CI variables can be scoped to environments

Environments are auto-created by the first job using them

Your demo environment has hidden services

![](160_gitlab_ci/100_environments/webdav.drawio.svg) <!-- .element: style="width: 70%;" -->

WebDAV endpoints emulate deployment targets

---

## Hands-On (1/2) [<i class="fa fa-comment-code"></i>]((https://github.com/nicholasdille/container-slides/tree/100_environments/demo1 "100_environments/demo1")

1. Retrieve passwords for dev and live environments:

    ```bash
    docker ps --filter "label=com.docker.compose.service=nginx" --quiet \
    | xargs -I{} docker logs {} | grep "Password for "
    ```
    <!-- .element: style="width: 45em;" -->

1. Create unprotected CI variable `PASS` twice with scope `dev` and `live`
1. Create unprotected CI variable `SEAT_INDEX` with your seat number
1. Add new stage and job called `deploy`
1. Upload to WebDAV server `dev` using `curl`
1. Download from https://dev.seatN.inmylab.de/hello
1. Check environments

See new `.gitlab-ci.yml`:

```bash
git checkout 100_environments/demo1 -- '*'
```

---

## Pro tip

Branches can be used to represent target environments:

- `dev` for development branch
- `live` for production code

---

## Hands-On (2/2) [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/100_environments/demo2 "100_environments/demo2")

1. Create branch called `dev`
1. Use environment `${CI_COMMIT_REF_NAME}`
1. Commit and check pipeline
1. Create branch `live` from `dev`
1. Download from https://dev.seatN.inmylab.de/hello and live equivalent

See new `.gitlab-ci.yml`:

```bash
git checkout 100_environments/demo2 -- '*'
```
