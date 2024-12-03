<!-- .slide: id="gitlab_default" class="vertical-center" -->

<i class="fa-duotone fa-send-backward fa-8x fa-duotone-colors-inverted" style="float: right; color: grey;"></i>

## Defaults

---

## Defaults

Apply settings to all jobs using `default` [](https://docs.gitlab.com/ee/ci/yaml/#default), e.g.

- `image`
- `before_script`, `after_script`

...and some more we will explore later <i class="fa-duotone fa-face-smile-halo fa-duotone-colors"></i>

### Example

```yaml
default:
  image: alpine
  before_script: echo "Welcome to this job"
job_name:
  #...
```

### Hands-On

See chapter [Defaults](/hands-on/2024-11-21/050_defaults/exercise/)
