<!-- .slide: id="gitlab_environments" class="vertical-center" -->

<i class="fa-duotone fa-fence fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Environments

---

## Environments

Environments are deployment targets [](https://docs.gitlab.com/ee/ci/environments/)

CI variables can be scoped to environments

XXX

![](160_gitlab_ci/100_environments/webdav.drawio.svg) <!-- .element: style="width: 70%;" -->

(Hint: Environments can also be assigned using branch names)

---

## Hands-On

1. Retrieve passwords for dev and live environments:

    ```bash
    docker ps --filter "label=com.docker.compose.service=nginx" --quiet \
    | xargs -I{} docker logs {} \
    | grep "Password for "
    ```

1. Create CI variables `PASS_DEV`/`PASS_LIVE` with scope `dev`/`live`
1. Add new stage and job called `deploy`
1. Upload to WebDAV server using `curl`
1. Create branch `dev` and `live`
1. Download from https://dev.seatN.inmylab.de/hello and live

(See new `.gitlab-ci.yml`)
