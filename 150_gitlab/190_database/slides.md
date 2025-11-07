<!-- .slide: id="gitlab_database" class="vertical-center" -->

<i class="fa-duotone fa-database fa-8x" style="float: right; color: grey;"></i>

## Database

---

## Database

<i class="fa-duotone fa-database fa-4x" style="float: right;"></i>

PostgreSQL is the only [supported database](https://docs.gitlab.com/omnibus/settings/database.html)
- Packaged Linux packages as well as Docker
- External instances are [supported](https://docs.gitlab.com/omnibus/settings/database.html#using-a-non-packaged-postgresql-database-management-server)

Mind the [version requirements](https://docs.gitlab.com/ee/install/requirements.html#postgresql-requirements)

### Multiple connections since v16

GitLab is preparing a separate database for CI/CD features

Two connections to single database since 16.0 (May 2023)

Disable second connection to [single database](https://docs.gitlab.com/omnibus/settings/database.html#configuring-multiple-database-connections)

Separate database required in 19.0 (May 2026)

Migration to second database is [not ready for production yet](https://docs.gitlab.com/ee/administration/postgresql/multiple_databases.html)

---

## Important database tables

<i class="fa-duotone fa-database fa-4x" style="float: right;"></i>

| Table        | Contents                                                                         |
|--------------|----------------------------------------------------------------------------------|
| users        | Users [<i class="fa fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_users)       |
| namespaces   | Groups [<i class="fa fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_projects)   |
| projects     | Projects [<i class="fa fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_projects) |
| ci_builds    | CI Jobs                                                                          |
| ci_pipelines | CI Pipelines                                                                     |
| ci_stages    | CI Stages                                                                        |
| ci_runners   | CI Runners [<i class="fa fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_runner) |

### Enter database

```
docker compose --project-name gitlab exec gitlab gitlab-psql
```

---

## Maintenance tasks

### Database migrations

Check status of database migrations [](https://docs.gitlab.com/administration/raketasks/maintenance/#display-status-of-database-migrations)

```bash
gitlab-rake db:migrate:status
```

Run incomplete database migrations [](https://docs.gitlab.com/administration/raketasks/maintenance/#run-incomplete-database-migrations)

```bash
gitlab-rake db:migrate
```

---

## Maintenance tasks

### Database housekeeping

Rebuild indexes [](https://docs.gitlab.com/administration/raketasks/maintenance/#rebuild-database-indexes)

```bash
gitlab-rake gitlab:db:reindex
```

Check database for inconsistencies [](https://docs.gitlab.com/administration/raketasks/maintenance/#check-the-database-for-schema-inconsistencies)

```bash
gitlab-rake gitlab:db:schema_checker:run
```

Repair indexes [](https://docs.gitlab.com/administration/raketasks/maintenance/#repair-corrupted-database-indexes)

```bash
DRY_RUN=true gitlab-rake gitlab:db:repair_index
```
