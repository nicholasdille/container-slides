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

### Alternative

Community container image [](https://github.com/sameersbn/docker-gitlab)

---

## Reverse Proxy in front of GitLab

<i class="fa-duotone fa-signs-post fa-4x fa-duotone-colors" style="float: right;"></i>

Central service for...

- Request routing based on...
  - DNS name
  - path
- TLS offloading based on DNS name

![](150_gitlab/100_reverse_proxy/reverse_proxy.drawio.svg) <!-- .element: style="width: 50%;" -->

Examples in this workshop use [`traefik`](https://traefik.io/traefik/)

`traefik` is configured using container labels

---

## Deployment

<i class="fa-duotone fa-signs-post fa-4x fa-duotone-colors" style="float: right;"></i>

Deploy using Docker Compose:

```
# Go to repository with slides and demos
cd container-slides/150_gitlab/100_reverse_proxy
git pull

# Remove existing instance of GitLab
docker rm -f gitlab

# Deploy new instance
docker compose --project-name gitlab up -d
```

Your VM has the necessary environment variables: `DOMAIN` and `IP`

Extract password (or [reset](#/gitlab_troubleshooting)):

```bash
docker compose --project-name gitlab exec gitlab \
    cat /etc/gitlab/initial_root_password \
    | grep ^Password | cut -d' ' -f2
```

--

## Deployment - Helper commands

Check the state of the whole stack:

```bash
docker compose --project-name gitlab ps -a
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
docker volume create gitlab_config
docker volume create gitlab_logs
docker volume create gitlab_data
```

A fresh instance has a new initial root password

---

## TLS

<i class="fa-duotone fa-shield-check fa-4x fa-duotone-colors" style="float: right;"></i>

Not configured in this workshop

Multiple options

### GitLab with certificate file <i class="fa-duotone fa-traffic-light-stop" style="--fa-secondary-color: red;"></i>

Configure GitLab with key and certificate [](https://docs.gitlab.com/omnibus/settings/ssl.html#other-certificate-authorities)

### GitLab with Let's Encrypt <i class="fa-duotone fa-traffic-light-slow" style="--fa-secondary-color: yellow;"></i>

Configure GitLab to use Let's Encrypt [](https://docs.gitlab.com/omnibus/settings/ssl.html#lets-encrypt-integration)

### Reverse proxy with custom certificate <i class="fa-duotone fa-traffic-light-slow" style="--fa-secondary-color: yellow;"></i>

Configure traefik to use custom certificate [](https://doc.traefik.io/traefik/https/tls/#user-defined)

### Reverse proxy with Let's Encrypt <i class="fa-duotone fa-traffic-light-go" style="--fa-secondary-color: green;"></i>

Configure traefik to use Let's Encrypt with DNS challenge [](https://doc.traefik.io/traefik/user-guides/docker-compose/acme-dns/)