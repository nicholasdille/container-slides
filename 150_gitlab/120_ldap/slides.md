<!-- .slide: id="gitlab_ldap" class="vertical-center" -->

<i class="fa-duotone fa-book fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## LDAP Directories

---

## LDAP

<i class="fa-duotone fa-book fa-4x fa-duotone-colors" style="float: right;"></i>

GitLab can directly connect to LDAP servers [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/administration/auth/ldap/)

LDAP backend based on OpenLDAP [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://www.openldap.org/)

Management UI based on Keycloak [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://www.keycloak.org/)

![](150_gitlab/120_ldap/ldap.drawio.svg) <!-- .element: style="width: 90%;" -->

Group sync [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/administration/auth/ldap/ldap_synchronization.html#group-sync) only available in Premium

---

## Hands-On: Deployment

<i class="fa-duotone fa-book fa-4x fa-duotone-colors" style="float: right;"></i>

Prepare persistent volumes for new components:

```bash
docker volume create openldap_data
docker volume create postgresql_data
docker volume create keycloak_data
```

Deploy additional components:

```bash
# Switch to directory for this topics
cd ../120_ldap/

# Deploy components for LDAP
docker compose --project-name gitlab \
    --file ../100_reverse_proxy/compose.yml \
    --file compose.yml \
    up -d
```

---

## Hands-On: Configuration in Keycloak

<i class="fa-duotone fa-book fa-4x fa-duotone-colors" style="float: right;"></i>

Two users are automatically created:

- `user01:password1`
- `user02:password2`

Login using one these users

---

## Alternative: Single Sign-On

XXX https://docs.gitlab.com/ee/integration/saml.html
