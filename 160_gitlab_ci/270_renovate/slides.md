<!-- .slide: id="gitlab_renovate" class="vertical-center" -->

<i class="fa-duotone fa-paint-roller fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Renovate

---

## Renovate

Automated updates of dependencies [](https://www.whitesourcesoftware.com/free-developer-tools/renovate/) [<i class="fa-brands fa-github"></i>](https://github.com/renovatebot/renovate) [<i class="fa-solid fa-book"></i>](https://docs.renovatebot.com/)

Not integrated into GitLab

### Options

Pipeline-integrated optionally with official template [](https://gitlab.com/renovate-bot/renovate-runner)

Cron job running separate from GitLab instance

Self-hosted Renovate (formerly paid product) [](https://www.whitesourcesoftware.com/free-developer-tools/renovate/on-premises/)

---

## Hands-On: Pipeline-integrated

1. Create personal access token and add unprotected CI variables called `RENOVATE_TOKEN`
1. Add `renovate.json` to root of project
1. Add new job called `renovate`
1. Create schedule with non-empty variable `RENOVATE`
1. Check job logs
1. Check merge requests
1. Check pipelines
1. Merge at least one change

(See new `gitlab-ci.yml`)

(With proper configuration Renovate can also automerge tested merge requests.)
