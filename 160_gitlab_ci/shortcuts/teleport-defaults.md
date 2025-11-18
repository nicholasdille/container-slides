<!-- .slide: id="gitlab_teleport_defaults" class="vertical-center" -->

<i class="fa-duotone fa-person-from-portal fa-8x" style="float: right; color: grey;"></i>

## Teleport: Defaults

---

## Teleport: Defaults

Skip basic chapters

Save time for important chapters

### What you need to know

How to get there

Example app

Pipeline

Review variables

Pro tips

---

```bash
git checkout upstream/160_gitlab_ci/050_default -- '*'
```

<!-- .element: style="width: 35em; float: right;" -->

## How to get there

Fetch sources from a git tag

---

```go
package main

import (
	"fmt"
	"github.com/TwiN/go-color"
)

var Author string = "unknown"
var Version string = "none"

func main() {
	println(color.InGreen("hello world"))
	fmt.Printf("by %s, version %s", Author, Version)
}
```

<!-- .element: style="width: 35em; height: 17em; float: right;" -->

## Example App

Written in Go

Dependencies in `go.mod`

Lock file is `go.sum`

---

```yaml
stages:
- check
- build

default:
  image: golang:1.25.3

lint:
  stage: check
  script:
  - go fmt .

audit:
  stage: check
  script:
  - go vet .

build:
  stage: build
  script:
  - |
    go build \
      -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'" \
      -o hello \
      .
  - ./hello
```

<!-- .element: style="width: 52em; height: 32em; float: right;" -->

## Pipeline

2 stages with 3 jobs:
- check
    - lint
    - audit
- build
    - build
    
Script field defines commands

Default image is used for all jobs

---

## Review

### Variables

Can be created per pipeline and per job:

```yaml
variables:
  FOO: bar

job_name:
  variables:
    FOO: baz
  script: printenv | sort  
```

## Pro tips

Go back to skipped chapters and checkout pro tips:

[Jobs and stages](#/gitlab_jobs) - [Variables](#/gitlab_variables) - [Script blocks](#/gitlab_script_blocks) - [Images](#/gitlab_image) - [Defaults](#/gitlab_default)
