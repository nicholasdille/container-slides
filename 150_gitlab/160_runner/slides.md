<!-- .slide: class="vertical-center" -->

<i class="fa-duotone fa-person-running fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Runner

---

## Runner

<i class="fa-duotone fa-person-running fa-4x fa-duotone-colors" style="float: right;"></i>

XXX https://docs.gitlab.com/runner/

XXX https://gitlab.com/gitlab-org/gitlab-runner

XXX executors: shell, docker, docker-windows, docker-ssh, ssh, parallels, virtualbox, docker+machine, docker-ssh+machine, kubernetes

XXX shell

XXX docker

XXX kubernetes

---

## XXX

XXX shared, group, specific (project)

XXX select by tags

XXX https://docs.gitlab.com/runner/configuration/advanced-configuration.html

```bash
docker compose --project-name gitlab \
    --file ../100_reverse_proxy/compose.traefik.yml \
    --file ../100_reverse_proxy/compose.gitlab.yml \
    --file compose.yml \
    up -d
```
