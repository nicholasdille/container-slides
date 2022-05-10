<!-- .slide: id="gitlab_rollout" class="vertical-center" -->

<i class="fa-duotone fa-rocket-launch fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Rollout

---

## Rollout

Deploy GitLab as separate services

Deploy a runner for CI jobs

Use `traefik` to route requests

```bash
docker compose --project-name gitlab \
    --file ../100_reverse_proxy/compose.traefik.yml \
    --file ../180_components/compose.yml \
    --file ../160_runner/compose.yml \
    up -d
```
