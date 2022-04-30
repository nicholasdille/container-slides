<!-- .slide: class="vertical-center" -->

<i class="fa-duotone fa-handshake fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Integrations

---

## Advanced Search

<i class="fa-duotone fa-magnifying-glass-dollar fa-4x fa-duotone-colors-inverted" style="float: right;"></i>

XXX ElasticSearch https://docs.gitlab.com/ee/integration/elasticsearch.html

XXX requies premium license

XXX based on https://gitlab.com/gitlab-org/gitlab-elasticsearch-indexer

---

## Gitpod

<i class="fa-duotone fa-browser fa-4x fa-duotone-colors-inverted" style="float: right;"></i>

XXX Gitpod https://www.gitpod.io/ https://docs.gitlab.com/ee/integration/gitpod.html

XXX web-based Visual Studio Code

XXX requires k8s

XXX connect to public service?

### Hands-On

XXX enable in admin with https://gitpod.io/

XXX enable in user preferences

XXX note it only works for public repos because of auth... maybe eval with GitHub

---

## Diagrams

<i class="fa-duotone fa-diagram-project fa-4x fa-duotone-colors-inverted" style="float: right;"></i>

XXX Kroki https://kroki.io/ https://docs.gitlab.com/ee/administration/integration/kroki.html

XXX diagrams from textual descriptions

XXX examples https://kroki.io/examples.html

### Hands-On

XXX deploy with 100_reverse_proxy

```bash
docker compose --file ../100_reverse_proxy/compose.yml --file compose.yml up -d
```

XXX enable in web UI (menu -> admin -> settings -> general -> kroki)

XXX http://kroki

XXX example.md

---

## Jira

<i class="fa-brands fa-jira fa-4x fa-duotone-colors-inverted" style="float: right;"></i>

XXX https://docs.gitlab.com/ee/integration/jira/

XXX two flavours
