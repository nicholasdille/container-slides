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

## Hands-On: Pipeline-integrated [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/270_renovate "270_renovate")

1. Create personal access token with scopes `api`, `read_user`, `write_repository`
1. Add unprotected CI variable called `RENOVATE_TOKEN`
1. Add `renovate.json` to root of project
1. Add new job called `renovate`
1. Create schedule with non-empty variable `RENOVATE`
1. Check job logs
1. Check merge requests
1. Check pipelines
1. Merge at least one change

See new `.gitlab-ci.yml`:

```bash
git checkout 270_renovate -- '*'
```

(With proper configuration Renovate will automerge tested merge requests.)

---

## Pro tip: Use renovate:slim image

Image is smaller and loads faster

Tools are installed on-demand

Natively or using container sidecars

```yaml
renovate:
  image: renovate/renovate:32.236.0-slim
  script: |
    renovate --platform gitlab \
        --endpoint https://gitlab.seat${SEAT_INDEX}.inmylab.de/api/v4 \
        --token ${RENOVATE_TOKEN} \
        --autodiscover true
  #...
```

Request tools version using `constraints` [](https://docs.renovatebot.com/configuration-options/#constraints)

Or use tool specific directives like `engine` for npm [](https://docs.renovatebot.com/node/)
