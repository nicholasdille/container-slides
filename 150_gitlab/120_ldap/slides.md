<!-- .slide: id="gitlab_ldap" class="vertical-center" -->

<i class="fa-duotone fa-book fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## LDAP

---

## LDAP

![](150_gitlab/120_ldap/ldap.drawio.svg) <!-- .element: style="width: 50%;" -->

Prepare persistent volumes for new components:

```bash
docker volume create openldap_data
docker volume create postgresql_data
docker volume create keycloak_data
```

Deploy additional components:

```bash
docker compose --project-name gitlab \
    --file ../100_reverse_proxy/compose.traefik.yml \
    --file ../100_reverse_proxy/compose.gitlab.yml \
    --file compose.yml \
    up -d
```

XXX configure
