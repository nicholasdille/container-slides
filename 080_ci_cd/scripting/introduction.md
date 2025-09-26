```bash
#!/bin/bash
set -o errexit

curl -sf http://example.com && echo yes || echo no

cat /var/log/syslog | grep -i error | xargs ..

1
2
3
4
```
<!-- .element: style="width: 30em; float: right;" -->

## Shell Code

Whatever you execute on the console...

...put in a file

Executed manually...

...or automatically

---

```yaml
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
<!-- .element: style="width: 30em; float: right;" -->

## Also Shell Code

Declarative pipelines

Shell code is embedded into declaration

GitLab: `.gitlab-ci.yml`

Jenkins: `Jenkinsfile`

GitHub: `.github/workflows/`

---

```Dockerfile
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

<i class="fa-duotone fa-solid fa-thumbs-up fa-4x"></i> <!-- .element: style="float: right;" -->

Always available

No libraries

Command line tools

Easy glue code

Script collection

---

## Disadvantages

<i class="fa-duotone fa-solid fa-thumbs-down fa-4x"></i> <!-- .element: style="float: right;" -->

Readability

Portability

Performance

Script collection