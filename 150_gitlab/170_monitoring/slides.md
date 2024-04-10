<!-- .slide: id="gitlab_monitoring" class="vertical-center" -->

<i class="fa-duotone fa-monitor-waveform fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Monitoring

---

## Monitoring

<i class="fa-duotone fa-monitor-waveform fa-4x fa-duotone-colors" style="float: right;"></i>

GitLab ships with Prometheus [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/omnibus/settings/grafana.html)

Grafana was removed in 16.3.0 (August 2023) [](https://docs.gitlab.com/ee/update/deprecations.html?removal_milestone=16.3#bundled-grafana-deprecated-and-disabled)

All components expose metrics

GitLab includes Prometheus exporters for all components

GitLab provides custom dashboards for import into Grafana [](https://gitlab.com/gitlab-org/grafana-dashboards)

---

## Hands-On

1. Start Grafana next to GitLab

    ```bash
    docker compose \
        --project-name gitlab \
        --file ../100_reverse_proxy/compose.yml \
        --file ../160_runner/compose.yml \
        --file ./compose.yml \
        up -d
    ```

1. Create datasource of type Prometheus with URL<br/>`http://gitlab:9090`

1. Import dashboard with ID 5774 [](https://grafana.com/grafana/dashboards/5774-gitlab-omnibus/)

1. Add link to Grafana: Admin Area <i class="fa-regular fa-arrow-right"></i> Settings <i class="fa-regular fa-arrow-right"></i> Metrics and profiling <i class="fa-regular fa-arrow-right"></i> Metrics - Grafana

1. Find link under: Admin Area <i class="fa-regular fa-arrow-right"></i> Monitoring <i class="fa-regular fa-arrow-right"></i> Metrics Dashboard

---

## GitLab CI Pipelines Exporter (GCPE)

<i class="fa-duotone fa-hose fa-4x fa-duotone-colors" style="float: right;"></i>

Prometheus exporter for pipelines [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://github.com/mvisonneau/gitlab-ci-pipelines-exporter) collecting...

- Pipeline results
- Job results
- Filter by projects
- Filter by branches

Meant to run as daemon

Regularly checks configured projects

Regularly discovers new projects
