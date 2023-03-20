<!-- .slide: id="gitlab_omnibus" class="vertical-center" -->

<i class="fa-duotone fa-signs-post fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Installation and configuration

---

## GitLab Omnibus

Highly standardized installation and configuration [](https://docs.gitlab.com/omnibus/)

### Installation methods

Linux package

Helm Chart

Docker

### Identical configuration

Template [](https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/files/gitlab-config-template/gitlab.rb.template)

---

## Reverse Proxy in front of GitLab

<i class="fa-duotone fa-signs-post fa-4x fa-duotone-colors" style="float: right;"></i>

Central service for...

- Request routing
- SSL offloading

Examples in this workshop use [`traefik`](https://traefik.io/traefik/)

`traefik` is configured using container labels

---

## Deployment

<i class="fa-duotone fa-signs-post fa-4x fa-duotone-colors" style="float: right;"></i>

Services are reachable by...

- `NAME.seatN.inmylab.de`
- `NAME.IP.nip.io` (fallback)

Deploy using `docker compose` v2:

```
docker rm -f gitlab
docker compose --project-name gitlab up -d
```

Your VM has the necessary environment variables: `DOMAIN` and `IP`

Extract password:

```bash
docker compose --project-name gitlab exec gitlab
    cat /etc/gitlab/initial_root_password \
    | grep ^Password | cut -d' ' -f2
```

---

## Starting fresh (just in case)

Stop running instance:

```
docker compose --project-name gitlab down
```

Purge data by removing volumes:

```
docker volume rm gitlab_config
docker volume rm gitlab_logs
docker volume rm gitlab_data
```

A fresh instance has a new initial root password

```
docker exec -it gitlab cat /etc/gitlab/initial_root_password \
| grep ^Password \
| cut -d' ' -f2
```

---

## TLS

<i class="fa-duotone fa-shield-check fa-4x fa-duotone-colors" style="float: right;"></i>

Not configured in this workshop

Multiple options

### GitLab with certificate file <i class="fa-duotone fa-traffic-light-stop" style="--fa-secondary-color: red;"></i>

Configure GitLab with key and certificate [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/omnibus/settings/ssl.html#other-certificate-authorities)

### GitLab with Let's Encrypt <i class="fa-duotone fa-traffic-light-slow" style="--fa-secondary-color: yellow;"></i>

Configure GitLab to use Let's Encrypt [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/omnibus/settings/ssl.html#lets-encrypt-integration)

### traefik with Let's Encrypt <i class="fa-duotone fa-traffic-light-go" style="--fa-secondary-color: green;"></i>

Configure traefik to use Let's Encrypt with HTTP challenge [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://doc.traefik.io/traefik/user-guides/docker-compose/acme-http/)

Configure traefik to use Let's Encrypt with DNS challenge [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://doc.traefik.io/traefik/user-guides/docker-compose/acme-dns/)
