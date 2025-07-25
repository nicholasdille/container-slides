<!-- .slide: id="gitlab_renovate" class="vertical-center" -->

<i class="fa-duotone fa-paint-roller fa-8x" style="float: right; color: grey;"></i>

## Renovate

---

## Supply Chain Security

[*Supply chain*](https://en.wikipedia.org/wiki/Software_supply_chain) - all libraries and tools used to develop, build and publish

[*Supply chain security*](https://en.wikipedia.org/wiki/Digital_supply_chain_security) - enhance the security within the supply chain

*Supply chain attack* - exploit of a vulnerability in the supply chain

### Your responsibilities

Make sure you are not part of the problem

Ship a secure product

Check where you get stuff from

### Your risk

Unable to solve supply chain security **recursively**

---

## Renovate

Automated [updates of dependencies](https://www.whitesourcesoftware.com/free-developer-tools/renovate/) [<i class="fa-brands fa-github"></i>](https://github.com/renovatebot/renovate) [<i class="fa-solid fa-book"></i>](https://docs.renovatebot.com/)

Support for numerous languages and package managers

Updates are proposed using merge requests

You are in control what gets merged

### Deployment options

[Container image](https://hub.docker.com/r/renovate/renovate) available

No integration with GitLab

1. Pipeline job - optionally with [official template](https://gitlab.com/renovate-bot/renovate-runner)
1. Process running separate from GitLab instance
1. [Self-hosted](https://www.whitesourcesoftware.com/free-developer-tools/renovate/on-premises/) Renovate (formerly paid product)

---

## Hands-On

See chapter [Renovate](/hands-on/2025-05-14/270_renovate/exercise/)

---

## Pro tip 1: Automerge

Renovate can automatically merge updates

### Prerequisites

The merge request must have completed a pipeline successfully

The configuration must allow automerge

### Slow start

Do not enable automerge globally

Start with specific dependencies...

...or patchlevel updates

---

## Pro tip 2: Avoid forward triggers

GitLab only supports forward triggers [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_triggers)

Hard to manage dependencies

Renovate help decouple pipelines
- Upstream pipeline creates new artifact
- Downstream pipeline is updated by Renovate
- Merge triggers the downstream pipeline
