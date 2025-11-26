# Rollout of 160_gitlab_ci

## Preparation

1. Set a timestamp for the event (`YYYY-mm-dd`)
1. Update links to slides using regex `/slides/\d{4}-\d{2}-\d{2}/`
1. Update links from slides to exercises using regex `/hands-on/\d{4}-\d{2}-\d{2}/`
1. Update syntax definitions for `Dockerfile` using regex: `docker/dockerfile:\d+.\d+.\d+` (https://hub.docker.com/r/docker/dockerfile)
1. Update nginx using regex: `nginx:\d+.\d+.\d+` (https://hub.docker.com/_/nginx)
1. Update traefik using regex: `traefik:v\d+.\d+.\d+` (https://hub.docker.com/_/traefik)
1. Update GitLab using regex: `gitlab/gitlab-ce:\d+.\d+.\d+-ce.0` (https://about.gitlab.com/releases/categories/releases/)
1. Update GitLab Runner using regex: `gitlab/gitlab-runner:v\d+.\d+.\d+` (https://gitlab.com/gitlab-org/gitlab-runner/-/releases)
1. Update Kroki using regex: `yuzutech/kroki:\d+.\d+.\d+` (https://hub.docker.com/r/yuzutech/kroki)
1. Update Kroki Mermaid using regex: `yuzutech/kroki-mermaid:\d+.\d+.\d+` (https://hub.docker.com/r/yuzutech/kroki-mermaid)
1. Update Kroki BPMN using regex: `yuzutech/kroki-bpmn:\d+.\d+.\d+` (https://hub.docker.com/r/yuzutech/kroki-bpmn)
1. Update Kroki Excalidraw using regex: `yuzutech/kroki-excalidraw:\d+.\d+.\d+` (https://hub.docker.com/r/yuzutech/kroki-excalidraw)
1. Update code-server using regex: `codercom/code-server:\d+.\d+.\d+` (https://hub.docker.com/r/codercom/code-server)
1. Update golang using regex: `golang:\d+.\d+.\d+` (https://hub.docker.com/_/golang/)
1. Update curl using regex: `curlimages/curl:\d+.\d+.\d+` (https://hub.docker.com/r/curlimages/curl)
1. Update docker using regex: `docker:\d+.\d+.\d+(-dind)?` with replacement `docker:29.0.4$1`
1. Update ubuntu using regex: `ubuntu:\d+.\d+`
1. Update grafana using regex: `grafana/grafana:\d+.\d+.\d+` (https://hub.docker.com/r/grafana/grafana)
1. Update release-cli using regex: `registry.gitlab.com/gitlab-org/cli:v\d+\.\d+\.\d+` (https://gitlab.com/gitlab-org/cli/-/releases)
1. Update versions in `160_gitlab_ci/000_rollout/gitlab.pkr.hcl` for pre-pulling container images
1. Run `scripts/update_code_branches.sh` to update code branches

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

## Create credentials for attendees

```shell
SET_NAME=YYYYMMDD COUNT=MAX bash generate.sh
```

Store `seats.json` in a password manager

## Rollout infrastructure

Provide credentials for infrastructure

```shell
$ cat .env.mk
HCLOUD_TOKEN := $(shell pp hcloud-web)
HCLOUD_DNS_TOKEN := $(shell pp hcloud-dns-web)
GIT_USERNAME := nicholasdille
GIT_PASSWORD := $(shell pp github-terraform-state)
```

Make sure that `GIT_PASSWORD` is still valid for `https://github.com/nicholasdille/terraform-state`.

Set new state name in `Makefile`

```Makefile
#...
STATE_NAME             := YYYYMMDD
#...
```

Deploy infrastructure

```shell
make apply
```

Store the SSH config in a password manager

Wait for DNS to converge:

```bash
for NAME in traefik gitlab code grafana vscode; do
    while ! nslookup "${NAME}.inmylab.de" >/dev/null; do
        echo "Waiting 5s for ${NAME}.inmylab.de..."
        sleep 5
    done
done
```

## Bootstrap services

Checkout the next directories called `../00?_*` and follow the instructions in `README.md`

## Check containers

One-shot connection to remote Docker daemons:

```shell
docker -H ssh://gitlab ps
docker -H ssh://runner ps
docker -H ssh://vscode ps
```

Create Docker contexts:

```shell
docker context create gitlab --docker "host=ssh://gitlab"
docker context create runner --docker "host=ssh://runner"
docker context create vscode --docker "host=ssh://vscode"
```

Use contexts:

```shell
docker --context=gitlab ps
docker --context=runner ps
docker --context=vscode ps
```

## Create entries in password manager

The following entries should be created:

- `Code` for `https://code.inmylab.de`
- `GitLab` for `https://gitlab.inmylab.de` for user `root` and user `seat0`
- `GitLab PAT` for user `root` and user `seat0`
- `VSCode` for `https://vscode.inmylab.de` for user `seat0`
- `Grafana` for `https://grafana.inmylab.de` for user `admin` and GitLab root password

## Testing

View GitLab:

```shell
ssh gitlab env -C /root/container-slides/160_gitlab_ci/001_server docker-compose ps -a
```

View GitLab Runner:

```shell
ssh runner env -C /root/container-slides/160_gitlab_ci/002_runner docker-compose ps -a
```

View instances of Visual Studio Code:

```shell
ssh vscode env -C /root/container-slides/160_gitlab_ci/003_vscode docker-compose ps -a --format "table {{.ID}}\t{{.Name}}\t{{.State}}"
```

Test DNS resolution:

```shell
dig +short traefik.inmylab.de
dig +short code.inmylab.de
dig +short gitlab.inmylab.de
dig +short vscode.inmylab.de
dig +short grafana.inmylab.de
```

Test endpoints:

```shell
curl -sSI https://code.inmylab.de/
curl -sSI https://gitlab.inmylab.de/
curl -sSI https://grafana.inmylab.de/
seq 0 20 | xargs -I{} curl -sSI https://code.inmylab.de/seat{}/
seq 0 20 | xargs -I{} curl -sSI https://seat{}.vscode.inmylab.de
```

List runners:

```shell
curl -sSLfH "Private-Token: $(jq -r '.gitlab_admin_token' seats.json)" https://gitlab.inmylab.de/api/v4/runners/all?type=instance_type | jq .
```

Test authentication for code.inmylab.de and expect HTTP/200 after successful authentication:

```shell
seq 0 20 \
| while read -r INDEX; do
    CODE="$( jq -r --arg index ${INDEX} '.seats[$index | tonumber].code' seats.json )"
    AUTH="$( echo -n "seat${INDEX}:${CODE}" | base64 -w0 )"
    curl -sSIH "Authorization: Basic ${AUTH}" https://code.inmylab.de/seat${INDEX}/
done
```

Test authentication for vscode.inmylab.de and expect HTTP/302 after successful authentication:

```shell
seq 0 20 \
| while read -r INDEX; do
    PASS="$( jq -r --arg index ${INDEX} '.seats[$index | tonumber].password' seats.json )"
    AUTH="$( echo -n "seat${INDEX}:${PASS}" | base64 -w0 )"
    curl -sSIH "Authorization: Basic ${AUTH}" https://seat${INDEX}.vscode.inmylab.de/
done
```

Test PAT for gitlab.inmylab.de:

```shell
seq 0 20 | while read -r INDEX; do
    PAT="$( jq -r --arg index ${INDEX} '.[$index | tonumber]' ../001_server/personal_access_tokens.json )"
    curl -sSH "Private-Token: ${PAT}" https://gitlab.inmylab.de/api/v4/user \
    | jq -r .username
done
```

Block all users:

```shell
seq 0 20 | while read -r INDEX; do
    PAT="$( jq -r '.gitlab_admin_token' seats.json )"
    USER_ID="$( curl -sSH "Private-Token: ${PAT}" https://gitlab.inmylab.de/api/v4/users?username=seat${INDEX} | jq -r .[0].id )"
    curl -sSH "Private-Token: ${PAT}" -X POST https://gitlab.inmylab.de/api/v4/users/${USER_ID}/block
done
```

Unblock all users:

```shell
seq 0 20 | while read -r INDEX; do
    PAT="$( jq -r '.gitlab_admin_token' seats.json )"
    USER_ID="$( curl -sSH "Private-Token: ${PAT}" https://gitlab.inmylab.de/api/v4/users?username=seat${INDEX} | jq -r .[0].id )"
    curl -sSH "Private-Token: ${PAT}" -X POST https://gitlab.inmylab.de/api/v4/users/${USER_ID}/unblock
done
```

Fetch last activity:

```shell
seq 0 20 | while read -r INDEX; do
    echo "seat${INDEX}"
    PAT="$( jq -r '.gitlab_admin_token' seats.json )"
    USER_ID="$( curl -sSH "Private-Token: ${PAT}" https://gitlab.inmylab.de/api/v4/users?username=seat${INDEX} | jq -r .[0].id )"
    curl -sSH "Private-Token: ${PAT}" https://gitlab.inmylab.de/api/v4/users/${USER_ID} \
    | jq -r '"  last_sign_in_at: \(.last_sign_in_at)\n  last_activity_on: \(.last_activity_on)\n  sign_in_count: \(.sign_in_count)"'
done
```

Test webdav and expect HTTP/404 after successful authentication:

```shell
seq 0 20 | while read -r INDEX; do
    echo "seat${INDEX}"
    PASS_DEV="$( jq -r --arg index ${INDEX} '.seats[$index | tonumber].webdav_pass_dev' seats.json )"
    curl -sSIu "seat${INDEX}:${PASS_DEV}" https://seat${INDEX}.dev.webdav.inmylab.de
    PASS_LIVE="$( jq -r --arg index ${INDEX} '.seats[$index | tonumber].webdav_pass_live' seats.json )"
    curl -sSIu "seat${INDEX}:${PASS_LIVE}" https://seat${INDEX}.live.webdav.inmylab.de
done
```
