# Authenticate GitLab CI jobs against Kubernetes using GitLab OIDC

XXX

## Prepare

Deploy a Kubernetes cluster with authentication configuration from `auth-config.yaml`:

```shell
kind create cluster \
    --name gitlab-ci-oidc \
    --config kind.yaml \
    --wait 5m
```

Deploy GitLab runner:

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