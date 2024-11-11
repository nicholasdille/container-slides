# Rollout of 160_gitlab_ci

## Prerequisites

```shell
uniget install \
    packer \
    terraform \
    terraform-backend-git
```

## Create images

```shell
make uniget
make docker
make gitlab
```

## Rollout infrastructure

```shell
make apply
```

## Bootstrap services

```shell
bash bootstrap.sh
```
