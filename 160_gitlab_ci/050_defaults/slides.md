<!-- .slide: id="gitlab_default" class="vertical-center" -->

<i class="fa-duotone fa-send-backward fa-8x fa-duotone-colors-inverted" style="float: right; color: grey;"></i>

## Defaults

---

## Defaults

Apply settings to all jobs using `default` [](https://docs.gitlab.com/ee/ci/yaml/#default)

`default` can contain...

- `image`
- `before_script`
- `after_script`
- and some more we will explore later <i class="fa-duotone fa-face-smile-halo fa-duotone-colors"></i>

### Hands-On

1. Add `default` for `image`
1. Remove `image` from all jobs
1. Check pipeline

(See new `.gitlab-ci.yml`)
