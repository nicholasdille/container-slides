## Rollout

---

XXX

```bash
docker compose --project-name gitlab \
    --file ../100_reverse_proxy/compose.traefik.yml \
    --file ../180_resources/compose.yml \
    --file ../160_runner/compose.yml \
    up -d
```
