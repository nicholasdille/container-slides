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

## Create credentials for attendees

```shell
SET_NAME=20250512 COUNT=21 bash generate.sh
```

## Rollout infrastructure

Provide credentials for infrastructure

```shell
$ cat .env.mk
HCLOUD_TOKEN := $(shell pp hcloud-web)
HETZNERDNS_TOKEN := $(shell pp hetzner-dns-web)
GIT_USERNAME := nicholasdille
GIT_PASSWORD := $(shell pp github-terraform-state)
```

Make sure that `GIT_PASSWORD` is still valid for `https://github.com/nicholasdille/terraform-state`.

Deploy infrastructure

```shell
make apply
```

## Bootstrap services

Checkout the next directories called `../00?_*` and follow the instructions

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
ssh gitlab env -C /root/container-slides/160_gitlab_ci/002_runner docker-compose ps -a
```

View instances of Visual Studio Code:

```shell
ssh vscode env -C /root/container-slides/160_gitlab_ci/003_vscode docker-compose ps -a --format "table {{.ID}}\t{{.Name}}\t{{.State}}"
```

Test DNS resolution:

```shell
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
seq 0 20 | xargs -I{} curl -sSI https://seat{}.vscode.inmylab.de
seq 0 20 | xargs -I{} curl -sSI https://code.inmylab.de/seat{}/
```

List runners:

```shell
curl -sSLfH "Private-Token: $(jq -r '.gitlab_admin_token' seats.json)" https://gitlab.inmylab.de/api/v4/runners/all?type=instance_type | jq .
```

Test authentication for code.inmylab.de:

```shell
seq 0 20 \
| while read -r INDEX; do
    CODE="$( jq -r --arg index ${INDEX} '.seats[$index | tonumber].code' seats.json )"
    AUTH="$( echo -n "seat${INDEX}:${CODE}" | base64 -w0 )"
    curl -sSIH "Authorization: Basic ${AUTH}" https://code.inmylab.de/seat${INDEX}/
done
```

Test authentication for vscode.inmylab.de:

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

Test webdav:

```shell
seq 0 20 | while read -r INDEX; do
    echo "seat${INDEX}"
    PASS_DEV="$( jq -r --arg index ${INDEX} '.seats[$index | tonumber].webdav_pass_dev' seats.json )"
    curl -sSIu "seat${INDEX}:${PASS_DEV}" https://seat${INDEX}.dev.webdav.inmylab.de
    PASS_LIVE="$( jq -r --arg index ${INDEX} '.seats[$index | tonumber].webdav_pass_live' seats.json )"
    curl -sSIu "seat${INDEX}:${PASS_LIVE}" https://seat${INDEX}.live.webdav.inmylab.de
done
```
