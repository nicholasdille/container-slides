<!-- .slide: id="gitlab_traefik" class="vertical-center" -->

<i class="fa-duotone fa-signs-post fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Reverse Proxy

---

## Reverse Proxy in front of GitLab

Central service for...

- Request routing
- SSL offloading

Examples in this workshop use [`traefik`](https://traefik.io/traefik/)

`traefik` is configured using container labels

---

## Configuration

Services are reachable by `NAME.seatN.inmylab.de` or `NAME.IP.nip.io`

```
docker compose --project-name gitlab \
    --file compose.traefik.yml \
    --file compose.gitlab.yml \
    up -d
```

Reset by recreating volumes

VMs have environment variables:

- `DOMAIN`
- `IP`
