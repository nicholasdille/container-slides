# Authenticate GitLab user and GitLab CI jobs against Kubernetes using GitLab OIDC

This demonstrates how to authenticate GitLab CI jobs against Kubernetes using GitLab OIDC

## Prerequisites

GitLab with...
- a group called `foo`
- a project called `bar` in group `foo`
- an application for group `foo`

`kubectl` is configured with [`kubelogin`](https://github.com/int128/kubelogin) to authenticate against GitLab

## Example tokens

XXX

### User OIDC

XXX

```json
{
  "iss": "https://gitlab.example.com",
  "sub": "2",
  "aud": "REDACTED",
  "exp": 0,
  "iat": 0,
  "nonce": "REDACTED",
  "auth_time": 0,
  "sub_legacy": "REDACTED",
  "name": "MyUserName",
  "nickname": "MyUserNAme",
  "preferred_username": "MyUserName",
  "profile": "https://gitlab.example.com/MyUserName",
  "picture": "https://gitlab.example.com/uploads/-/system/user/avatar/2/avatar.png",
  "groups_direct": [
    "foo"
  ]
}
```

### Pipeline OIDC

XXX

```json
{
  "namespace_id": "2",
  "namespace_path": "foo",
  "project_id": "13",
  "project_path": "foo/bar",
  "user_id": "2",
  "user_login": "MyUserName",
  "user_email": "username@example.com",
  "user_access_level": "owner",
  "pipeline_id": "123",
  "pipeline_source": "push",
  "job_id": "234",
  "ref": "main",
  "ref_type": "branch",
  "ref_path": "refs/heads/main",
  "ref_protected": "true",
  "runner_id": 1,
  "runner_environment": "self-hosted",
  "sha": "0fffdd6505a3f5f573e34338cb9eac1211bace14",
  "project_visibility": "internal",
  "ci_config_ref_uri": "gitlab.example.com/foo/bar//.gitlab-ci.yml@refs/heads/main",
  "ci_config_sha": "0fffdd6505a3f5f573e34338cb9eac1211bace14",
  "jti": "979f6254-c7ce-4632-be39-1b65163792b8",
  "iat": 0,
  "nbf": 0,
  "exp": 0,
  "iss": "https://gitlab.example.com",
  "sub": "project_path:foo/bar:ref_type:branch:ref:main",
  "aud": "REDACTED"
}
```

## References

XXX https://kubernetes.io/docs/reference/access-authn-authz/authentication/#using-authentication-configuration

XXX https://cel.dev/

XXX https://docs.gitlab.com/ee/integration/openid_connect_provider.html

XXX https://docs.gitlab.com/ee/ci/yaml/#id_tokens

XXX https://docs.gitlab.com/ee/ci/secrets/id_token_authentication.html

## Prepare

Deploy a Kubernetes cluster with authentication configuration from `auth-config.yaml`:

```shell
kind create cluster \
    --name gitlab-ci-oidc \
    --config kind.yaml \
    --wait 5m
```

Apply RBAC

```shell
kubectl apply -f rbac.yaml
```

## GitLab CI

Deploy GitLab runner

```shell
helm repo add gitlab https://charts.gitlab.io
helm repo update
helm upgrade --install \
    gitlab-runner gitlab/gitlab-runner \
    --values values-gitlab-runner.yaml \
    --set runnerRegistrationToken=TOKEN \
    --wait \
    --timeout 5m
```

Test pipeline based on `.gitlab-ci.yml`

## Test `kubectl`

Test RBAC without OIDC

```shell
kubectl get pods --as gitlab:MyUserName --as-group gitlab:foo -A
kubectl get pods --as gitlab-ci:project_path:foo/bar:ref_type:branch:ref:main -A
```

Test with RBAC

```shell
kubectl --user=gitlab-oidc get pods
```
