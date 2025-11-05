<!-- .slide: id="gitlab_omnibus" class="vertical-center" -->

<i class="fa-duotone fa-signs-post fa-8x" style="float: right; color: grey;"></i>

## Installation and configuration

---

## GitLab Omnibus

Highly standardized [installation and configuration](https://docs.gitlab.com/omnibus/)

### Installation methods

Linux package

Helm Chart

Docker

### Identical configuration

[Template](https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/files/gitlab-config-template/gitlab.rb.template) for configuration file `gitlab.rb`

### Option 1: Docker

Pass environment variable `GITLAB_OMNIBUS_CONFIG` to container

### Option 2: Package manager

Edit `/etc/gitlab/gitlab.rb`

---

## Reverse Proxy in front of GitLab

<i class="fa-duotone fa-signs-post fa-4x" style="float: right;"></i>

Central service for...

- Request routing based on...
  - DNS name
  - path
- Optional TLS offloading based on DNS name

![](150_gitlab/100_reverse_proxy/reverse_proxy.drawio.svg) <!-- .element: style="width: 50%;" -->

Examples in this workshop use [`traefik`](https://traefik.io/traefik/)

`traefik` is configured using container labels

---

## Deployment

<i class="fa-duotone fa-signs-post fa-4x" style="float: right;"></i>

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

## TLS

<i class="fa-duotone fa-shield-check fa-4x" style="float: right;"></i>

Not configured in this workshop

Multiple options

### GitLab with certificate file <i class="fa-duotone fa-traffic-light-stop" style="--fa-secondary-color: red;"></i>

Configure GitLab with [TLS key and certificate](https://docs.gitlab.com/omnibus/settings/ssl.html#other-certificate-authorities)

### GitLab with Let's Encrypt <i class="fa-duotone fa-traffic-light-slow" style="--fa-secondary-color: yellow;"></i>

Configure GitLab to use [Let's Encrypt](https://docs.gitlab.com/omnibus/settings/ssl.html#lets-encrypt-integration)

### Reverse proxy with custom certificate <i class="fa-duotone fa-traffic-light-slow" style="--fa-secondary-color: yellow;"></i>

Configure traefik to use [custom certificate](https://doc.traefik.io/traefik/https/tls/#user-defined)

### Reverse proxy with Let's Encrypt <i class="fa-duotone fa-traffic-light-go" style="--fa-secondary-color: green;"></i>

Configure traefik to use [Let's Encrypt with DNS challenge](https://doc.traefik.io/traefik/user-guides/docker-compose/acme-dns/)

---

## Hands-On

### Only for Option 2: Package manager

Configure TLS manually by editing `/etc/gitlab/gitlab.rb` [](https://docs.gitlab.com/omnibus/settings/ssl/)

```ruby
# https://docs.gitlab.com/omnibus/settings/ssl/#configure-https-manually
external_url "https://gitlab.example.com"
letsencrypt['enable'] = false

# https://docs.gitlab.com/omnibus/settings/ssl/#change-the-default-ssl-certificate-location
nginx['ssl_certificate'] = "/etc/traefik/ssl/seat.crt"
nginx['ssl_certificate_key'] = "/etc/traefik/ssl/seat.key"
```

Then reconfigure GitLab:

```bash
gitlab-ctl reconfigure
```
