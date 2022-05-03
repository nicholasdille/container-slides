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

Run full web-based IDE using Gitpod [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://www.gitpod.io/ https://docs.gitlab.com/ee/integration/gitpod.html)

Uses web-based Visual Studio Code

Free tier of cloud service requires public servers

Self-hosted deployment requires Kubernetes

---

## Diagrams

<i class="fa-duotone fa-diagram-project fa-4x fa-duotone-colors-inverted" style="float: right;"></i>

Render diagrams from textual descriptions using Kroki [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://kroki.io/ https://docs.gitlab.com/ee/administration/integration/kroki.html)

Many examples [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://kroki.io/examples.html)

### Hands-On

Deploy in addition to GitLab:

```bash
docker compose --project-name gitlab \
    --file ../100_reverse_proxy/compose.traefik.yml \
    --file ../100_reverse_proxy/compose.gitlab.yml \
    --file compose.yml \
    up -d
```

Enable Kroki in web UI (Menu -> Admin -> Settings -> General -> Kroki)

Set Kroki URL: `http://kroki`

Enable all additional diagram formats

See `example.md` and commit to repository

---

## Jira

<i class="fa-brands fa-jira fa-4x fa-duotone-colors-inverted" style="float: right;"></i>

XXX https://docs.gitlab.com/ee/integration/jira/

XXX two flavours
