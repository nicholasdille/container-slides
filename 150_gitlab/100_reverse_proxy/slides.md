<!-- .slide: id="gitlab_traefik" class="vertical-center" -->

<i class="fa-duotone fa-signs-post fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Reverse Proxy

---

## Reverse Proxy in front of GitLab

<i class="fa-duotone fa-signs-post fa-4x fa-duotone-colors" style="float: right;"></i>

Central service for...

- Request routing
- SSL offloading

Examples in this workshop use [`traefik`](https://traefik.io/traefik/)

`traefik` is configured using container labels

---

## Configuration

<i class="fa-duotone fa-signs-post fa-4x fa-duotone-colors" style="float: right;"></i>

Services are reachable by...

- `NAME.seatN.inmylab.de`
- `NAME.IP.nip.io` (fallback)

Deploy using `docker compose` v2:

```
docker compose --project-name gitlab \
    --file compose.traefik.yml \
    --file compose.gitlab.yml \
    up -d
```

Reset by recreating volumes

Your VM has environment variables:

- `DOMAIN`
- `IP`
