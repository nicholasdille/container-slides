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

Your VM has the necessary environment variables:

- `DOMAIN`
- `IP`

---

## Starting fresh

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

### GitLab with certificate file

Configure GitLab with key and certificate [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/omnibus/settings/ssl.html#other-certificate-authorities)

### GitLab with Let's Encrypt

Configure GitLab to use Let's Encrypt [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/omnibus/settings/ssl.html#lets-encrypt-integration)

### traefik with Let's Encrypt

Configure traefik to use Let's Encrypt with HTTP challenge [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://doc.traefik.io/traefik/user-guides/docker-compose/acme-http/)

Configure traefik to use Let's Encrypt with DNS challenge [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://doc.traefik.io/traefik/user-guides/docker-compose/acme-dns/)

---

<i class="fa-duotone fa-display-code fa-4x fa-duotone-colors" style="float: right;"></i>

## Local IDE

Use local Visual Studio Code [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://code.visualstudio.com/) with Remote SSH plugin [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://code.visualstudio.com/docs/remote/ssh)

1. Create SSH connection: F1 -> Remote-SSH: Open SSH Configuration File
1. Select user file
1. Add host:

    ```
    Host seat
        HostName ${IP}
        User root
        StrictHostKeyChecking no
        UserKnownHostsFile /dev/null
    ```
1. Connect to host: F1 -> Remote-SSH: Connect to Host
1. Select host called `seat` and enter password

---

## Hosted IDE

Visual Studio Code Web [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://code.visualstudio.com/docs/editor/vscode-web) can be deployed as well

Add code-server [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://github.com/coder/code-server) to running instance:

```
docker compose --project-name gitlab \
    --file compose.yml \
    --file compose.vscode.yml \
    up -d
```

Accessible at http://vscode.seatN.inmylab.de

Retrieve password:

```
docker compose --project-name gitlab \
    --file compose.yml \
    --file compose.vscode.yml \
    exec vscode \
        cat /root/.config/code-server/config.yaml
```
