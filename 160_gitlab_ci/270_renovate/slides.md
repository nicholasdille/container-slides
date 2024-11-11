<!-- .slide: id="gitlab_renovate" class="vertical-center" -->

<i class="fa-duotone fa-paint-roller fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Renovate

---

## Supply Chain Security

*Supply chain* [](https://en.wikipedia.org/wiki/Software_supply_chain) - all libraries and tools used to develop, build and publish

*Supply chain security* [](https://en.wikipedia.org/wiki/Digital_supply_chain_security) - enhance the security within the supply chain

*Supply chain attack* - exploit of a vulnerability in the supply chain

### Your responsibilities

Make sure you are not part of the problem

Ship a secure product

Check where you get stuff from

### Your risk

Unable to solve supply chain security **recursively**

---

## Renovate

Automated updates of dependencies [](https://www.whitesourcesoftware.com/free-developer-tools/renovate/) [<i class="fa-brands fa-github"></i>](https://github.com/renovatebot/renovate) [<i class="fa-solid fa-book"></i>](https://docs.renovatebot.com/)

Container image available [](https://hub.docker.com/r/renovate/renovate)

No integration with GitLab

### Options

Pipeline job - optionally with official template [](https://gitlab.com/renovate-bot/renovate-runner)

Process running separate from GitLab instance

Self-hosted Renovate (formerly paid product) [](https://www.whitesourcesoftware.com/free-developer-tools/renovate/on-premises/)

### Hands-On

See chapter [Renovate](/hands-on/2024-11-12/270_renovate/exercise/)

---

## Pro tip: Automerge

Renovate can automatically merge updates

### Prerequisites

The merge request must have completed a pipeline successfully

The configuration must allow automerge

### Slow start

Do not enable automerge globally

Start with specific dependencies...

...or patchlevel updates

---

## Pro tip: Use slim image

Image is smaller and loads faster

Tools are not pre-installed...

...but installed on-demand...

...natively or using container sidecars

```yaml
renovate:
  image: renovate/renovate:slim
  script: |
    renovate --platform gitlab \
        --endpoint ${CI_API_V4_URL} \
        --token ${RENOVATE_TOKEN} \
        ${CI_PROJECT_PATH}
  #...
```

Request tools version using `constraints` [](https://docs.renovatebot.com/configuration-options/#constraints)

Or use tool specific directives like `engine` for npm [](https://docs.renovatebot.com/node/)
