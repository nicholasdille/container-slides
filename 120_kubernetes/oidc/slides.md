## Open ID Connect

![](120_kubernetes/oidc/oidc.drawio.svg) <!-- .element: style="float: right; width: 40%;" -->

Open ID Connect (OIDC) [](https://de.wikipedia.org/wiki/OpenID_Connect) builds on OAuth [](https://de.wikipedia.org/wiki/OAuth)

1. User authenticates with OIDC provider<br/>and receives token

2. User presents token to service

3. Service validates token<br/>and authorizes access

OIDC providers include: Keycloak [](https://github.com/keycloak/keycloak), Dex [](https://github.com/dexidp/dex#connectors), GitLab [](https://docs.gitlab.com/ee/integration/openid_connect_provider.html)

### Kubernetes [](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#openid-connect-tokens)

Use OIDC provider to authenticate

Authorize access to resources

---

## Internals

```json
{
  "iss": "https://gitlab.com",
  "sub": "REDACTED",
  "aud": "REDACTED",
  "exp": REDACTED,
  "iat": REDACTED,
  "nonce": "REDACTED",
  "auth_time": REDACTED,
  "sub_legacy": "REDACTED",
  "name": "Nicholas Dille",
  "nickname": "nicholasdille",
  "preferred_username": "nicholasdille",
  "website": "https://dille.name",
  "profile": "REDACTED",
  "picture": "REDACTED",
  "groups_direct": [
    "k8s-oidc-demo"
  ]
}
```

<!-- .element: style="float: right; font-size: smaller; width: 24em; padding-left: 1em;" -->

Token contains claims useful for authorization

Claims are generated from...
- LDAP groups
- GitLab groups

Token owner `preferred_username` is mapped to a Kubernetes `User`

Each claim from `groups_direct` is mapped to a Kubernetes `Group`

Use [kubelogin](https://github.com/int128/kubelogin) to avoid token in kubeconfig

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/oidc/oidc.demo "oidc.demo")
