<i class="fa-duotone fa-solid fa-hand-holding-skull fa-4x"></i> <!-- .element: style="float: right;" -->

## Bonus: One ring to rule them all

### Single sign-on with OpenID Connect (OIDC)

---

## OIDC with kubectl

![](120_kubernetes/oidc/oidc.drawio.svg) <!-- .element: style="float: right; width: 40%;" -->

Open ID Connect (OIDC) [](https://de.wikipedia.org/wiki/OpenID_Connect) builds on OAuth [](https://de.wikipedia.org/wiki/OAuth)

1. User is redirected from app to IdP

1. User authenticates and receives token

1. User is redirected back to app

1. User presents token to service

3. Service validates token and authorizes access

### Kubernetes

Official documentation [](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#openid-connect-tokens)

Use `kubectl` plugin `kubelogin` [](https://github.com/int128/kubelogin) to authenticate

Authorize access to resources using RBAC

---

## Sidenote: OIDC everywhere

No more password prompts!

No more explicit credentials!

No more token expiry!

### Client Tools

Kubernetes: `kubelogin` [](https://github.com/int128/kubelogin)

Git: `git-credential-oauth` [](https://github.com/hickford/git-credential-oauth)

Git commit signature: `gitsign` [](https://github.com/sigstore/gitsign)

GitLab: `glab` [](https://gitlab.com/gitlab-org/cli)

GitHub: `gh` [](https://github.com/cli/cli)