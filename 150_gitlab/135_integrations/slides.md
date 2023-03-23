<!-- .slide: id="gitlab_integrations" class="vertical-center" -->

<i class="fa-duotone fa-handshake fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Integrations

---

## Advanced Search

<i class="fa-duotone fa-magnifying-glass-dollar fa-4x fa-duotone-colors-inverted" style="float: right;"></i>

Full-text search across the instance using ElasticSearch [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/integration/elasticsearch.html)

Requires a premium license

Uses open-source project internally [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://gitlab.com/gitlab-org/gitlab-elasticsearch-indexer)

---

## Gitpod

<i class="fa-duotone fa-browser fa-4x fa-duotone-colors-inverted" style="float: right;"></i>

Run full web-based IDE [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/integration/gitpod.html) using Gitpod [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://www.gitpod.io/)

Uses web-based Visual Studio Code [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://vscode.dev/)

Free tier of cloud service requires public repositories

![](150_gitlab/135_integrations/gitpod.drawio.svg) <!-- .element: style="width: 60%;" -->

Self-hosted deployment requires Kubernetes

---

## Diagrams

<i class="fa-duotone fa-diagram-project fa-4x fa-duotone-colors-inverted" style="float: right;"></i>

Render diagrams from textual descriptions [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/administration/integration/kroki.html) using Kroki [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://kroki.io/)

### Hands-On

Deploy in addition to GitLab:

```bash
# Switch to directory for this topic
cd ../135_integrations

# Deploy kroki
docker compose --project-name gitlab \
    --file ../100_reverse_proxy/compose.yml \
    --file compose.yml \
    up -d
```

Enable Kroki in web UI (Menu <i class="fa-regular fa-arrow-right"></i> Admin <i class="fa-regular fa-arrow-right"></i> Settings <i class="fa-regular fa-arrow-right"></i> General <i class="fa-regular fa-arrow-right"></i> Kroki)

Set Kroki URL: `http://kroki`

See `example.md` and commit to repository

---

## Jira

<i class="fa-brands fa-jira fa-4x fa-duotone-colors-inverted" style="float: right;"></i>

Integration of Jira work items with code in GitLab [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/integration/jira/)

Two flavours

See feature comparison [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/integration/jira/#direct-feature-comparison)

### Jira integration

Connects one or more project to a Jira instance [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/integration/jira/configure.html)

### Jira development panel integration

Connects all projects under a group to a Jira instance [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/integration/jira/development_panel.html#configure-the-integration)
