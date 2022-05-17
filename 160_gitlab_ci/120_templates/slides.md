<!-- .slide: id="gitlab_templates" class="vertical-center" -->

<i class="fa-duotone fa-book-sparkles fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Templates

---

## Make jobs reusable

XXX include [](https://docs.gitlab.com/ee/ci/yaml/#include)

XXX local

XXX file

XXX remote

---

## Hands-On: Template and include

XXX

```yaml
.build-go:
  script:
  - |
    go build \
        -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X main.Author=${AUTHOR}" \
        -o hello \
        .
```

---

## Hands-On: Local

1. Add `go.yaml` to root of project
1. XXX

---

## Hands-On: File

1. XXX
