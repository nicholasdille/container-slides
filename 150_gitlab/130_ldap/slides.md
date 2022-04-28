<!-- .slide: class="vertical-center" -->

<i class="fa-duotone fa-book fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## LDAP

---

## LDAP

XXX

```bash
docker volume create openldap_data
docker volume create postgresql_data
docker volume create keycloak_data
```

XXX

```bash
docker compose --file ../100_reverse_proxy/compose.yml --file compose.yml up -d
```
