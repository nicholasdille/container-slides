# Rollout of GitLab

## Prerequisites

Make sure your have rolled out the virtual machines in `../000_rollout`.

## Update nginx

Update links in `nginx/index.html` with correct date

## Start GitLab

```shell
bash bootstrap.sh
```

## Configure GitLab

Set new state name in `Makefile`

```Makefile
#...
STATE_NAME             := YYYYMMDD_gitlab
#...
```

Configure GitLab:

```shell
make apply
make personal_access_tokens.json
make runner_token.json
```
