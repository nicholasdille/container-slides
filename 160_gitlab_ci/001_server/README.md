# Rollout of GitLab

## Prerequisites

Make sure your have rolled out the virtual machines in `../000_rollout`.

## Start GitLab

```shell
bash bootstrap.sh
```

## Configure GitLab

```shell
make apply
make personal_access_tokens.json
make runner_token.json
```
