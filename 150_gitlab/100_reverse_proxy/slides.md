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
docker rm -f gitlab
docker compose --project-name gitlab \
    --file compose.traefik.yml \
    --file compose.gitlab.yml \
    up -d
```

Reset by recreating volumes

Your VM has environment variables:

- `DOMAIN`
- `IP`

---

## TLS

<i class="fa-duotone fa-shield-check fa-4x fa-duotone-colors" style="float: right;"></i>

Not configured in this workshop

Multiple options

### GitLab with certificate file

Configure GitLab with key and certificate [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/omnibus/settings/ssl.html#other-certificate-authorities)

### GitLab with Let's Encrypt

Configure GitLab to use Let's Encrypt [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/omnibus/settings/ssl.html#lets-encrypt-integration)

### traefik with Let's Encrypt

Configure traefik to use Let's Encrypt with HTTP challenge [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://doc.traefik.io/traefik/user-guides/docker-compose/acme-http/)

Configure traefik to use Let's Encrypt with DNS challenge [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://doc.traefik.io/traefik/user-guides/docker-compose/acme-dns/)

---

## IDE

XXX Visual Studio Code Web http://vscode.seatN.inmylab.de

XXX Visual Studio Code Remote SSH https://code.visualstudio.com/docs/remote/ssh
