# Authenticate GitLab user and GitLab CI jobs against Kubernetes using GitLab OIDC

This demonstrates how to authenticate GitLab CI jobs against Kubernetes using GitLab OIDC

## Prerequisites

GitLab with...
- a group called `foo`
- a project called `bar` in group `foo`
- an application for group `foo`

`kubectl` is configured with [`kubelogin`](https://github.com/int128/kubelogin) to authenticate against GitLab

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
