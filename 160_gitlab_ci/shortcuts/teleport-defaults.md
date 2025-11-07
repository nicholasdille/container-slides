<!-- .slide: id="gitlab_teleport_defaults" class="vertical-center" -->

<i class="fa-duotone fa-person-from-portal fa-8x" style="float: right; color: grey;"></i>

## Teleport: Defaults

---

## XXX

```bash
git checkout upstream/160_gitlab_ci/050_default -- '*'
```

<!-- .element: style="width: 35em; float: right;" -->

XXX

---

## Example App

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

XXX

XXX go.mod and go.sum

---

## Pipeline

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

<!-- .element: style="width: 49em; height: 32em; float: right;" -->

XXX
