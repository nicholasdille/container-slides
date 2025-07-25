<!-- .slide: id="gitlab_integrations" class="vertical-center" -->

<i class="fa-duotone fa-handshake fa-8x" style="float: right; color: grey;"></i>

## Integrations

---

## Advanced Search

<i class="fa-duotone fa-magnifying-glass-dollar fa-4x" style="float: right;"></i>

[Full-text search](https://docs.gitlab.com/ee/integration/elasticsearch.html) across the instance using ElasticSearch

Requires a premium license

Uses open-source project internally [for indexing](https://gitlab.com/gitlab-org/gitlab-elasticsearch-indexer)

---

## Gitpod

<i class="fa-duotone fa-browser fa-4x" style="float: right;"></i>

Run full [web-based IDE](https://docs.gitlab.com/ee/integration/gitpod.html) using [Gitpod](https://www.gitpod.io/)

Uses [web-based Visual Studio Code](https://vscode.dev/)

Free tier of cloud service requires public repositories

![](150_gitlab/135_integrations/gitpod.drawio.svg) <!-- .element: style="width: 50%;" -->

Self-hosted deployment requires Kubernetes

### Alternatives

[Web IDE](https://docs.gitlab.com/ee/user/project/web_ide/) is available in GitLab CE but lacks terminal

Interactive [web terminal](https://docs.gitlab.com/ee/ci/interactive_web_terminal/) opens shell in running CI job

---

## Diagrams

<i class="fa-duotone fa-diagram-project fa-4x" style="float: right;"></i>

Render [diagrams from textual descriptions](https://docs.gitlab.com/ee/administration/integration/kroki.html) using [Kroki](https://kroki.io/)

### Hands-On

Deploy in addition to GitLab:

```bash
# Deploy kroki
cd ../135_integrations
docker compose --project-name gitlab \
    --file ../100_reverse_proxy/compose.yml \
    --file compose.yml \
    up -d
```

Enable Kroki in web UI (Menu <i class="fa-regular fa-arrow-right"></i> Admin <i class="fa-regular fa-arrow-right"></i> Settings <i class="fa-regular fa-arrow-right"></i> General <i class="fa-regular fa-arrow-right"></i> Kroki)

Set Kroki URL to `http://kroki` and enable all additional formats 

See `example.md` and commit to repository

---

## Jira

<i class="fa-brands fa-jira fa-4x" style="float: right;"></i>

[Integration of Jira](https://docs.gitlab.com/ee/integration/jira/) work items with code in GitLab

Two flavours - see [feature comparison](https://docs.gitlab.com/ee/integration/jira/#direct-feature-comparison)

### Jira issues integration

Connects [one or more project to a Jira instance](https://docs.gitlab.com/ee/integration/jira/configure.html)

- View and search Jira issues directly in GitLab
- Refer to Jira issues by ID in commits and merge requests
- Create Jira issues for vulnerabilities

### Jira development panel integration

Connects [all projects under a group to a Jira instance](https://docs.gitlab.com/ee/integration/jira/development_panel.html#configure-the-integration)

- View GitLab activity directly in Jira
