<!-- .slide: id="gitlab_renovate" class="vertical-center" -->

<i class="fa-duotone fa-paint-roller fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Renovate

---

## Renovate

Automated updates of dependencies [](https://www.whitesourcesoftware.com/free-developer-tools/renovate/) [<i class="fa-brands fa-github"></i>](https://github.com/renovatebot/renovate) [<i class="fa-solid fa-book"></i>](https://docs.renovatebot.com/)

Container image available [](https://hub.docker.com/r/renovate/renovate)

Not tightly integrated into GitLab

### Options

Pipeline-integrated optionally with official template [](https://gitlab.com/renovate-bot/renovate-runner)

Cron job running separate from GitLab instance

Self-hosted Renovate (formerly paid product) [](https://www.whitesourcesoftware.com/free-developer-tools/renovate/on-premises/)

---

## Hands-On

See chapter [Renovate](/hands-on/2023-11-30/270_renovate/exercise/)

(With proper configuration Renovate will automerge tested merge requests.)

---

## Pro tip: Use renovate:slim image

Image is smaller and loads faster

Tools are installed on-demand

Natively or using container sidecars

```yaml
renovate:
  image: renovate/renovate:slim
  script: |
    renovate --platform gitlab \
        --endpoint https://gitlab.inmylab.de/api/v4 \
        --token ${RENOVATE_TOKEN} \
        --autodiscover true
  #...
```

Request tools version using `constraints` [](https://docs.renovatebot.com/configuration-options/#constraints)

Or use tool specific directives like `engine` for npm [](https://docs.renovatebot.com/node/)
