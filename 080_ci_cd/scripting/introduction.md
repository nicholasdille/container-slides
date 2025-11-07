```bash
#!/bin/bash
set -o errexit

test -n "${HC_IMG}" || local HC_IMG=ubuntu-24.04
test -n "${HC_LOC}" || local HC_LOC=fsn1
test -n "${HC_SSH_KEY}" || local HC_SSH_KEY=21771045
test -n "${HC_ID_FILE}" || local HC_ID_FILE=~/.ssh/id_ed25519

hcloud server create \
  --location "${HC_LOC}" --type cx22 --image "${HC_IMG}" \
  --name playground --ssh-key "${HC_SSH_KEY}"
HC_VM_IP="$(
  hcloud server list --output=json \
  | jq --raw-output \
    '.[] | select(.name == "playground") | .public_net.ipv4.ip'
)"

# Creating SSH config
cat >~/.ssh/config.d/playground-hcloud <<EOF
Host docker-hcloud hcloud ${HC_VM_IP}
    HostName ${HC_VM_IP}
    User root
    IdentityFile ${HC_ID_FILE}
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
EOF
```
<!-- .element: style="width: 40em; height: 31em; float: right; font-size: 0.5em;" -->

## Shell Code

Whatever you execute<br/>on the console...

...put in a file <!-- .element: style="padding-left: 3em;" -->

Executed manually...

...or automatically <!-- .element: style="padding-left: 3em;" -->

---

```yaml[8,16]
stages:
- build
- test

build:
  stage build
  image: golang
  script: go build -o myapp .
  artifacts:
    paths:
    - myapp

test:
  stage: test
  image: golang
  script: go test ./...
```
<!-- .element: style="width: 30em; height: 19em; float: right;" -->

## Also Shell Code

Declarative pipelines

Shell code is embedded into declaration

GitLab: `.gitlab-ci.yml`

Jenkins: `Jenkinsfile`

GitHub: `.github/workflows/`

`Makefile` and alternatives

---

```Dockerfile[5-7]
#syntax=docker/dockerfile:1
FROM ubuntu:24.04
RUN apt-get install -y curl jq
COPY <<EOF /usr/local/bin/myscript
#!/bin/bash
set -o errexit
curl -sf $1
EOF
ENTRYPOINT ["/usr/local/bin/myscript"]
CMD ["--help"]
```
<!-- .element: style="width: 30em; float: right;" -->

## Still Shell Code

Wrapped in a `Dockerfile`

Embedded or copied

Controlled runtime environment

Repeatable and reproducible

---

## Advantages

<i class="fa fa-solid fa-thumbs-up fa-4x"></i> <!-- .element: style="float: right;" -->

Always available

No libraries

Command line tools

Easy glue code

Script collection

---

## Disadvantages

<i class="fa fa-solid fa-thumbs-down fa-4x"></i> <!-- .element: style="float: right;" -->

Readability

Portability

Performance

Script collection