<!-- .slide: id="gitlab_ldap" class="vertical-center" -->

<i class="fa-duotone fa-book fa-8x" style="float: right; color: grey;"></i>

## LDAP Directories

---

## LDAP

<i class="fa-duotone fa-book fa-4x" style="float: right;"></i>

GitLab can directly connect to [LDAP servers](https://docs.gitlab.com/ee/administration/auth/ldap/)
- Create internal users for authenticated users
- Sync [LDAP groups to GitLab groups](https://docs.gitlab.com/ee/administration/auth/ldap/ldap_synchronization.html#group-sync) (requires Premium)

### Example setup

LDAP backend based on [OpenLDAP](https://www.openldap.org/)

Management UI based on [Keycloak](https://www.keycloak.org/)

![](150_gitlab/120_ldap/ldap.drawio.svg) <!-- .element: style="width: 90%;" -->

---

<!-- .slide: data-visibility="hidden" -->

## Hands-On: Deployment

<i class="fa-duotone fa-book fa-4x" style="float: right;"></i>

Prepare persistent volumes for new components:

```bash
docker volume create openldap_data
docker volume create postgresql_data
docker volume create keycloak_data
```

Deploy additional components:

```bash
# Deploy components for LDAP
cd ../120_ldap/
docker compose --project-name gitlab \
    --file ../100_reverse_proxy/compose.yml \
    --file compose.yml \
    up -d
```

---

<!-- .slide: data-visibility="hidden" -->

## Hands-On: Configuration in Keycloak

<i class="fa-duotone fa-book fa-4x" style="float: right;"></i>

Two users are automatically created:

- `user01:password1`
- `user02:password2`

Login using one these users

---

## Alternative: Single Sign-On

GitLab can use an [SAML Identity Provider](https://docs.gitlab.com/ee/integration/saml.html) to authenticate users

```ruby
gitlab_rails['omniauth_enabled'] = true
gitlab_rails['omniauth_allow_single_sign_on'] = ['saml']
gitlab_rails['omniauth_block_auto_created_users'] = false
gitlab_rails['omniauth_auto_link_saml_user'] = true
gitlab_rails['omniauth_providers'] = [{
  name: "saml",
  label: "my-label",
  args: {
    assertion_consumer_service_url: "https://gitlab.seatN.inmylab.de/users/auth/saml/callback",
    idp_cert_fingerprint: "<FINGERPRINT>",
    idp_sso_target_url: "https://login.foo.com/bar",
    issuer: "MyIssuer",
    name_identifier_format: "urn:oasis:names:tc:SAML:2.0:nameid-format:persistent",
    attribute_statements: { name: ['name'], first_name: ['first_name'], last_name: ['last_name'], nickname: ['username'] }
    }
}]
```

<!-- .element: style="height: 20em;" -->

---

## Single Sign-On on the console 1/2

<i class="fa-duotone fa-wand-magic-sparkles fa-4x" style="float: right;"></i>

Never configure credentials ever again

### GitLab CLI

Official GitLab CLI `glab` [](https://gitlab.com/gitlab-org/cli/)

Configuration is documented for cloud and self-hosted [](https://gitlab.com/gitlab-org/cli/#authentication)

---

## Single Sign-On on the console 2/2

<i class="fa-duotone fa-wand-magic-sparkles fa-4x" style="float: right;"></i>

Never configure credentials ever again

### Git

1. In GitLab, create a global application:
    - Callback: `http://127.0.0.1`
    - Trusted: `yes`
    - Confidential: `no`
    - Scopes: `read_repository`, `write_repository`

1. On your client, install `git-credential-oauth` [](https://github.com/hickford/git-credential-oauth) and update `~/.gitconfig`:

```
[credential "https://gitlab.example.com"]
    oauthclientId = "<APP_ID>"
    oauthScopes = "read_repository write_repository"
    oauthAuthURL = /oauth/authorize
    oauthTokenURL = /oauth/token
    oauthDeviceAuthURL = /oauth/authorize_device
```
