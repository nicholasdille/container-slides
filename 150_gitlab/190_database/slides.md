<!-- .slide: id="gitlab_database" class="vertical-center" -->

<i class="fa-duotone fa-database fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Database

---

## Important database tables

<i class="fa-duotone fa-database fa-4x fa-duotone-colors" style="float: right;"></i>

| Table        | Contents                                                                         |
|--------------|----------------------------------------------------------------------------------|
| users        | Users [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_users)       |
| namespaces   | Groups [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_projects)   |
| projects     | Projects [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_projects) |
| ci_builds    | CI Jobs                                                                          |
| ci_pipelines | CI Pipelines                                                                     |
| ci_stages    | CI Stages                                                                        |
| ci_runners   | CI Runners [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_runner) |

### Enter database

```
docker compose --project-name gitlab exec gitlab gitlab-psql
```
