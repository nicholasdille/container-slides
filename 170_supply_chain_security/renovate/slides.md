## Motivation

![](170_supply_chain_security/renovate/dependencies_stability_features.drawio.svg) <!-- .element: style="float: right; width: 40%;" -->

Dependencies add reusable components

They increase productivity

Dependencies require updates
- New features
- Security fixes

Focus on new code

Dependency updates prevent this

What now? <i class="fa-duotone fa-face-thinking"></i>

---

## Dev dependencies

| Ecosystem        | Dependencies                           |
|:-----------------|:---------------------------------------|
| NodeJS           | `package.json`                         |
| Java (Maven)     | `pom.xml`                              |
| Java (Gradle)    | `build.gradle`                         |
| Go               | `go.mod`                               |
| Python           | `setup.py`                             |
| Python (peotry)  | `pyproject.toml`                       |
| Ruby             | `Gemfile`                              |
| Rust             | `Cargo.toml`                           |
| Docker           | `Dockerfile`, `[docker-]compose.ya?ml` |

...any many more!

---

## Ops dependencies

### The good...

| Ecosystem  | Dependencies                           |
|:-----------|:---------------------------------------|
| Docker     | `Dockerfile`, `[docker-]compose.ya?ml` |
| Kubernetes | `*.yaml`                               |
| Helm       | `Chart.yaml`                           |

...any many more!

### The bad...

Required tools, e.g. downloaded from GitHub releases

### And the ugly

Versions stored in variables in scripts

---

## Enter Software Bill of Materials

![](images/tenor-this-is-fine-gif-24177057.gif) <!-- .element: style="float: right; width: 40%;" -->

### Provides visibility

The world is on fire

### Auditing is the last resort

Update dependencies quickly

(Be prepared to) ship fast

Drive adoption of new versions

Know about remaining vulnerabilities

Check options for mitigation

---

## Outdated dependencies

All dependencies can and will introduce vulnerabilities

Younger version receive security updates

Updates can introduce breaking changes

Regular small updates over seldom large updates

### Manual updates...

...are too slow

...prevent other tasks

...are ignored until necessary

---
<!-- .slide: data-transition="fade" -->
### Demo

Check repository [](https://github.com/nicholasdille/clc23-renovate-demo)

Can you spot possible updates?

---
<!-- .slide: data-transition="fade" -->
### Demo

Check repository [](https://github.com/nicholasdille/clc23-renovate-demo)

Can you spot possible updates?

### Solution

Outdated GitHub actions without pinning

Base image without digest pinning

Outdated version variable

Outdated go.mod for hello world

Outdated requirements.txt for Python tools

---

## Automated dependency updates

### Enter Renovate

Open Source implemented in TypeScript [](https://github.com/renovatebot/renovate)

Commercial offering by Mend [](https://www.mend.io/renovate/)

### How it works

Clones repository and loads configuration

Searches in numerous places for dependencies

Proposes update in pull/merge requests

![](170_supply_chain_security/renovate/renovate.drawio.svg) <!-- .element: style="width: 60%; margin-top: 0.5em;" -->

---

## Renovate Features

**Platforms**: Azure DevOps (Server), BitBucket, AWS CodeCommit, Gitea/Forgjo, GitHub, GitLab

**Datasources**: crate, docker, git-tags, gitea-releases, github-releases, gitlab-releases, go, helm, maven, npm, nuget, pypi, rubygems (and dozens more)

Custom Managers for special use cases

**Deployment options**: GitHub App, Self-hosted

Powerful but complex

Initially many and/or breaking updates

Once settled in, smaller incremental updates

Merge Confidence [](https://docs.renovatebot.com/merge-confidence/) supports merge decisions for many languages

Integration with GitHub and Dependabot to show updates addressing security alerts [](https://docs.renovatebot.com/configuration-options/#vulnerabilityalerts)

---

## Demo

Add `renovate.json` for onboarding

Check dashboard [](https://developer.mend.io/github/nicholasdille/clc23-renovate-demo)

Check pull requests

Check release notes

Check workflows

---

## Automerge

Renovate can merge automatically

Requires opt-in through configuration

Requires successful automated tests

### How to automerge

Identify updates with low impact, e.g. patches, well-tested packages

Create package rules for automerging

### Demo

Add package rule for specific cases

Enable automerge for them

---

## Monitoring

XXX

---

## Custom Managers

Special use cases

Version must be injected into code, e.g.

```Dockerfile
FROM ubuntu:22.04

# renovate: datasource=github-releases depName=kubernetes/kubernetes extractVersion=^v(?<version>.+?)$
ARG KUBECTL_VERSION=1.28.2
RUN curl -sSfLO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
```

Use predefined custom manager [](https://docs.renovatebot.com/presets-regexManagers/#regexmanagersdockerfileversions)

Ships with regex to match comment above and configure Renovate

```json
{
    "$schema": "https://docs.renovatebot.com/renovate-schema.json",
    "extends": [
      ":dockerfileVersions"
    ],
}
```

---

## Alternatives

### Dependabot

Now owned by GitHub

Tightly integrated but can run without GitHub

Detailed comparison [](https://docs.renovatebot.com/bot-comparison/)

### Other tools lack...

...broad support for languages

...is integrated in a specific platform

---

## Case study: uniget

### Installer and updater for (container) tools

Checkout uniget.dev [](https://uniget.dev)

Offers 632 packages

Uses Renovate at scale

### 2022-06-13 -- 2023-11-15

over 5.700 merged PRs

~9 PRs per day

90% merged after ~1min

98% merged after ~6min

---

## Lessons learned

### GitHub Secondary API rate limits

Prevent excessive concurrency [](https://docs.github.com/en/rest/overview/rate-limits-for-the-rest-api?apiVersion=2022-11-28#about-secondary-rate-limits)

Mitigation: Custom implementation of automerge

### Custom managers will break

Name changes in GitHub release asset

Found 50 times in 10 months

### Stability issues of GitHub

Detector for GitHub glitches / outages

Acts as a status page for GitHub
